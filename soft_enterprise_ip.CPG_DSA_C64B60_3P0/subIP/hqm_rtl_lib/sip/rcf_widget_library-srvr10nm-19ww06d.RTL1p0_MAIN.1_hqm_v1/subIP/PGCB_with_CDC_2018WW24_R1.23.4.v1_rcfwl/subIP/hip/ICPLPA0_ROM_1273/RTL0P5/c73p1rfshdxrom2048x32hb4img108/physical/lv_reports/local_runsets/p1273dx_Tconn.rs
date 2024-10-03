// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tconn.rs.rca 1.84 Thu Jan  8 10:35:55 2015 kperrey Experimental $

// $Log: p1273dx_Tconn.rs.rca $
// 
//  Revision: 1.84 Thu Jan  8 10:35:55 2015 kperrey
//  hsd 2997; updates from Mahesh
// 
//  Revision: 1.83 Tue Dec 30 14:29:02 2014 kperrey
//  need to connect polycon to poly_glbcon since _drTreatGCNStrapAsReal now activates dummies which were previously ignored
// 
//  Revision: 1.82 Wed Nov 26 14:51:36 2014 kperrey
//  made 2nd poly_nores a poly_glbcon ; original rcextract code created open
// 
//  Revision: 1.81 Thu Oct 30 17:00:49 2014 kperrey
//  updates from srimathi ; vianores stomp on via update for rcextract
// 
//  Revision: 1.80 Sat Oct  4 17:51:01 2014 kperrey
//  updates from Srimathi
// 
//  Revision: 1.79 Thu Sep 25 12:57:58 2014 kperrey
//  hsd 2754 ; add the handling for _drICFDEVICES; add them into the connectivity
// 
//  Revision: 1.78 Thu Sep 25 10:13:03 2014 kperrey
//  hsd 2742 ; need to have/text poly_glbcon(poly - resid) layer for full texting to occur (handle text on the gate)
// 
//  Revision: 1.77 Fri Sep  5 13:13:57 2014 kperrey
//  in RCextract have to fully connect the stomped on VIA* layer
// 
//  Revision: 1.76 Sat Aug 16 12:50:24 2014 kperrey
//  moved drc checks to p1273dx_Tchks.rs ; VIA* now via*nores to support scv/scvx icf devices
// 
//  Revision: 1.75 Tue Aug  5 22:23:39 2014 kperrey
//  removed reference to scm/som/scv/sov devices and via*nores since they were not program approved enhancements as per chia-hong
// 
//  Revision: 1.74 Thu Jul 31 22:48:47 2014 kperrey
//  hsd 2425 ; support for sov/sovx/scv/scvm via resistors ; and the via*nores layer
// 
//  Revision: 1.73 Fri Jul 25 16:49:31 2014 kperrey
//  fix cut/paste typo; include file should be p12723_UserTextPriority.rs
// 
//  Revision: 1.72 Mon Jul 21 21:29:24 2014 kperrey
//  updated short_debugging = {vue_short_finder = true, static_output = {graphics = NONE, ascii = true}}
// 
//  Revision: 1.71 Mon Jul 21 20:52:44 2014 kperrey
//  add short_debugging = {static_output = {ascii = true}} if _drDumpAsciiShort is defined ; add in soft-connect include p12723_UserTextPriority.rs
// 
//  Revision: 1.70 Thu Jul 17 20:28:14 2014 kperrey
//  hsd 2567 ; connect mos_ngate_ulv1, mos_pgate_ulv1 by poly_nores ; bodies of nulv1/pulv1 gates
// 
//  Revision: 1.69 Thu Jul 17 11:29:58 2014 kperrey
//  include p1273dx_Tconn_sclmfc.rs for scaleable mfc support
// 
//  Revision: 1.68 Fri Jun 20 12:31:35 2014 kperrey
//  attempt to support nwell/nwellesd/pwellsubiso port/pins
// 
//  Revision: 1.67 Tue May 20 13:58:20 2014 kperrey
//  hsd 2392 ; change drNO to _drNO which is the actual define
// 
//  Revision: 1.66 Mon Apr 28 10:58:59 2014 kperrey
//  change connect name for SD_ERR check fix syntax errors
// 
//  Revision: 1.65 Mon Apr 14 09:23:51 2014 kperrey
//  add softconn check to ensure all gates within a STACKDEVTYPE are the same node
// 
//  Revision: 1.64 Fri Mar 14 16:12:57 2014 kperrey
//  add path rcext to includes as needed
// 
//  Revision: 1.63 Mon Mar  3 13:49:19 2014 kperrey
//  hsd 2165 ; remove poly_nores_nogate referance now just all poly_nores
// 
//  Revision: 1.62 Tue Feb 25 08:55:35 2014 kperrey
//  change how the rcextract is done do connect poly_nores_nogate
// 
//  Revision: 1.61 Thu Feb 20 19:57:46 2014 kperrey
//  hsd 2130; add mos_[np]gate_stk into connectivity
// 
//  Revision: 1.60 Thu Feb 20 07:51:38 2014 kperrey
//  hsd 2128 ; use the updated gate names for rf devices to be connected ; and remove all the original rf derivations since now all the derivation is in common
// 
//  Revision: 1.59 Wed Jan 29 16:33:03 2014 cpark3
//  corrected lowercase/uppercase for RC extraction
// 
//  Revision: 1.58 Wed Jan 15 11:32:48 2014 kperrey
//  change a #if _drRCextract to #if defined(_drRCextract)
// 
//  Revision: 1.57 Mon Jan  6 10:23:28 2014 cpark3
//  updated RC extraction switches, by adding, removing, updating switches
// 
//  Revision: 1.56 Sun Jan  5 15:58:29 2014 kperrey
//  connect the rf device type gates ; derive layers for calculation w/l/nf/ns since these are based upon connections
// 
//  Revision: 1.55 Thu Dec 26 20:05:53 2013 kperrey
//  change how VIRPKGROUTE connects to C4BEMIB; now connects by a VIRPKGVIA ; so you can now route VIRPKGROUTE over C4BEMIB w/o connecting to them ; enhancement from IDC
// 
//  Revision: 1.54 Wed Nov 13 10:18:02 2013 kperrey
//  virpkgroute should connect C4BEMIB instead of C4B
// 
//  Revision: 1.53 Wed Nov 13 07:36:21 2013 kperrey
//  include p12723_UserTextPriority.rs when can enable texting priority in the txt_trace_netlist_connect when there are shorts
// 
//  Revision: 1.52 Wed Nov  6 09:28:00 2013 kperrey
//  hsd 1941 ; enable unique HV list for mim gt 1.417
// 
//  Revision: 1.51 Tue Nov  5 15:57:14 2013 kperrey
//  MCR connects to m4nores by MTJ ; as per eric wang
// 
//  Revision: 1.50 Wed Oct 30 08:34:23 2013 kperrey
//  hsd 1926 ; add MCR derivations MCR connects to M4 by VCR
// 
//  Revision: 1.49 Mon Oct 14 12:13:24 2013 kperrey
//  allow VIRPKGROUTE to resolve die opens when _drVIRPKGROUTE is defined
// 
//  Revision: 1.48 Wed Oct  2 10:00:25 2013 kperrey
//  change C4B references to C4BEMIB which is the old C4B + new smaller C4EMIB bumps
// 
//  Revision: 1.47 Fri Sep 27 17:49:21 2013 kperrey
//  hsd 1869 ; define new variables not{Power/Ground} all{Power/Ground} based upon _dr_lvsLayoutPower and _dr_lvsLayoutGround; instead of VCC/VSS use allPower or allGround
// 
//  Revision: 1.46 Tue Jul 16 09:10:20 2013 kperrey
//  hsd 1808 ; moved TSV catchall to netlist connect ; build own connectivity model for vx_98 from the soft connect model
// 
//  Revision: 1.45 Mon Jun 10 09:32:40 2013 kperrey
//  add connectivity for perc djnw_cathode/anode
// 
//  Revision: 1.44 Fri Mar 22 08:52:42 2013 kperrey
//  add mos_n/pgate_tg160 to the connects for nal/pal160 support
// 
//  Revision: 1.43 Mon Jan 14 08:04:28 2013 kperrey
//  fix name usage LMI->LMIPAD ; text LMIPAD layer for the connects
// 
//  Revision: 1.42 Fri Jan 11 20:14:35 2013 kperrey
//  as per Kalyan; connect LMI to rdlnores
// 
//  Revision: 1.41 Fri Dec 28 12:00:07 2012 kperrey
//  added handling for NV3/PV3
// 
//  Revision: 1.40 Mon Dec 17 09:20:05 2012 kperrey
//  hsd 1458 ; need to remove ce1GND2Stack in determining ceNOM
// 
//  Revision: 1.39 Thu Dec 13 17:37:49 2012 kperrey
//  hsd 1430; start of support for MSR
// 
//  Revision: 1.38 Tue Oct 30 16:42:30 2012 kperrey
//  add a catch-all connect for TSV to diffcon/polycon/nsd/psd/poly these should never be in the catchcup region
// 
//  Revision: 1.37 Thu Oct 18 15:56:37 2012 kperrey
//  add rdl/rsv support
// 
//  Revision: 1.36 Wed Jul 25 10:44:43 2012 kperrey
//  hsd 1300 ; add subtaps within DIODEID into softcon check
// 
//  Revision: 1.35 Tue Jun 26 12:11:51 2012 kperrey
//  change to support trclvs/IPtm1 common module for Vx_98 checks
// 
//  Revision: 1.34 Wed May 16 08:28:50 2012 kperrey
//  get rid of precompiler warning for ignored undefined
// 
//  Revision: 1.33 Tue May 15 15:52:32 2012 kperrey
//  fix indiv connects for the bjt_base* layers had 2 ,, in a row
// 
//  Revision: 1.32 Tue May 15 15:41:45 2012 kperrey
//  add polyInterFace into the poly_nores_nogate connect ; add indiv connects for the bjt_base* layers
// 
//  Revision: 1.31 Tue May 15 11:32:47 2012 kperrey
//  for rcext ; connects with vias must be 2 layers 1 via
// 
//  Revision: 1.30 Mon May 14 21:54:56 2012 kperrey
//  ifdef connects for gcn/tcn/well/sub for rcextract mode
// 
//  Revision: 1.29 Mon May 14 17:04:13 2012 kperrey
//  rcext via/con type layers just cant be connected needs to be a by part of the connect
// 
//  Revision: 1.28 Tue May  8 10:44:00 2012 oakin
//  added mim chn waiver (Berni L.).
// 
//  Revision: 1.27 Mon May  7 15:19:09 2012 kperrey
//  removed the m10/m11Interface reference
// 
//  Revision: 1.26 Fri May  4 10:40:16 2012 kperrey
//  add support for skipping stuff with _drLVSONLY mimics _drSigPlot
// 
//  Revision: 1.25 Mon Apr 30 09:31:02 2012 kperrey
//  added partial text for mim construction soft_checks ; and txt_std_checks is always common now to STDCHECKS
// 
//  Revision: 1.24 Mon Apr 30 09:06:19 2012 kperrey
//  richa scarlet updates ; changes for stacked mims hv/ehv/uhv construction; removed mim_63 mim_62 mim_71
// 
//  Revision: 1.23 Fri Apr 13 08:30:44 2012 kperrey
//  fix variable names in some rcextract code
// 
//  Revision: 1.22 Tue Apr 10 11:41:33 2012 kperrey
//  for scarlet add else condition to init TLPins to empty
// 
//  Revision: 1.21 Mon Apr  9 15:09:50 2012 kperrey
//  add hooks for rcextract/scarlet
// 
//  Revision: 1.20 Wed Jan 18 09:14:13 2012 kperrey
//  maybe a change to how F2011.09 code handled substrate which was never really derived; now use buildsub to build __drsubrstate and globally replace substrate with __drsubstrate
// 
//  Revision: 1.19 Wed Jan 18 09:09:52 2012 kperrey
//  1272/p1272dx_Tcommon.rs
// 
//  Revision: 1.18 Wed Jan  4 10:48:54 2012 kperrey
//  make tap softcon check skipable due to bug in 2011 icv
// 
//  Revision: 1.17 Wed Jan  4 07:49:37 2012 kperrey
//  condition for drSoftCheck_ taps should be != _drx72b instead of == _drx72b
// 
//  Revision: 1.16 Tue Jan  3 18:07:50 2012 kperrey
//  turn off softchecks for welltaps/subtaps due to icv F-2011
// 
//  Revision: 1.15 Tue Dec 20 13:17:57 2011 kperrey
//  change mixed from MERGE_CONNECTED_AND_TOP to MERGE_TOP_THEN_CONNECTED - should be better match into how Intel thinks about opens and top-level; change softcon active nsd/psd from interacting with polycon to actually interacting with what we treat as active gate
// 
//  Revision: 1.14 Fri Dec  2 11:08:54 2011 kperrey
//  removed the m0 connection classification from the softcon checks ; since we already check anything we think is active
// 
//  Revision: 1.13 Mon Nov 21 15:28:36 2011 kperrey
//  relaxed the softwelltap/softsubtap checks ; allow to ignore connections only to nsd/psd that have gcn
// 
//  Revision: 1.12 Mon Oct 31 18:42:01 2011 kperrey
//  hsd 1019; for the SoftCOnnWelltap check change ALLNWELL to (NWELL or (NWELLESDDRAWN not WELLRES_ID)) ; will break teh NWELLESD into the unique resistor regions
// 
//  Revision: 1.11 Fri Oct 21 11:00:01 2011 kperrey
//  in the soft_connect (alt) dont text nwellesd
// 
//  Revision: 1.10 Fri Oct 21 10:58:10 2011 kperrey
//  add NV/PV0 (nuv0/puv0) devices and change nal/pal to nuva/puva
// 
//  Revision: 1.9 Wed Oct 19 15:15:31 2011 kperrey
//  hsd 994; add softchecks to flag active welltaps or subtaps in same well but different electrical node ; active means connected to s/d/g of device
// 
//  Revision: 1.8 Sat Oct  8 15:48:31 2011 kperrey
//  hsd 991; add support for d8xmesdclampres d8xsesdclamptgres ; assume prim name will ultimately follow naming convention d8 something
// 
//  Revision: 1.7 Tue Oct  4 17:32:41 2011 kperrey
//  skip the construction checks if _drSigPlot
// 
//  Revision: 1.6 Fri Sep 30 15:00:13 2011 kperrey
//  moved the function definitions to the common Tconn root p12723_Tconn.rs
// 
//  Revision: 1.5 Thu Sep 15 10:48:25 2011 kperrey
//  fix header
// 
//  Revision: 1.4 Wed Aug 31 17:32:49 2011 kperrey
//  add if (_drCaseSensitive == _drNO) to case of __drsubstrate text - default is insensitive UC; for some of the simple text selection just make is to include both texts
// 
//  Revision: 1.3 Fri Jul 22 09:35:36 2011 kperrey
//  modified v2 bridge and added v3/v4 bridge checks as per dipto
// 
//  Revision: 1.2 Thu Jul 21 15:15:38 2011 tmurata
//  updated the MIM checks for p1273 (two layer caps).
// 
//  Revision: 1.1 Wed Jul 13 22:39:09 2011 kperrey
//  mvfile on Wed Jul 13 22:39:09 2011 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p12723_Tconn.rs;1.29
// 
//  Revision: 1.29 Sun Jun 26 09:37:37 2011 oakin
//  added new 1273 devices.
// 
//  Revision: 1.28 Wed Apr 20 15:56:34 2011 kperrey
//  execute mimchecks only when ce1/2/3/tm1 are present; add mim72/73/74/75 checks; update v0_98 ; removed some comments obsolete mim71 functions and mim62 checks
// 
//  Revision: 1.27 Thu Apr 14 15:12:54 2011 kperrey
//  for mim_61 add ce[123]v11 to connect to tm1/m11 by VIA11 ; insteast ov ce[123]v11 being the only connector ; allows tm1/m11 shunting outside of the ce[123] plates
// 
//  Revision: 1.26 Fri Mar 25 08:22:03 2011 kperrey
//  added drNetSelectCNA function for bridge via checks ; moved what will always be checked and what will be DR_STDCHECKS controlled ; added bridge via checks (resistors break nodes power is node with tap
// 
//  Revision: 1.25 Tue Mar 22 16:24:27 2011 kperrey
//  add stuff for diffcon res; change _met*pin to met*bcpin ; add diffcon_nores into connects instead of DIFFCON
// 
//  Revision: 1.24 Fri Mar 18 10:49:15 2011 kperrey
//  change _METAL* naming convntion to METAL?BC and MET*RESID to MET*BCRESID
// 
//  Revision: 1.23 Fri Feb 18 08:44:16 2011 kperrey
//  change var names in the MIM71 check ; for MIM71 ce2 has to be floating (i.e. no via11)
// 
//  Revision: 1.22 Wed Feb 16 19:20:02 2011 kperrey
//  removed the _2txt layers and the reference to _drTEXTALL ; added MIM_62(hv/nom/gnd/other definitions and simplified checks - select by hv/nom/gnd everything else ; updated MIM_61 to allow only tm1 or m11 shunt ; coded mim_71 as function
// 
//  Revision: 1.21 Wed Feb  9 14:00:51 2011 oakin
//  removed temp MIM_71/62 defs.
// 
//  Revision: 1.20 Fri Jan 28 14:08:16 2011 kperrey
//  temp values for MIM_71 ; added drSoftcheck and drNetTextedWith functions ; add mim_61 checks by softcheck ; added to mim_62 check ce1 ground then ce2 has to be ground ; add mim_63 checks ; add mim_71 pulled from 1271
// 
//  Revision: 1.19 Wed Jan 26 16:08:45 2011 kperrey
//  give hook to use all text as created - instead of existing controlled texting of nwell/gcn/tcn
// 
//  Revision: 1.18 Tue Jan 25 22:39:50 2011 kperrey
//  dont do soft_connect texting for sigplots - since only need netlist based texting
// 
//  Revision: 1.17 Wed Jan 12 15:50:45 2011 kperrey
//  mte/mbe to ce1/ce2 name change ; add ce3 into connect
// 
//  Revision: 1.16 Tue Jan  4 16:10:35 2011 kperrey
//  modifified open/short reporting ; ifdef _drSCAlt then report shorts in softcon mode ; and no reporting during netlistcon
// 
//  Revision: 1.15 Tue Dec 21 22:06:57 2010 kperrey
//  add merged_violation_comment/renamed_violation_comment/shorted_violation_comment to the soft/netlist text commands
// 
//  Revision: 1.14 Mon Dec 20 19:19:10 2010 kperrey
//  change _MET?PORT to be _met?pin (due to naming change) ; text with _METAL? instead of METAL? ; move c4bump stamp and create_port earlier in run ; also use unique input/output connect db's
// 
//  Revision: 1.13 Mon Dec 13 15:43:39 2010 kperrey
//  have only 1 trace/lvs flow - but still do soft connect (alt) opens - but netlist once (std) ; remove trcview if/else and make unique soft/netlist connectivity models
// 
//  Revision: 1.12 Thu Dec  9 15:26:41 2010 kperrey
//  use empty_violation() to init Error layers
// 
//  Revision: 1.11 Tue Dec  7 14:38:18 2010 kperrey
//  added mos_n/pgate_av1/2 into poly_nores connect ; for n/paluv1/2 devices
// 
//  Revision: 1.10 Fri Oct 15 15:05:49 2010 kperrey
//  updated b8/c8 names to latest spec from S Zickel
// 
//  Revision: 1.9 Tue Oct 12 09:19:01 2010 kperrey
//  updated to reflect new/renamed device layers
// 
//  Revision: 1.8 Mon Sep 20 16:09:03 2010 kperrey
//  v0/mh/vh namechange vc/m0/v0
// 
//  Revision: 1.7 Thu Aug 26 21:45:56 2010 kperrey
//  add full-time support thru M11 - change how C4 ports are created (migrated from 1270/71)
// 
//  Revision: 1.6 Tue Aug 17 11:16:31 2010 kperrey
//  modified to also handle physical toplevel pins
// 
//  Revision: 1.5 Mon Aug 16 18:07:43 2010 kperrey
//  update MIM_62 check to allow more nodes and floating
// 
//  Revision: 1.4 Wed Aug 11 14:18:04 2010 kperrey
//  merge the connect statements - reorder connect from top to bottom of stack - change implementation of MIM waivers
// 
//  Revision: 1.3 Mon Aug  9 21:29:49 2010 kperrey
//  change DIFFCONPORT/POLYCONPORT/POLY1PORT to diffconpin/polyconpin/poly1pin which is the merged MW data
// 
//  Revision: 1.2 Wed Aug  4 23:23:03 2010 kperrey
//  added support for djn_esd and djp_esd
// 
//  Revision: 1.1 Thu Jul 22 14:04:57 2010 kperrey
//  mvfile on Thu Jul 22 14:04:57 2010 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p1272_Tconn.rs;1.5
// 
//  Revision: 1.5 Thu Jul 22 14:04:48 2010 kperrey
//  update 1272/12723 name change ; handle met0 and via0 ; remove tcn1/2 reference
// 
//  Revision: 1.4 Thu Jun 24 23:18:26 2010 kperrey
//  update _drGetBBPorts__ add _drFlatPortInteractOnly__ ; add 1271 device layers into connect
// 
//  Revision: 1.3 Wed Jun 23 20:37:39 2010 kperrey
//  remove the non-existent ind/mfc layers - handle merged primary/complements
// 
//  Revision: 1.2 Wed Jun 23 15:40:58 2010 kperrey
//  only have 1 file moved p1272d0_Tconn.rs to p1272_Tconn.rs
// 
//  Revision: 1.1 Tue May 25 15:04:40 2010 kperrey
//  from p1270
// 
//
//  converted from p1270d0_Tconn.rs

#ifndef _P1273DX_TCONN_RS_
#define _P1273DX_TCONN_RS_

// physical pin extraction (object touching(within 2 grid) or crossing TL boundary)
// create pinring for defining pins
tlPinRing = _drGeneratePinRing(TOPCELLBOUNDARY);

#ifdef _drRFblock
   poly_nores_rf = poly_nores and MET3RCSTOP;
   poly_nores = poly_nores not poly_nores_rf;

   poly_res_cl_rf = poly_res_cl and MET3RCSTOP;
   poly_res_cl = poly_res_cl not poly_res_cl_rf;

   polycon_nores_rf = polycon_nores and MET3RCSTOP;
   polycon_nores = polycon_nores not polycon_nores_rf;

   diffcon_nores_rf = diffcon_nores and MET3RCSTOP;
   diffcon_nores = diffcon_nores not diffcon_nores_rf;

   metal0nores_rf = metal0nores and MET3RCSTOP;
   metal0nores = metal0nores not metal0nores_rf;

   metal1nores_rf = metal1nores and MET3RCSTOP;
   metal1nores = metal1nores not metal1nores_rf;

   metal2nores_rf = metal2nores and MET3RCSTOP;
   metal2nores = metal2nores not metal2nores_rf;

   metal3nores_rf = metal3nores and MET3RCSTOP;
   metal3nores = metal3nores not metal3nores_rf;

   //vias

   VIACONG_rf = VIACONG and MET3RCSTOP;
   VIACONG = VIACONG not VIACONG_rf;

   VIACONT_rf = VIACONT and MET3RCSTOP;
   VIACONT = VIACONT not VIACONT_rf;

   VIA0_rf = via0nores and MET3RCSTOP;
   via0nores = via0nores not VIA0_rf;

   VIA1_rf = via1nores and MET3RCSTOP;
   via1nores = via1nores not VIA1_rf;

   VIA2_rf = via2nores and MET3RCSTOP;
   via2nores = via2nores not VIA2_rf;

#endif

#if ( !defined(_drRCextract) || (defined(_drPinTopBoundary) && defined(_drRCextract))) // Scarlet control
   // get real interface objects only do the metal objects
   m0TLPin = _drGetTopLevelPins__(metal0nores, tlPinRing );
   metal0nores = copy(_drFlatPortInteract__(metal0nores, m0TLPin));
   m1TLPin = _drGetTopLevelPins__(metal1nores, tlPinRing );
   metal1nores = copy(_drFlatPortInteract__(metal1nores, m1TLPin));
   m2TLPin = _drGetTopLevelPins__(metal2nores, tlPinRing );
   metal2nores = copy(_drFlatPortInteract__(metal2nores, m2TLPin));
   m3TLPin = _drGetTopLevelPins__(metal3nores, tlPinRing );
   metal3nores = copy(_drFlatPortInteract__(metal3nores, m3TLPin));
   #ifdef _drRFblock
     m0TLPin_rf = _drGetTopLevelPins__(metal0nores_rf, tlPinRing );
     metal0nores_rf = copy(_drFlatPortInteract__(metal0nores_rf, m0TLPin_rf));
     m1TLPin_rf = _drGetTopLevelPins__(metal1nores_rf, tlPinRing );
     metal1nores_rf = copy(_drFlatPortInteract__(metal1nores_rf, m1TLPin_rf));
     m2TLPin_rf = _drGetTopLevelPins__(metal2nores_rf, tlPinRing );
     metal2nores_rf = copy(_drFlatPortInteract__(metal2nores_rf, m2TLPin_rf));
     m3TLPin_rf = _drGetTopLevelPins__(metal3nores_rf, tlPinRing );
     metal3nores_rf = copy(_drFlatPortInteract__(metal3nores_rf, m3TLPin_rf));
   #endif
   m4TLPin = _drGetTopLevelPins__(metal4nores, tlPinRing );
   metal4nores = copy(_drFlatPortInteract__(metal4nores, m4TLPin));
   m5TLPin = _drGetTopLevelPins__(metal5nores, tlPinRing );
   metal5nores = copy(_drFlatPortInteract__(metal5nores, m5TLPin));
   m6TLPin = _drGetTopLevelPins__(metal6nores, tlPinRing );
   metal6nores = copy(_drFlatPortInteract__(metal6nores, m6TLPin));
   m7TLPin = _drGetTopLevelPins__(metal7nores, tlPinRing );
   metal7nores = copy(_drFlatPortInteract__(metal7nores, m7TLPin));
   m8TLPin = _drGetTopLevelPins__(metal8nores, tlPinRing );
   metal8nores = copy(_drFlatPortInteract__(metal8nores, m8TLPin));
   m9TLPin = _drGetTopLevelPins__(metal9nores, tlPinRing );
   metal9nores = copy(_drFlatPortInteract__(metal9nores, m9TLPin));
   tm1TLPin = _drGetTopLevelPins__(tm1nores, tlPinRing );
   tm1nores = copy(_drFlatPortInteract__(tm1nores, tm1TLPin));
   rdlTLPin = _drGetTopLevelPins__(rdlnores, tlPinRing );
   rdlnores = copy(_drFlatPortInteract__(rdlnores, rdlTLPin));
   mcrTLPin = _drGetTopLevelPins__(mcrnores, tlPinRing );
   mcrnores = copy(_drFlatPortInteract__(mcrnores, mcrTLPin));
#else
   // force TLPin to be empty
   m0TLPin = empty_layer();
   m1TLPin = empty_layer();
   m2TLPin = empty_layer();
   m3TLPin = empty_layer();
   m4TLPin = empty_layer();
   m5TLPin = empty_layer();
   m6TLPin = empty_layer();
   m7TLPin = empty_layer();
   m8TLPin = empty_layer();
   m9TLPin = empty_layer();
   tm1TLPin = empty_layer();
   rdlTLPin = empty_layer();
   mcrTLPin = empty_layer();
#endif

//
// get Synopsys ports 
// this should be short term work-around  using _drFlatPortInteract
// added the extra copy to get the right name - workaround from Keith for the
// name lost (newRoutLayer) for reporting opens/shorts 
// only get a drawn diffconPort and not a propagate diffconport - control data size

#if defined(_drRCextract)
   // rcext pins
   slie1_diffcon = diffconpin and [processing_mode = CELL_LEVEL] (SLIE1 not DIFFCONRESID);
   diffcon_nores = diffcon_nores or slie1_diffcon;
   slie1_polycon = polyconpin and [processing_mode = CELL_LEVEL] (SLIE1 not POLYCONRESID);
   polycon_nores = polycon_nores or slie1_polycon;
   slie1_poly = poly1pin and [processing_mode = CELL_LEVEL] (SLIE1 not PRES_ID);
   poly_nores = poly_nores or slie1_poly;
   slie1_m0 = met0bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET0BCRESID);
   metal0nores = metal0nores or slie1_m0;
   slie1_m1 = met1bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET1BCRESID);
   metal1nores = metal1nores or slie1_m1;
   slie1_m2 = met2bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET2BCRESID);
   metal2nores = metal2nores or slie1_m2;
   slie1_m3 = met3bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET3BCRESID);
   metal3nores = metal3nores or slie1_m3;
   #ifdef _drRFblock
     diffconpin_rf = diffconpin and MET3RCSTOP;
     diffconpin = diffconpin not diffconpin_rf;
     polyconpin_rf = polyconpin and MET3RCSTOP;
     polyconpin = polyconpin not polyconpin_rf;
     poly1pin_rf = poly1pin and MET3RCSTOP;
     poly1pin = poly1pin not poly1pin_rf;
     met0bcpin_rf = met0bcpin and MET3RCSTOP;
     met0bcpin = met0bcpin not met0bcpin_rf;
     met1bcpin_rf = met1bcpin and MET3RCSTOP;
     met1bcpin = met1bcpin not met1bcpin_rf;
     met2bcpin_rf = met2bcpin and MET3RCSTOP;
     met2bcpin = met2bcpin not met2bcpin_rf;
     met3bcpin_rf = met3bcpin and MET3RCSTOP;
     met3bcpin = met3bcpin not met3bcpin_rf;
     slie1_diffcon_rf = diffconpin_rf and [processing_mode = CELL_LEVEL] (SLIE1 not DIFFCONRESID);
     diffcon_nores_rf = diffcon_nores_rf or slie1_diffcon_rf;
     slie1_polycon_rf = polyconpin_rf and [processing_mode = CELL_LEVEL] (SLIE1 not POLYCONRESID);
     polycon_nores_rf = polycon_nores_rf or slie1_polycon_rf;
     slie1_poly_rf = poly1pin_rf and [processing_mode = CELL_LEVEL] (SLIE1 not PRES_ID);
     poly_nores_rf = poly_nores_rf or slie1_poly_rf;
     slie1_m0_rf = met0bcpin_rf and [processing_mode = CELL_LEVEL] (SLIE1 not MET0BCRESID);
     metal0nores_rf = metal0nores_rf or slie1_m0_rf;
     slie1_m1_rf = met1bcpin_rf and [processing_mode = CELL_LEVEL] (SLIE1 not MET1BCRESID);
     metal1nores_rf = metal1nores_rf or slie1_m1_rf;
     slie1_m2_rf = met2bcpin_rf and [processing_mode = CELL_LEVEL] (SLIE1 not MET2BCRESID);
     metal2nores_rf = metal2nores_rf or slie1_m2_rf;
     slie1_m3_rf = met3bcpin_rf and [processing_mode = CELL_LEVEL] (SLIE1 not MET3BCRESID);
     metal3nores_rf = metal3nores_rf or slie1_m3_rf;
   #endif
   slie1_m4 = met4bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET4BCRESID);
   metal4nores = metal4nores or slie1_m4;
   slie1_m5 = met5bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET5BCRESID);
   metal5nores = metal5nores or slie1_m5;
   slie1_m6 = met6bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET6BCRESID);
   metal6nores = metal6nores or slie1_m6;
   slie1_m7 = met7bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET7BCRESID);
   metal7nores = metal7nores or slie1_m7;
   slie1_m8 = met8bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET8BCRESID);
   metal8nores = metal8nores or slie1_m8;
   slie1_m9 = met9bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not MET9BCRESID);
   metal9nores = metal9nores or slie1_m9;
   slie1_tm1 = tm1bcpin and [processing_mode = CELL_LEVEL] (SLIE1 not TM1BCRESID);
   tm1nores = tm1nores or slie1_tm1;
   slie1_rdl = rdlpin and [processing_mode = CELL_LEVEL]  (SLIE1 not RDLRESID);
   rdlnores =  rdlnores or slie1_rdl;
   slie1_mcr = mcrpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MCRRESID);
   mcrnores =  mcrnores or slie1_mcr;
#endif

nwellTLPort = _drGetTopLevelPorts__(nwellpin);
nwell_nores = copy(_drFlatPortInteract__(nwell_nores, nwellTLPort));
nwellesdTLPort = _drGetTopLevelPorts__(nwellesdpin);
nwellesd_nores = copy(_drFlatPortInteract__(nwellesd_nores, nwellesdTLPort));
diffconTLPort = _drGetTopLevelPorts__(diffconpin);
diffcon_nores = copy(_drFlatPortInteract__(diffcon_nores, diffconTLPort));
polyconTLPort = _drGetTopLevelPorts__(polyconpin);
polycon_nores = copy(_drFlatPortInteract__(polycon_nores, polyconTLPort));
polyTLPort = _drGetTopLevelPorts__(poly1pin);
poly_nores = copy(_drFlatPortInteract__(poly_nores, polyTLPort));
m0TLPort = _drGetTopLevelPorts__(met0bcpin);
metal0nores = copy(_drFlatPortInteract__(metal0nores, m0TLPort));
m1TLPort = _drGetTopLevelPorts__(met1bcpin);
metal1nores = copy(_drFlatPortInteract__(metal1nores, m1TLPort));
m2TLPort = _drGetTopLevelPorts__(met2bcpin);
metal2nores = copy(_drFlatPortInteract__(metal2nores, m2TLPort));
m3TLPort = _drGetTopLevelPorts__(met3bcpin);
metal3nores = copy(_drFlatPortInteract__(metal3nores, m3TLPort));
#ifdef _drRFblock
diffconTLPort_rf = _drGetTopLevelPorts__(diffconpin_rf);
polyconTLPort_rf = _drGetTopLevelPorts__(polyconpin_rf);
polyTLPort_rf = _drGetTopLevelPorts__(poly1pin_rf);
m0TLPort_rf = _drGetTopLevelPorts__(met0bcpin_rf);
m1TLPort_rf = _drGetTopLevelPorts__(met1bcpin_rf);
m2TLPort_rf = _drGetTopLevelPorts__(met2bcpin_rf);
m3TLPort_rf = _drGetTopLevelPorts__(met3bcpin_rf);
diffcon_nores_rf = copy(_drFlatPortInteract__(diffcon_nores_rf, diffconTLPort_rf));
polycon_nores_rf = copy(_drFlatPortInteract__(polycon_nores_rf, polyconTLPort_rf));
poly_nores_rf = copy(_drFlatPortInteract__(poly_nores_rf, polyTLPort_rf));
metal0nores_rf = copy(_drFlatPortInteract__(metal0nores_rf, m0TLPort_rf));
metal1nores_rf = copy(_drFlatPortInteract__(metal1nores_rf, m1TLPort_rf));
metal2nores_rf = copy(_drFlatPortInteract__(metal2nores_rf, m2TLPort_rf));
metal3nores_rf = copy(_drFlatPortInteract__(metal3nores_rf, m3TLPort_rf));
#endif
m4TLPort = _drGetTopLevelPorts__(met4bcpin);
metal4nores = copy(_drFlatPortInteract__(metal4nores, m4TLPort));
m5TLPort = _drGetTopLevelPorts__(met5bcpin);
metal5nores = copy(_drFlatPortInteract__(metal5nores, m5TLPort));
m6TLPort = _drGetTopLevelPorts__(met6bcpin);
metal6nores = copy(_drFlatPortInteract__(metal6nores, m6TLPort));
m7TLPort = _drGetTopLevelPorts__(met7bcpin);
metal7nores = copy(_drFlatPortInteract__(metal7nores, m7TLPort));
m8TLPort = _drGetTopLevelPorts__(met8bcpin);
metal8nores = copy(_drFlatPortInteract__(metal8nores, m8TLPort));
m9TLPort = _drGetTopLevelPorts__(met9bcpin);
metal9nores = copy(_drFlatPortInteract__(metal9nores, m9TLPort));
tm1TLPort = _drGetTopLevelPorts__(tm1bcpin);
tm1nores = copy(_drFlatPortInteract__(tm1nores, tm1TLPort));
rdlTLPort = _drGetTopLevelPorts__(rdlpin);
rdlnores = copy(_drFlatPortInteract__(rdlnores, rdlTLPort));
mcrTLPort = _drGetTopLevelPorts__(mcrpin);
mcrnores = copy(_drFlatPortInteract__(mcrnores, mcrTLPort));

// special handling for c4b/bumps
c4bPort = flatten_by_cells(C4BEMIB, cells = { "*" });
c4bump = copy(c4bPort);

// get ports for the bb template cells 
#if defined(_drRCextract)
   nwellPort = _drGetBBPorts__(drawnPortLayer = nwellpin, drawnDataLayer = nwell_nores) or nwellpin;
   nwellesdPort = _drGetBBPorts__(drawnPortLayer = nwellesdpin, drawnDataLayer = nwellesd_nores) or nwellesdpin;
   diffconPort = _drGetBBPorts__(drawnPortLayer = diffconpin, drawnDataLayer = diffcon_nores) or diffconpin;
   polyconPort = _drGetBBPorts__(drawnPortLayer = polyconpin, drawnDataLayer = polycon_nores) or polyconpin;
   polyPort = _drGetBBPorts__(drawnPortLayer = poly1pin, drawnDataLayer = poly_nores) or poly1pin;
   m0Port = _drGetBBPorts__(drawnPortLayer = met0bcpin, drawnDataLayer = metal0nores) or met0bcpin;
   m1Port = _drGetBBPorts__(drawnPortLayer = met1bcpin, drawnDataLayer = metal1nores) or met1bcpin;
   m2Port = _drGetBBPorts__(drawnPortLayer = met2bcpin, drawnDataLayer = metal2nores) or met2bcpin;
   m3Port = _drGetBBPorts__(drawnPortLayer = met3bcpin, drawnDataLayer = metal3nores) or met3bcpin;
   #ifdef _drRFblock
     diffconPort_rf = _drGetBBPorts__(drawnPortLayer = diffconpin_rf, drawnDataLayer = diffcon_nores_rf) or diffconpin_rf;
     polyconPort_rf = _drGetBBPorts__(drawnPortLayer = polyconpin_rf, drawnDataLayer = polycon_nores_rf) or polyconpin_rf;
     polyPort_rf = _drGetBBPorts__(drawnPortLayer = poly1pin_rf, drawnDataLayer = poly_nores_rf) or poly1pin_rf;
     m0Port_rf = _drGetBBPorts__(drawnPortLayer = met0bcpin_rf, drawnDataLayer = metal0nores_rf) or met0bcpin_rf;
     m1Port_rf = _drGetBBPorts__(drawnPortLayer = met1bcpin_rf, drawnDataLayer = metal1nores_rf) or met1bcpin_rf;
     m2Port_rf = _drGetBBPorts__(drawnPortLayer = met2bcpin_rf, drawnDataLayer = metal2nores_rf) or met2bcpin_rf;
     m3Port_rf = _drGetBBPorts__(drawnPortLayer = met3bcpin_rf, drawnDataLayer = metal3nores_rf) or met3bcpin_rf;
   #endif
   m4Port = _drGetBBPorts__(drawnPortLayer = met4bcpin, drawnDataLayer = metal4nores) or met4bcpin;
   m5Port = _drGetBBPorts__(drawnPortLayer = met5bcpin, drawnDataLayer = metal5nores) or met5bcpin;
   m6Port = _drGetBBPorts__(drawnPortLayer = met6bcpin, drawnDataLayer = metal6nores) or met6bcpin;
   m7Port = _drGetBBPorts__(drawnPortLayer = met7bcpin, drawnDataLayer = metal7nores) or met7bcpin;
   m8Port = _drGetBBPorts__(drawnPortLayer = met8bcpin, drawnDataLayer = metal8nores) or met8bcpin;
   m9Port = _drGetBBPorts__(drawnPortLayer = met9bcpin, drawnDataLayer = metal9nores) or met9bcpin;
   tm1Port = _drGetBBPorts__(drawnPortLayer = tm1bcpin, drawnDataLayer = tm1nores) or tm1bcpin;
   rdlPort = _drGetBBPorts__(drawnPortLayer = rdlpin, drawnDataLayer = rdlnores) or rdlpin;
   mcrPort = _drGetBBPorts__(drawnPortLayer = mcrpin, drawnDataLayer = mcrnores) or mcrpin;
#else
   nwellPort = _drGetBBPorts__(drawnPortLayer = nwellpin, drawnDataLayer = nwell_nores) or nwellTLPort;
   nwellesdPort = _drGetBBPorts__(drawnPortLayer = nwellesdpin, drawnDataLayer = nwellesd_nores) or nwellesdTLPort;
   diffconPort = _drGetBBPorts__(drawnPortLayer = diffconpin, drawnDataLayer = diffcon_nores) or diffconTLPort;
   polyconPort = _drGetBBPorts__(drawnPortLayer = polyconpin, drawnDataLayer = polycon_nores) or polyconTLPort;
   polyPort = _drGetBBPorts__(drawnPortLayer = poly1pin, drawnDataLayer = poly_nores) or polyTLPort;
   m0Port = _drGetBBPorts__(drawnPortLayer = met0bcpin, drawnDataLayer = metal0nores) or m0TLPort;
   m1Port = _drGetBBPorts__(drawnPortLayer = met1bcpin, drawnDataLayer = metal1nores) or m1TLPort;
   m2Port = _drGetBBPorts__(drawnPortLayer = met2bcpin, drawnDataLayer = metal2nores) or m2TLPort;
   m3Port = _drGetBBPorts__(drawnPortLayer = met3bcpin, drawnDataLayer = metal3nores) or m3TLPort;
   m4Port = _drGetBBPorts__(drawnPortLayer = met4bcpin, drawnDataLayer = metal4nores) or m4TLPort;
   m5Port = _drGetBBPorts__(drawnPortLayer = met5bcpin, drawnDataLayer = metal5nores) or m5TLPort;
   m6Port = _drGetBBPorts__(drawnPortLayer = met6bcpin, drawnDataLayer = metal6nores) or m6TLPort;
   m7Port = _drGetBBPorts__(drawnPortLayer = met7bcpin, drawnDataLayer = metal7nores) or m7TLPort;
   m8Port = _drGetBBPorts__(drawnPortLayer = met8bcpin, drawnDataLayer = metal8nores) or m8TLPort;
   m9Port = _drGetBBPorts__(drawnPortLayer = met9bcpin, drawnDataLayer = metal9nores) or m9TLPort;
   tm1Port = _drGetBBPorts__(drawnPortLayer = tm1bcpin, drawnDataLayer = tm1nores) or tm1TLPort;
   rdlPort = _drGetBBPorts__(drawnPortLayer = rdlpin, drawnDataLayer = rdlnores) or rdlTLPort;
   mcrPort = _drGetBBPorts__(drawnPortLayer = mcrpin, drawnDataLayer = mcrnores) or mcrTLPort;
#endif

// merge the ports pins into 1 interface object
nwellInterFace = copy(nwellPort);
nwellesdInterFace = copy(nwellesdPort);
polyInterFace = copy(polyPort);
polyconInterFace = copy(polyconPort);
diffconInterFace = copy(diffconPort);
#if (defined(_drRCextract) && !defined(_drPinTopBoundary))
   m0InterFace = copy(m0Port);
   m1InterFace = copy(m1Port);
   m2InterFace = copy(m2Port);
   m3InterFace = copy(m3Port);
   #ifdef _drRFblock
      polyInterFace_rf = copy(polyPort_rf);
      polyconInterFace_rf = copy(polyconPort_rf);
      diffconInterFace_rf = copy(diffconPort_rf);
      m0InterFace_rf = copy(m0Port_rf);
      m1InterFace_rf = copy(m1Port_rf);
      m2InterFace_rf = copy(m2Port_rf);
      m3InterFace_rf = copy(m3Port_rf);
   #endif
   m4InterFace = copy(m4Port);
   m5InterFace = copy(m5Port);
   m6InterFace = copy(m6Port);
   m7InterFace = copy(m7Port);
   m8InterFace = copy(m8Port);
   m9InterFace = copy(m9Port);
   tm1InterFace = copy(tm1Port);
   rdlInterFace = copy(rdlPort);
   mcrInterFace = copy(mcrPort);
#else
   m0InterFace = m0Port or m0TLPin;
   m1InterFace = m1Port or m1TLPin;
   m2InterFace = m2Port or m2TLPin;
   m3InterFace = m3Port or m3TLPin;
   m4InterFace = m4Port or m4TLPin;
   m5InterFace = m5Port or m5TLPin;
   m6InterFace = m6Port or m6TLPin;
   m7InterFace = m7Port or m7TLPin;
   m8InterFace = m8Port or m8TLPin;
   m9InterFace = m9Port or m9TLPin;
   tm1InterFace = tm1Port or tm1TLPin;
   rdlInterFace = rdlPort or rdlTLPin;
   mcrInterFace = mcrPort or mcrTLPin;
#endif
c4bInterFace = copy(c4bPort);

#if defined(_drRCextract) 
   VIA0 = copy(via0nores);
   VIA1 = copy(via1nores);
   VIA2 = copy(via2nores);
   VIA3 = copy(via3nores);
   VIA4 = copy(via4nores);
   VIA5 = copy(via5nores);
   VIA6 = copy(via6nores);
   VIA7 = copy(via7nores);
   VIA8 = copy(via8nores);
   VIA9 = copy(via9nores);
   VIA10 = copy(via10nores);
   VIA11 = copy(via11nores);
   VIA12 = copy(via12nores);

   #ifdef _drRCextractUnimp
      #include <rcext/unimp_net_create.rs>

      gcn_tcn = polycon_nores and diffcon_nores;
      gcn_unimp_tcn = polycon_nores and unimp_diffcon_nores;
      unimp_gcn_tcn = unimp_polycon_nores and diffcon_nores;
      gcn_tcn = gcn_tcn or gcn_unimp_tcn;
      gcn_tcn = gcn_tcn or unimp_gcn_tcn;
      unimp_polycon_nores = unimp_polycon_nores not gcn_tcn;
   #else
      gcn_tcn = polycon_nores and diffcon_nores;
      #ifdef _drRFblock
        gcn_tcn_rf = polycon_nores_rf and diffcon_nores_rf; 
        gcn_tcn = gcn_tcn not gcn_tcn_rf;
      #endif
   #endif
   polycon_nores = polycon_nores not gcn_tcn;
   poly_nores = poly_nores not p_dummy_gate_fbd;
   #ifdef _drRFblock
      polycon_nores_rf = polycon_nores_rf not gcn_tcn_rf;
      poly_nores_rf = poly_nores_rf not p_dummy_gate_fbd;
   #endif

   // grow poly pullback for device parameters and iso 
   gate_w_gcn_ext = dr_poly_diff_enc_COMMON interacting [processing_mode = CELL_LEVEL] gate_w_gcn;
   gate_w_gcn_iso = polygon_extents(gate_w_gcn or gate_w_gcn_ext);
   POLYiso = POLY not gate_w_gcn;
   POLYiso = POLYiso or gate_w_gcn_iso;
   nsd = nsd not POLYiso;
   psd = psd not POLYiso;
   all_sd_iso = all_sd not POLYiso;
   #ifdef _drRFblock

      nsd_rf = nsd and MET3RCSTOP;
      nsd = nsd not nsd_rf;

      psd_rf = psd and MET3RCSTOP;
      psd = psd not psd_rf;
        
      npickup_rf = npickup and MET3RCSTOP;
      npickup = npickup not npickup_rf;

      vdsource_rf = vdsource and MET3RCSTOP;
      vdsource = vdsource not vdsource_rf;

      vddrain_rf = vddrain and MET3RCSTOP;
      vddrain = vddrain not vddrain_rf;

      vsdsrc_rf = vsdsrc and MET3RCSTOP;
      vsdsrc = vsdsrc not vsdsrc_rf;

      nac_cathode_rf = nac_cathode and MET3RCSTOP;
      nac_cathode = nac_cathode not nac_cathode_rf;

      nac_cathode_esd_rf = nac_cathode_esd and MET3RCSTOP;
      nac_cathode_esd = nac_cathode_esd not nac_cathode_esd_rf;

      ppickup_rf = ppickup and MET3RCSTOP;
      ppickup = ppickup not ppickup_rf;

      anode_rf = anode and MET3RCSTOP;
      anode = anode not anode_rf;

      anode_nbjt_rf = anode_nbjt and MET3RCSTOP;
      anode_nbjt = anode_nbjt not anode_nbjt_rf;

      anode_nbjt_esd_rf = anode_nbjt_esd and MET3RCSTOP;
      anode_nbjt_esd = anode_nbjt_esd not anode_nbjt_esd_rf;

      bjt_collector_rf = bjt_collector and MET3RCSTOP;
      bjt_collector = bjt_collector not bjt_collector_rf;

      bjt_collector_1_rf = bjt_collector_1 and MET3RCSTOP;
      bjt_collector_1 = bjt_collector_1 not bjt_collector_1_rf;

      bjt_collector_2_rf = bjt_collector_2 and MET3RCSTOP;
      bjt_collector_2 = bjt_collector_2 not bjt_collector_2_rf;

      bjt_emitter_rf = bjt_emitter and MET3RCSTOP;
      bjt_emitter = bjt_emitter not bjt_emitter_rf;

      bjt_emitter_1_rf = bjt_emitter_1 and MET3RCSTOP;
      bjt_emitter_1 = bjt_emitter_1 not bjt_emitter_1_rf;

      bjt_emitter_2_rf = bjt_emitter_2 and MET3RCSTOP;
      bjt_emitter_2 = bjt_emitter_2 not bjt_emitter_2_rf;

      int_diode_err_rf = int_diode_err and MET3RCSTOP;
      int_diode_err = int_diode_err not int_diode_err_rf;
   #endif
#endif

#ifdef _drDEBUG
   drPassthruStack.push_back({polyPort, {102,105} }); // poly port
   drPassthruStack.push_back({m0Port, {155,105} }); // m0 port
   drPassthruStack.push_back({m1Port, {104,105} }); // m1 port
   drPassthruStack.push_back({diffconPort, {105,105} }); // diffcon port
   drPassthruStack.push_back({polyconPort, {106,105} }); // polyconcon port
   drPassthruStack.push_back({m2Port, {114,105} }); // m2 port
   drPassthruStack.push_back({m3Port, {118,105} }); // m3 port
   drPassthruStack.push_back({m4Port, {122,105} }); // m4 port
   drPassthruStack.push_back({m5Port, {126,105} }); // m5 port
   drPassthruStack.push_back({m6Port, {130,105} }); // m6 port
   drPassthruStack.push_back({m7Port, {134,105} }); // m7 port
   drPassthruStack.push_back({m8Port, {138,105} }); // m8 port
   drPassthruStack.push_back({m9Port, {146,105} }); // m9 port
   drPassthruStack.push_back({tm1Port, {142,105} }); // tm1 port
   drPassthruStack.push_back({c4bPort, {92,105} }); // c4b port

   drPassthruStack.push_back({tlPinRing, {150,107} }); //  ring to create pins
   drPassthruStack.push_back({m1TLPin, {104,107} }); // m1 pin
   drPassthruStack.push_back({m0TLPin, {155,107} }); // m0 pin
   drPassthruStack.push_back({m2TLPin, {114,107} }); // m2 pin
   drPassthruStack.push_back({m3TLPin, {118,107} }); // m3 pin
   drPassthruStack.push_back({m4TLPin, {122,107} }); // m4 pin
   drPassthruStack.push_back({m5TLPin, {126,107} }); // m5 pin
   drPassthruStack.push_back({m6TLPin, {130,107} }); // m6 pin
   drPassthruStack.push_back({m7TLPin, {134,107} }); // m7 pin
   drPassthruStack.push_back({m8TLPin, {138,107} }); // m8 pin
   drPassthruStack.push_back({m9TLPin, {146,107} }); // m9 pin
   drPassthruStack.push_back({tm1TLPin, {142,107} }); // tm1 pin

   drPassthruStack.push_back({polyInterFace, {102,108} }); // poly interface
   drPassthruStack.push_back({m1InterFace, {104,108} }); // m1 interface
   drPassthruStack.push_back({m0InterFace, {155,108} }); // m0 interface
   drPassthruStack.push_back({diffconInterFace, {105,108} }); // diffcon interface
   drPassthruStack.push_back({polyconInterFace, {106,108} }); // polyconcon interface
   drPassthruStack.push_back({m2InterFace, {114,108} }); // m2 interface
   drPassthruStack.push_back({m3InterFace, {118,108} }); // m3 interface
   drPassthruStack.push_back({m4InterFace, {122,108} }); // m4 interface
   drPassthruStack.push_back({m5InterFace, {126,108} }); // m5 interface
   drPassthruStack.push_back({m6InterFace, {130,108} }); // m6 interface
   drPassthruStack.push_back({m7InterFace, {134,108} }); // m7 interface
   drPassthruStack.push_back({m8InterFace, {138,108} }); // m8 interface
   drPassthruStack.push_back({m9InterFace, {146,108} }); // m9 interface
   drPassthruStack.push_back({tm1InterFace, {142,108} }); // tm1 interface
   drPassthruStack.push_back({c4bInterFace, {92,108} }); // c4b interface
#endif


// this is equivalent to alternate trace
// active opens/soft-connects code
trace_soft_connect = connect(
   connect_items = {
// handle virtual package route to resolve die opens
      #if (defined(_drVIRPKGROUTE) && _drFULL_DIE == _drYES)
         {layers = {C4BEMIB, VIRPKGROUTE}, by_layer = VIRPKGVIA },
      #endif
      #if (defined(_drRCextractUnimp)  && !defined(_drRCextractMetalFillGds) )
         #include <rcext/unimp_net_connect.rs>
      #endif
// metal by vias  
      {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
      {layers = {tm1nores}, by_layer = ind_tm1_term },
      #if (!defined(_drRCextract))
         {layers = {tm1nores, metal9nores, CE1, CE2, CE3}, by_layer = via9nores },
      #else
         #ifndef _drICFMIM
            {layers = {tm1nores, metal9nores}, by_layer = VIA9 },
            {layers = {tm1nores, mim_scl_top_plate}, by_layer = VIA9 },
            {layers = {tm1nores, mim_scl_bottem_plate}, by_layer = VIA9 },
            {layers = {metal9nores, CE1}, by_layer = VIA9 },
            {layers = {metal9nores, CE2}, by_layer = VIA9 },
            {layers = {metal9nores, CE3}, by_layer = VIA9 },
         #else 
            {layers = {tm1nores, metal9nores}, by_layer = VIA9 },
            {layers = {tm1nores, CE2,mim_scl_top_plate}, by_layer = viace2 },
            {layers = {tm1nores, CE1,mim_scl_bottem_plate}, by_layer = viace1 },
            {layers = {mimcap_cell_extent}, by_layer = mimcap_cell_extent },
            {layers = {metal9nores, CE3}, by_layer = VIA9 },
         #endif
      #endif
      {layers = {mim_scl_bottem_plate}, by_layer = CE1},
      {layers = {mim_scl_top_plate}, by_layer = CE2},
      #if (!defined(_drRCextract))
         {layers = {metal9nores, metal8nores}, by_layer = via8nores },
         {layers = {metal8nores, metal7nores}, by_layer = via7nores },
         {layers = {metal7nores, metal6nores}, by_layer = via6nores },
         {layers = {metal6nores, metal5nores}, by_layer = via5nores },
         {layers = {metal5nores, metal4nores}, by_layer = via4nores },
      #else
         {layers = {metal9nores, metal8nores}, by_layer = VIA8 },
         {layers = {metal8nores, metal7nores}, by_layer = VIA7 },
         {layers = {metal7nores, metal6nores}, by_layer = VIA6 },
         {layers = {metal6nores, metal5nores}, by_layer = VIA5 },
         {layers = {metal5nores, metal4nores}, by_layer = VIA4 },
      #endif
      {layers = {mcrnores, metal4nores}, by_layer = VCR },
      {layers = {mcrnores, metal4nores}, by_layer = MTJ },
      #if (!defined(_drRCextract))
         {layers = {metal4nores, metal3nores}, by_layer = via3nores },
         {layers = {metal3nores, metal2nores}, by_layer = via2nores },
         {layers = {metal2nores, metal1nores}, by_layer = via1nores },
         {layers = {metal1nores, metal0nores}, by_layer = via0nores },
      #else
         {layers = {metal4nores, metal3nores}, by_layer = VIA3 },
         {layers = {metal3nores, metal2nores}, by_layer = VIA2 },
         {layers = {metal2nores, metal1nores}, by_layer = VIA1 },
         {layers = {metal1nores, metal0nores}, by_layer = VIA0 },
      #endif
      #ifdef _drRFblock
         {layers = {metal4nores, metal3nores_rf}, by_layer = VIA3 },
         {layers = {metal3nores_rf}, by_layer = metal3nores},
         {layers = {metal3nores_rf, metal2nores_rf}, by_layer = VIA2_rf },
         {layers = {metal2nores_rf}, by_layer = metal2nores},
         {layers = {metal2nores_rf, metal1nores_rf}, by_layer = VIA1_rf },
         {layers = {metal2nores_rf}, by_layer = metal2nores},
         {layers = {metal1nores_rf, metal0nores_rf}, by_layer = VIA0_rf },
         {layers = {metal1nores_rf}, by_layer = metal1nores},
         {layers = {metal0nores_rf}, by_layer = metal0nores},
         //{layers = {metal1nores, metal0nores_rf}, by_layer = VIA0 },
         // {layers = {metal1nores, metal0nores_rf}, by_layer = VIA0_rf },
         // {layers = {metal1nores_rf, metal0nores}, by_layer = VIA0 },
         // {layers = {metal1nores_rf, metal0nores}, by_layer = VIA0_rf },
         // {layers = {metal2nores, metal1nores_rf}, by_layer = VIA1 },
         // {layers = {metal2nores_rf, metal1nores}, by_layer = VIA1 },
         // {layers = {metal2nores, metal1nores_rf}, by_layer = VIA1_rf },
         // {layers = {metal2nores_rf, metal1nores}, by_layer = VIA1_rf },
         // {layers = {metal3nores, metal2nores_rf}, by_layer = VIA2 },
         // {layers = {metal3nores_rf, metal2nores}, by_layer = VIA2 },
         // {layers = {metal3nores, metal2nores_rf}, by_layer = VIA2_rf },
         // {layers = {metal3nores_rf, metal2nores}, by_layer = VIA2_rf },
      #endif
      #if (!defined(_drRCextract))
          {layers = {metal0nores, diffcon_nores}, by_layer = VIACON },
          {layers = {metal0nores, polycon_nores}, by_layer = VIACON },
      #else
          {layers = {metal0nores, diffcon_nores}, by_layer = VIACONT },
          {layers = {metal0nores, polycon_nores}, by_layer = VIACONG },
          {layers = {metal0nores, gcn_tcn}, by_layer = VIACONG },
          #ifdef _drRFblock      
             {layers = {metal0nores_rf, diffcon_nores}, by_layer = VIACONT },
             {layers = {metal0nores_rf, diffcon_nores}, by_layer = VIACONT_rf },
             {layers = {metal0nores_rf, diffcon_nores_rf}, by_layer = VIACONT },
             {layers = {metal0nores_rf, diffcon_nores_rf}, by_layer = VIACONT_rf },
             {layers = {metal0nores, diffcon_nores}, by_layer = VIACONT_rf },
             {layers = {metal0nores_rf, polycon_nores}, by_layer = VIACONG },
             {layers = {metal0nores_rf, polycon_nores_rf}, by_layer = VIACONG },
             {layers = {metal0nores_rf, polycon_nores}, by_layer = VIACONG_rf },
             {layers = {metal0nores_rf, polycon_nores_rf}, by_layer = VIACONG_rf },
             {layers = {metal0nores, polycon_nores}, by_layer = VIACONG_rf },
             {layers = {metal0nores_rf, gcn_tcn}, by_layer = VIACONG },
             {layers = {metal0nores_rf, gcn_tcn_rf}, by_layer = VIACONG },
             {layers = {metal0nores_rf, gcn_tcn}, by_layer = VIACONG_rf },
             {layers = {metal0nores_rf, gcn_tcn_rf}, by_layer = VIACONG_rf },
             {layers = {metal0nores, gcn_tcn}, by_layer = VIACONG_rf },
             {layers = {metal0nores_rf}, by_layer = metal0nores},
             {layers = {polycon_nores_rf}, by_layer = polycon_nores},
             {layers = {diffcon_nores_rf}, by_layer = diffcon_nores},
          #endif
      #endif
      {layers = {metal0nores, rdlnores}, by_layer = TSV },
      {layers = {rdlnores}, by_layer = LMIPAD},

// diffcon connects 
    #if (!defined(_drRCextract))
      {layers = {nsd, npickup, 
                 psd, ppickup, pwelltap,
                 vdsource, vddrain, vsdsrc,
                 anode, anode_nbjt, anode_nbjt_esd,
                 nac_cathode, nac_cathode_esd,
                 bjt_collector, bjt_emitter,
                 bjt_collector_2, bjt_emitter_2,
                 bjt_collector_1, bjt_emitter_1,
                 poly_nores, int_diode_err }, by_layer = diffcon_nores },
    #else
       {layers = {nsd, diffcon_nores}, by_layer = cont_ndiff2tcn }, 
       {layers = {npickup, diffcon_nores }, by_layer = cont_ndiff2tcn }, 
       {layers = {vdsource, diffcon_nores }, by_layer = cont_ndiff2tcn },
       {layers = {vddrain, diffcon_nores }, by_layer = cont_ndiff2tcn },
       {layers = {vsdsrc,diffcon_nores }, by_layer = cont_ndiff2tcn },
       {layers = {nac_cathode, diffcon_nores }, by_layer = cont_ndiff2tcn },
       {layers = {nac_cathode_esd, diffcon_nores }, by_layer = cont_ndiff2tcn },
       {layers = { psd, diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { ppickup,diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { pwelltap,diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { anode, diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { anode_nbjt, diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { anode_nbjt_esd,diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { bjt_collector, diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { bjt_emitter,diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { bjt_collector_2, diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { bjt_emitter_2,diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { bjt_collector_1, diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { bjt_emitter_1,diffcon_nores }, by_layer = cont_pdiff2tcn },
       {layers = { int_diode_err, diffcon_nores }, by_layer = cont_pdiff2tcn },
       #ifdef _drRFblock
          {layers = {nsd_rf}, by_layer = nsd }, 
          {layers = {nsd_rf, diffcon_nores_rf}, by_layer = cont_ndiff2tcn }, 
          {layers = {nsd_rf, diffcon_nores}, by_layer = cont_ndiff2tcn }, 
          {layers = {nsd, diffcon_nores_rf}, by_layer = cont_ndiff2tcn }, 
          {layers = {npickup_rf }, by_layer = npickup }, 
          {layers = {npickup_rf, diffcon_nores_rf }, by_layer = cont_ndiff2tcn }, 
          {layers = {npickup, diffcon_nores_rf }, by_layer = cont_ndiff2tcn }, 
          {layers = {npickup_rf, diffcon_nores }, by_layer = cont_ndiff2tcn }, 
          {layers = {vdsource_rf}, by_layer = vdsource },
          {layers = {vdsource_rf, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {vdsource, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {vdsource_rf, diffcon_nores }, by_layer = cont_ndiff2tcn },
          {layers = {vddrain_rf }, by_layer = vddrain },
          {layers = {vddrain_rf, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {vddrain, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {vddrain_rf, diffcon_nores }, by_layer = cont_ndiff2tcn },
          {layers = {vsdsrc_rf }, by_layer = vsdsrc },
          {layers = {vsdsrc_rf,diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {vsdsrc,diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {vsdsrc_rf,diffcon_nores }, by_layer = cont_ndiff2tcn },
          {layers = {nac_cathode_rf }, by_layer = nac_cathode },
          {layers = {nac_cathode_rf, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {nac_cathode, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {nac_cathode_rf, diffcon_nores }, by_layer = cont_ndiff2tcn },
          {layers = {nac_cathode_esd_rf }, by_layer = nac_cathode_esd },
          {layers = {nac_cathode_esd_rf, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {nac_cathode_esd_rf, diffcon_nores }, by_layer = cont_ndiff2tcn },
          {layers = {nac_cathode_esd, diffcon_nores_rf }, by_layer = cont_ndiff2tcn },
          {layers = {psd_rf}, by_layer = psd }, 
          {layers = { psd_rf, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { psd, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { psd_rf, diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { ppickup_rf }, by_layer = ppickup },
          {layers = { ppickup_rf,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { ppickup,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { ppickup_rf,diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { anode_rf }, by_layer = anode },
          {layers = { anode_rf, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { anode, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { anode_rf, diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { anode_nbjt_rf }, by_layer = anode_nbjt },
          {layers = { anode_nbjt_rf, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { anode_nbjt, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { anode_nbjt_rf, diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { anode_nbjt_esd_rf }, by_layer = anode_nbjt_esd },
          {layers = { anode_nbjt_esd_rf,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { anode_nbjt_esd,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { anode_nbjt_esd_rf,diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_rf }, by_layer = bjt_collector },
          {layers = { bjt_collector_rf, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_rf, diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_rf }, by_layer = bjt_emitter },
          {layers = { bjt_emitter_rf,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_rf,diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_2_rf }, by_layer = bjt_collector_2 },
          {layers = { bjt_collector_2_rf, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_2, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_2_rf, diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_2_rf }, by_layer = bjt_emitter_2 },
          {layers = { bjt_emitter_2_rf,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_2,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_2_rf,diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_1_rf }, by_layer = bjt_collector_1 },
          {layers = { bjt_collector_1_rf, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_1, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_collector_1_rf, diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_1_rf }, by_layer = bjt_emitter_1 },
          {layers = { bjt_emitter_1_rf,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_1,diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { bjt_emitter_1_rf,diffcon_nores }, by_layer = cont_pdiff2tcn },
          {layers = { int_diode_err_rf }, by_layer = int_diode_err },
          {layers = { int_diode_err_rf, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { int_diode_err, diffcon_nores_rf }, by_layer = cont_pdiff2tcn },
          {layers = { int_diode_err_rf, diffcon_nores }, by_layer = cont_pdiff2tcn },
       #endif
    #endif

// polycon connects
      {layers = {poly_nores, poly_glbcon, diffcon_nores }, by_layer = polycon_nores },
    #if (defined(_drRCextract))
       {layers = {poly_nores,p_dummy_gate_fbd }, by_layer = diffcon_nores  },
       {layers = {poly_nores,p_dummy_gate_fbd,  diffcon_nores ,poly_glbcon}, by_layer = polycon_nores },
       {layers = {p_dummy_gate_fbd, poly_nores,polycon_nores}, by_layer = gcn_tcn },
       {layers = {diffcon_nores,polycon_nores}, by_layer = gcn_tcn },
       #ifdef _drRFblock
          {layers = {poly_nores_rf, diffcon_nores_rf }, by_layer = polycon_nores },
          {layers = {poly_nores_rf, diffcon_nores_rf }, by_layer = polycon_nores_rf },
          {layers = {poly_nores_rf, diffcon_nores }, by_layer = polycon_nores },
          {layers = {poly_nores, diffcon_nores_rf }, by_layer = polycon_nores },
          {layers = {poly_nores_rf, diffcon_nores }, by_layer = polycon_nores_rf },
          {layers = {poly_nores, diffcon_nores_rf }, by_layer = polycon_nores_rf },
          {layers = {poly_nores, diffcon_nores }, by_layer = polycon_nores_rf },
          {layers = {poly_nores_rf }, by_layer = poly_nores  },
          {layers = {poly_nores_rf }, by_layer = diffcon_nores_rf  },
          {layers = {poly_nores }, by_layer = diffcon_nores_rf  },
          {layers = {poly_nores_rf }, by_layer = diffcon_nores  },
          {layers = {diffcon_nores_rf,polycon_nores_rf}, by_layer = gcn_tcn_rf },
          {layers = {diffcon_nores_rf,polycon_nores_rf}, by_layer = gcn_tcn },
          {layers = {diffcon_nores,polycon_nores_rf}, by_layer = gcn_tcn_rf },
          {layers = {diffcon_nores,polycon_nores_rf}, by_layer = gcn_tcn },
          {layers = {diffcon_nores_rf,polycon_nores}, by_layer = gcn_tcn_rf },
          {layers = {diffcon_nores_rf,polycon_nores}, by_layer = gcn_tcn },
          {layers = {diffcon_nores,polycon_nores}, by_layer = gcn_tcn_rf },
          {layers = {p_dummy_gate_fbd, poly_nores,polycon_nores}, by_layer = gcn_tcn_rf },
          {layers = {p_dummy_gate_fbd, poly_nores_rf,polycon_nores_rf}, by_layer = gcn_tcn_rf },
          {layers = {p_dummy_gate_fbd, poly_nores_rf,polycon_nores_rf}, by_layer = gcn_tcn },
          {layers = {p_dummy_gate_fbd, poly_nores,polycon_nores_rf}, by_layer = gcn_tcn_rf },
          {layers = {p_dummy_gate_fbd, poly_nores,polycon_nores_rf}, by_layer = gcn_tcn },
          {layers = {p_dummy_gate_fbd, poly_nores_rf,polycon_nores}, by_layer = gcn_tcn_rf },
          {layers = {p_dummy_gate_fbd, poly_nores_rf,polycon_nores}, by_layer = gcn_tcn },
       #endif
    #endif

// poly_nores connects
//    #if (!defined(_drRCextract))
      {layers = {mos_ngate, mos_pgate,
                 mos_ngate_stk, mos_pgate_stk,
                 mos_ngate_a, mos_pgate_a,
                 mos_ngate_av1, mos_pgate_av1,
                 mos_ngate_av2, mos_pgate_av2,
                 mos_ngate_av3, mos_pgate_av3,
                 mos_ngate_alp, mos_pgate_alp,
                 mos_ngate_v0, mos_pgate_v0,
                 mos_ngate_v1, mos_pgate_v1,
                 mos_ngate_v2, mos_pgate_v2,
                 mos_ngate_v3, mos_pgate_v3,
                 mos_ngate_ulv1, mos_pgate_ulv1,
                 mos_ngate_v1lp, mos_pgate_v1lp,
                 mos_ngate_v2lp, mos_pgate_v2lp,
                 mos_ngate_uvt, mos_pgate_uvt,
                 mos_ngate_shvt,
                 mos_ngate_spg,
                 mos_ngate_s, mos_pgate_s,
                 mos_ngate_slp, mos_pgate_slp,
                 mos_ngate_x, mos_pgate_x,
                 //    mos_ngate_xedr,
                 mos_ngate_tg, mos_pgate_tg,
                 mos_ngate_tg160, mos_pgate_tg160,
                 mos_ngate_tgulv, mos_pgate_tgulv,
                 mos_ngate_lllp, mos_pgate_lllp,
                 //    mos_ngate_tgmv, mos_pgate_tgmv,
                 //    mos_ngate_tglv, mos_pgate_tglv,         
                 cap_ngate, cap_pgate,
                 gnac_ngate, 
                 hvgnac_ngate,
                 vdgate, esd_ngate, vsdgate, 
                 p_dummy_gate_fbd
                 #ifdef _drRFblock
                    , poly_nores_rf 
                 #endif
         }, by_layer = poly_nores},
      // rfgates 
      #ifdef _drRFblock
         {layers = {rfreq_ngate_par, rfreq_pgate_par,
                 rfreq_ngate_par_a, rfreq_pgate_par_a,
                 rfreq_ngate_par_av1, rfreq_pgate_par_av1,
                 rfreq_ngate_par_av2, rfreq_pgate_par_av2,
                 rfreq_ngate_par_av3, rfreq_pgate_par_av3,
                 rfreq_ngate_par_alp, rfreq_pgate_par_alp,
                 rfreq_ngate_par_v0, rfreq_pgate_par_v0,
                 rfreq_ngate_par_v1, rfreq_pgate_par_v1,
                 rfreq_ngate_par_v2, rfreq_pgate_par_v2,
                 rfreq_ngate_par_v3, rfreq_pgate_par_v3,
                 rfreq_ngate_par_v1lp, rfreq_pgate_par_v1lp,
                 rfreq_ngate_par_v2lp, rfreq_pgate_par_v2lp,
                 rfreq_ngate_par_uvt, rfreq_pgate_par_uvt,
                 rfreq_ngate_par_x, rfreq_pgate_par_x,
                 rfreq_ngate_par_tg, rfreq_pgate_par_tg,
                 rfreq_ngate_par_tg160, rfreq_pgate_par_tg160,
                 rfreq_ngate_par_tgulv, rfreq_pgate_par_tgulv,
                 rfreq_ngate_par_lllp, rfreq_pgate_par_lllp,
                 rfreq_ngate_stk, rfreq_pgate_stk,
                 rfreq_ngate_stk_a, rfreq_pgate_stk_a,
                 rfreq_ngate_stk_av1, rfreq_pgate_stk_av1,
                 rfreq_ngate_stk_av2, rfreq_pgate_stk_av2,
                 rfreq_ngate_stk_av3, rfreq_pgate_stk_av3,
                 rfreq_ngate_stk_alp, rfreq_pgate_stk_alp,
                 rfreq_ngate_stk_v0, rfreq_pgate_stk_v0,
                 rfreq_ngate_stk_v1, rfreq_pgate_stk_v1,
                 rfreq_ngate_stk_v2, rfreq_pgate_stk_v2,
                 rfreq_ngate_stk_v3, rfreq_pgate_stk_v3,
                 rfreq_ngate_stk_v1lp, rfreq_pgate_stk_v1lp,
                 rfreq_ngate_stk_v2lp, rfreq_pgate_stk_v2lp,
                 rfreq_ngate_stk_uvt, rfreq_pgate_stk_uvt,
                 rfreq_ngate_stk_x, rfreq_pgate_stk_x,
                 rfreq_ngate_stk_tg, rfreq_pgate_stk_tg,
                 rfreq_ngate_stk_tg160, rfreq_pgate_stk_tg160,
                 rfreq_ngate_stk_tgulv, rfreq_pgate_stk_tgulv,
                 rfreq_ngate_stk_lllp, rfreq_pgate_stk_lllp,poly_nores
         }, by_layer = poly_nores_rf},
      #else 
         {layers = { rfreq_ngate_par, rfreq_pgate_par,
                 rfreq_ngate_par_a, rfreq_pgate_par_a,
                 rfreq_ngate_par_av1, rfreq_pgate_par_av1,
                 rfreq_ngate_par_av2, rfreq_pgate_par_av2,
                 rfreq_ngate_par_av3, rfreq_pgate_par_av3,
                 rfreq_ngate_par_alp, rfreq_pgate_par_alp,
                 rfreq_ngate_par_v0, rfreq_pgate_par_v0,
                 rfreq_ngate_par_v1, rfreq_pgate_par_v1,
                 rfreq_ngate_par_v2, rfreq_pgate_par_v2,
                 rfreq_ngate_par_v3, rfreq_pgate_par_v3,
                 rfreq_ngate_par_v1lp, rfreq_pgate_par_v1lp,
                 rfreq_ngate_par_v2lp, rfreq_pgate_par_v2lp,
                 rfreq_ngate_par_uvt, rfreq_pgate_par_uvt,
                 rfreq_ngate_par_x, rfreq_pgate_par_x,
                 rfreq_ngate_par_tg, rfreq_pgate_par_tg,
                 rfreq_ngate_par_tg160, rfreq_pgate_par_tg160,
                 rfreq_ngate_par_tgulv, rfreq_pgate_par_tgulv,
                 rfreq_ngate_par_lllp, rfreq_pgate_par_lllp,
                 rfreq_ngate_stk, rfreq_pgate_stk,
                 rfreq_ngate_stk_a, rfreq_pgate_stk_a,
                 rfreq_ngate_stk_av1, rfreq_pgate_stk_av1,
                 rfreq_ngate_stk_av2, rfreq_pgate_stk_av2,
                 rfreq_ngate_stk_av3, rfreq_pgate_stk_av3,
                 rfreq_ngate_stk_alp, rfreq_pgate_stk_alp,
                 rfreq_ngate_stk_v0, rfreq_pgate_stk_v0,
                 rfreq_ngate_stk_v1, rfreq_pgate_stk_v1,
                 rfreq_ngate_stk_v2, rfreq_pgate_stk_v2,
                 rfreq_ngate_stk_v3, rfreq_pgate_stk_v3,
                 rfreq_ngate_stk_v1lp, rfreq_pgate_stk_v1lp,
                 rfreq_ngate_stk_v2lp, rfreq_pgate_stk_v2lp,
                 rfreq_ngate_stk_uvt, rfreq_pgate_stk_uvt,
                 rfreq_ngate_stk_x, rfreq_pgate_stk_x,
                 rfreq_ngate_stk_tg, rfreq_pgate_stk_tg,
                 rfreq_ngate_stk_tg160, rfreq_pgate_stk_tg160,
                 rfreq_ngate_stk_tgulv, rfreq_pgate_stk_tgulv,
                 rfreq_ngate_stk_lllp, rfreq_pgate_stk_lllp
                 }, by_layer = poly_nores},
      #endif 

// gbnwell gates
      {layers = {esdng_c8xlrgbnevm2k1p4_prim,
                 esdng_c8xlrgbnevm2k1p1_prim, 
                 esdng_c8xlrgbnevm2k7p5_prim, 
                 esdng_c8xlrgbnevm2k3p5_prim, 
                 esdng_c8xlrgbnevm2k0p4_prim,
                 esdng_c8xlesdclampres_prim,
                 esdng_d8xlesdclampres_prim,
                 esdng_d8xlesdclamptgres_prim
                 #if (defined(_drRCextract) && defined(_drIncludePort))
                     , polyInterFace
                 #endif
                 #ifdef _drRFblock
                     , poly_nores_rf 
                 #endif
                 }, by_layer = poly_nores },

// poly global cons
      {layers = {poly_nores}, by_layer = poly_glbcon },



// bjt connections
      {layers = {cathode}, by_layer = nwell_nores },

    #if (!defined(_drRCextract))
      {layers = {bjt_base, bjt_base_1, bjt_base_2 }, by_layer = npickup },
    #else
      {layers = {bjt_base, npickup }, by_layer = cont_sub2npickup  },
      {layers = {bjt_base_1, npickup }, by_layer = cont_sub2npickup  },
      {layers = {bjt_base_2, npickup }, by_layer = cont_sub2npickup  },
    #endif

      {layers = {bjt_coll}, by_layer = bjt_collector },
      {layers = {bjt_emit}, by_layer = bjt_emitter },
      {layers = {bjt_coll_1}, by_layer = bjt_collector_1 },
      {layers = {bjt_emit_1}, by_layer = bjt_emitter_1 },
      {layers = {bjt_coll_2}, by_layer = bjt_collector_2 },
      {layers = {bjt_emit_2}, by_layer = bjt_emitter_2 },



// real subset of nores for cadnav
#ifdef _drCADNAV
      {layers = {real_rdl}, by_layer = rdlnores },
      {layers = {real_tm1}, by_layer = tm1nores },
      {layers = {real_m9}, by_layer = metal9nores },
      {layers = {real_m8}, by_layer = metal8nores },
      {layers = {real_m7}, by_layer = metal7nores },
      {layers = {real_m6}, by_layer = metal6nores },
      {layers = {real_m5}, by_layer = metal5nores },
      {layers = {real_mcr}, by_layer = mcrnores },
      {layers = {real_m4}, by_layer = metal4nores },
      {layers = {real_m3}, by_layer = metal3nores },
      {layers = {real_m2}, by_layer = metal2nores },
      {layers = {real_m1}, by_layer = metal1nores },
      {layers = {real_m0}, by_layer = metal0nores },
      {layers = {real_gcn}, by_layer = polycon_nores },
      {layers = {real_tcn}, by_layer = diffcon_nores },
      {layers = {real_poly}, by_layer = poly_nores },
#endif
#ifdef _drIncludePort
//port connections
   {layers = {nwellInterFace}, by_layer = nwell_nores },
   {layers = {nwellesdInterFace}, by_layer = nwellesd_nores },
   {layers = {diffconInterFace}, by_layer = diffcon_nores },
   {layers = {polyconInterFace}, by_layer = polycon_nores },
   {layers = {polyInterFace}, by_layer = poly_nores },
   {layers = {m0InterFace}, by_layer = metal0nores },
   {layers = {m1InterFace}, by_layer = metal1nores },
   {layers = {m2InterFace}, by_layer = metal2nores },
   {layers = {m3InterFace}, by_layer = metal3nores },
   #ifdef _drRFblock
      //{layers = {diffconInterFace}, by_layer = diffcon_nores_rf },
      {layers = {diffconInterFace_rf}, by_layer = diffcon_nores_rf },
      //{layers = {polyconInterFace}, by_layer = polycon_nores_rf },
      {layers = {polyconInterFace_rf}, by_layer = polycon_nores_rf },
      //{layers = {polyInterFace}, by_layer = poly_nores_rf },
      {layers = {polyInterFace_rf}, by_layer = poly_nores_rf },
      //{layers = {m0InterFace}, by_layer = metal0nores_rf },
      {layers = {m0InterFace_rf}, by_layer = metal0nores_rf },
      //{layers = {m1InterFace}, by_layer = metal1nores_rf },
      {layers = {m1InterFace_rf}, by_layer = metal1nores_rf },
      //{layers = {m2InterFace}, by_layer = metal2nores_rf },
      {layers = {m2InterFace_rf}, by_layer = metal2nores_rf },
      {layers = {m3InterFace_rf}, by_layer = metal3nores_rf },
      //{layers = {m3InterFace}, by_layer = metal3nores_rf },
   #endif
   {layers = {m4InterFace}, by_layer = metal4nores },
   {layers = {m5InterFace}, by_layer = metal5nores },
   {layers = {m6InterFace}, by_layer = metal6nores },
   {layers = {m7InterFace}, by_layer = metal7nores },
   {layers = {m8InterFace}, by_layer = metal8nores },
   {layers = {m9InterFace}, by_layer = metal9nores },
   {layers = {tm1InterFace}, by_layer = tm1nores },
   {layers = {rdlInterFace}, by_layer = rdlnores },
   {layers = {mcrInterFace}, by_layer = mcrnores },
   {layers = {c4bInterFace}, by_layer = C4BEMIB },
#endif  
   {layers = {nwellesd_nores}, by_layer = nwell_nores }
   // include the scaleable mfc connects 
   #include <1273/p1273dx_Tconn_sclmfc.rs>
  }
); 

#if (!defined(_drSigPlot) && !defined(_drLVSONLY))
   txt_trace_soft_connect = text_net (
      connect_sequence = trace_soft_connect,
      text_layer_items = {
         #if (defined(_drVIRPKGROUTE) && _drFULL_DIE == _drYES)
            {layer = VIRPKGROUTE, text_layer = VIRPKGROUTE_txt},
         #endif
         {layer = C4BEMIB, text_layer = C4BEMIB_txt},
         {layer = tm1nores, text_layer = TM1BC_txt},
         {layer = CE1, text_layer = CE1_txt},
         {layer = CE2, text_layer = CE2_txt},
         {layer = CE3, text_layer = CE3_txt},
         {layer = metal9nores, text_layer = METAL9BC_txt},
         {layer = metal8nores, text_layer = METAL8BC_txt},
         {layer = metal7nores, text_layer = METAL7BC_txt},
         {layer = metal6nores, text_layer = METAL6BC_txt},
         {layer = metal5nores, text_layer = METAL5BC_txt},
         {layer = mcrnores, text_layer = MCR_txt},
         {layer = metal4nores, text_layer = METAL4BC_txt},
         {layer = metal3nores, text_layer = METAL3BC_txt},
         {layer = metal2nores, text_layer = METAL2BC_txt},
         {layer = metal1nores, text_layer = METAL1BC_txt},
         {layer = metal0nores, text_layer = METAL0BC_txt},
         {layer = rdlnores, text_layer = RDL_txt},
         {layer = polycon_nores, text_layer = POLYCON_txt},
         {layer = diffcon_nores, text_layer = DIFFCON_txt},
      #ifdef _drRCextract
          {layer = gcn_tcn, text_layer = POLYCON_txt},
          // {layer = poly_nores_nogate, text_layer = POLY_txt},
          {layer = p_dummy_gate_fbd, text_layer = POLY_txt},
          #ifdef _drRFblock
             {layer = poly_nores_rf, text_layer = POLY_txt},
             {layer = gcn_tcn_rf, text_layer = POLYCON_txt},
             {layer = nsd_rf , text_layer = NDIFF_txt},
             {layer = psd_rf , text_layer = PDIFF_txt},
             {layer = polycon_nores_rf , text_layer = POLYCON_txt},
             {layer = diffcon_nores_rf, text_layer = DIFFCON_txt},
             {layer = metal3nores_rf, text_layer = METAL3BC_txt},
             {layer = metal2nores_rf, text_layer = METAL2BC_txt},
             {layer = metal1nores_rf, text_layer = METAL1BC_txt},
             {layer = metal0nores_rf, text_layer = METAL0BC_txt},
          #endif
     #endif
         {layer = psd, text_layer = PDIFF_txt},
         {layer = nsd, text_layer = NDIFF_txt},
         {layer = poly_glbcon, text_layer = POLY_txt},
         {layer = LMIPAD, text_layer = LMIPAD_txt}
     #if (defined(_drRCextractUnimp)  && !defined(_drRCextractMetalFillGds) )
            ,
            #include <rcext/unimp_net_text.rs>
         #endif
      },
     #if defined(_drRCextractUnimp) && defined(_drUnimpTxtCellLvl)
         processing_mode = CELL_LEVEL,
     #endif
   // no need to report shorts here since they will be the same as from the netlist connect
   #if _drTOPCHECK  == _drnocheck
       // all opens merged nothing renamed
       // no opens in netlist - so LVS will not report open errors 
       // all opens are only reported in LAYOUT_ERRORS
       opens = MERGE_ALL,
       // report unresolved opens (ones that had to be merged)
       #ifdef _drNoReportTextErr
          report_errors = {},
       #else
          #ifdef _drIgnoreMergeOpen
             report_errors = {},
          #else
             report_errors = {MERGED
                  #ifdef  _drSCAlt
                                 , SHORTED
                  #endif 
                             },
             merged_violation_comment = "Soft-Connect(trcalt) MERGED Opens (MERGE_ALL)",
          #endif
       #endif
   #elif _drTOPCHECK  == _drcheck
      // unresolved opens will be renamed
      // opens maintained in netlist - should be LVS errors
      opens = MERGE_CONNECTED,
      // report remaining opens that were renamed
       #ifdef _drNoReportTextErr
          report_errors = {},
       #else
          report_errors = {RENAMED
                  #ifdef  _drSCAlt
                              , SHORTED
                  #endif 
                          },
          renamed_violation_comment = "Soft-Connect(trcalt) RENAMED Opens (MERGE_CONNECTED)",
       #endif
   #elif _drTOPCHECK  == _drmixed
      // unresolved opens will be renamed except at top and they will be merged
      // child opens maintained in netlist - should be LVS errors
      opens = MERGE_TOP_THEN_CONNECTED,
      // report remaining opens that were renamed
      // add MERGED so you can see what nodes have opens at the top 
      //    but could be ignored since they are at the top-level and probably pins
      #ifdef _drNoReportTextErr
         report_errors = {},
      #else
         #ifdef _drIgnoreMergeOpen
             report_errors = {RENAMED
                  #ifdef  _drSCAlt
                                 , SHORTED
                  #endif 
                             },
             renamed_violation_comment = "Soft-Connect(trcalt) RENAMED Opens (MERGE_TOP_THEN_CONNECTED)",
         #else
             report_errors = {RENAMED, MERGED
                  #ifdef  _drSCAlt
                                 , SHORTED
                  #endif 
                             },
             merged_violation_comment = "Soft-Connect(trcalt) MERGED Opens (MERGE_TOP_THEN_CONNECTED)",
             renamed_violation_comment = "Soft-Connect(trcalt) RENAMED Opens (MERGE_TOP_THEN_CONNECTED)",
         #endif
      #endif
   #endif // end _drTOPCHECK
      attach_text = ALL,
      rename_prefix = "iss_trcpin_open"
      #include <p12723_UserTextPriority.rs>
   );
#endif  // skip if sigplot or lvsonly


// this is equivalent to standard trace - will ONLY netlist from std connect model
// active netlisting / short/open code
trace_netlist_connect = incremental_connect(
   connect_sequence = trace_soft_connect,
   connect_items = {
      // bulk __drsubstrate connections
      #if (!defined(_drRCextract))
         {layers = {npickup}, by_layer = nwellesd_nores},
         {layers = {npickup, djnw_cathode}, by_layer = nwell_nores },
         {layers = {ppickup, nac_anode, djnw_anode}, by_layer = __drsubstrate },
      #else
         {layers = {nac_anode, __drsubstrate}, by_layer = __drsubstrate},
         {layers = {ppickup, __drsubstrate}, by_layer = cont_sub2ppickup},
         {layers = {npickup, nwellesd_nores}, by_layer = cont_sub2npickup}, 
         {layers = {npickup, nwell_nores}, by_layer = cont_sub2npickup} ,
		 // for rcextract stomp on the VIA* layer by via*nores and connect to the metal layer
         #if _drPROCESS == 6
            {layers = {tm1nores, metal12nores}, by_layer = VIA12},
            {layers = {metal12nores, metal11nores}, by_layer = VIA11},
            {layers = {metal11nores, metal10nores}, by_layer = VIA10},
            {layers = {metal10nores, metal9nores}, by_layer = VIA9},
         #else
            {layers = {tm1nores, metal9nores}, by_layer = VIA9},
         #endif
         {layers = {metal9nores, metal8nores}, by_layer = VIA8},
         {layers = {metal8nores, metal7nores}, by_layer = VIA7},
         {layers = {metal7nores, metal6nores}, by_layer = VIA6},
         {layers = {metal6nores, metal5nores}, by_layer = VIA5},
         {layers = {metal5nores, metal4nores}, by_layer = VIA4},
         {layers = {metal4nores, metal3nores}, by_layer = VIA3},
         {layers = {metal3nores, metal2nores}, by_layer = VIA2},
         {layers = {metal2nores, metal1nores}, by_layer = VIA1},
         {layers = {metal1nores, metal0nores}, by_layer = VIA0},

         #ifdef _drRFblock
            {layers = {ppickup_rf, __drsubstrate }, by_layer = cont_sub2ppickup},
            {layers = {npickup_rf, nwellesd_nores}, by_layer = cont_sub2npickup}, 
            {layers = {npickup_rf, nwell_nores}, by_layer = cont_sub2npickup},
         #endif
      #endif
      // generic catchall for TSV - tsv will connect to any layer below M0
      #ifdef _drRFblock
         {layers = {diffcon_nores, polycon_nores, poly_nores, nsd, psd, npickup, ppickup, diffcon_nores_rf, polycon_nores_rf, poly_nores_rf, nsd_rf, psd_rf, npickup_rf, ppickup_rf },
            by_layer = TSV }
      #else
         {layers = {diffcon_nores, polycon_nores, poly_nores, nsd, psd, npickup, ppickup},
            by_layer = TSV }
      #endif
  }
); 

// add c4bump into connectivity derined from C4BEMIB
c4bumpStamped = stamp(c4bump, C4BEMIB, trace_netlist_connect, stamped_trace_netlist_connect);

// create ports attempts to define what the actual top-level pins are
// assume all genesys pins are also ported 
trace_netlist_connect_ported = create_ports(
   connect_sequence = stamped_trace_netlist_connect,
   port_items = {
     {c4bumpStamped, c4bInterFace},
     {tm1nores, tm1InterFace},
     {metal9nores, m9InterFace},
     {metal8nores, m8InterFace},
     {metal7nores, m7InterFace},
     {metal6nores, m6InterFace},
     {metal5nores, m5InterFace},
     {mcrnores, mcrInterFace},
     {metal4nores, m4InterFace},
     {metal3nores, m3InterFace},
     #ifdef _drRFblock
       {metal3nores_rf, m3InterFace_rf},
       //{metal3nores_rf, m3InterFace},
       //{metal2nores_rf, m2InterFace},
       {metal2nores_rf, m2InterFace_rf},
       //{metal1nores_rf, m1InterFace},
       {metal1nores_rf, m1InterFace_rf},
       //{metal0nores_rf, m0InterFace},
       {metal0nores_rf, m0InterFace_rf},
       //{diffcon_nores_rf, diffconInterFace},
       //{polycon_nores_rf, polyconInterFace},
       //{poly_nores_rf, polyInterFace},
       {diffcon_nores_rf, diffconInterFace_rf},
       {polycon_nores_rf, polyconInterFace_rf},
       {poly_nores_rf, polyInterFace_rf},
     #endif

     {metal2nores, m2InterFace},
     {metal1nores, m1InterFace},
     {metal0nores, m0InterFace},
     {rdlnores, rdlInterFace},
     {diffcon_nores, diffconInterFace},
     {polycon_nores, polyconInterFace},
     {poly_nores, polyInterFace},
     {nwell_nores, nwellInterFace},
     {nwellesd_nores, nwellesdInterFace},
     {__drsubstrate, pwellsubisopin}
   },
   report = {}
);

txt_trace_netlist_connect = text_net (
   connect_sequence = trace_netlist_connect_ported,
   text_layer_items = {
      #if (defined(_drVIRPKGROUTE) && _drFULL_DIE == _drYES)
         {layer = VIRPKGROUTE, text_layer = VIRPKGROUTE_txt},
      #endif
      {layer = C4BEMIB, text_layer = C4BEMIB_txt},
      {layer = tm1nores, text_layer = TM1BC_txt},
      {layer = CE1, text_layer = CE1_txt},
      {layer = CE2, text_layer = CE2_txt},
      {layer = CE3, text_layer = CE3_txt},
      {layer = metal9nores, text_layer = METAL9BC_txt},
      {layer = metal8nores, text_layer = METAL8BC_txt},
      {layer = metal7nores, text_layer = METAL7BC_txt},
      {layer = metal6nores, text_layer = METAL6BC_txt},
      {layer = metal5nores, text_layer = METAL5BC_txt},
      {layer = mcrnores, text_layer = MCR_txt},
      {layer = metal4nores, text_layer = METAL4BC_txt},
      {layer = metal3nores, text_layer = METAL3BC_txt},
      {layer = metal2nores, text_layer = METAL2BC_txt},
      {layer = metal1nores, text_layer = METAL1BC_txt},
      {layer = metal0nores, text_layer = METAL0BC_txt},
      {layer = rdlnores, text_layer = RDL_txt},
      {layer = polycon_nores, text_layer = POLYCON_txt},
      {layer = diffcon_nores, text_layer = DIFFCON_txt},
      {layer = psd, text_layer = PDIFF_txt},
      {layer = nsd, text_layer = NDIFF_txt},
      {layer = poly_glbcon, text_layer = POLY_txt},
      {layer = LMIPAD, text_layer = LMIPAD_txt},
      #ifdef _drRCextract
         {layer = gcn_tcn, text_layer = POLYCON_txt},
         // {layer = poly_nores_nogate, text_layer = POLY_txt},
         {layer = p_dummy_gate_fbd, text_layer = POLY_txt},
          #ifdef _drRFblock
                {layer = poly_nores_rf, text_layer = POLY_txt},
                {layer = gcn_tcn_rf, text_layer = POLYCON_txt},
                {layer = nsd_rf , text_layer = NDIFF_txt},
                {layer = psd_rf , text_layer = PDIFF_txt},
                {layer = polycon_nores_rf , text_layer = POLYCON_txt},
                {layer = diffcon_nores_rf, text_layer = DIFFCON_txt},
                {layer = metal3nores_rf, text_layer = METAL3BC_txt},
                {layer = metal2nores_rf, text_layer = METAL2BC_txt},
                {layer = metal1nores_rf, text_layer = METAL1BC_txt},
                {layer = metal0nores_rf, text_layer = METAL0BC_txt},
          #endif
      #endif
      {layer = nwell_nores, text_layer = NWELL_txt},
      {layer = cathode, text_layer = NWELL_txt},
      {layer = nwellesd_nores, text_layer = NWELLESD_txt}
      #if (defined(_drMSR) && (_drMSR !=0))
         , {layer = __drsubstrate, text_layer = PWELL_SUBISO_txt}
      #endif
      #if (defined(_drRCextractUnimp)  && !defined(_drRCextractMetalFillGds) )
          ,
          #include <rcext/unimp_net_text.rs>
      #endif
      },
     #if defined(_drRCextractUnimp) && defined(_drUnimpTxtCellLvl)
         processing_mode = CELL_LEVEL,
     #endif

    // if not _drMSR then force sub to be vss

    #if (!defined(_drMSR) || (_drMSR ==0))
       text_string_items = {
       #if (_drCaseSensitive == _drNO) // UPPERCASE
          {layer = __drsubstrate, text = "VSS" }
       #else
          {layer = __drsubstrate, text = "vss" }
       #endif
       },
    #endif

    #if _drTOPCHECK  == _drnocheck
       // all opens merged nothing renamed
       // no opens in netlist - so LVS will not report open errors 
       // all opens are only reported in LAYOUT_ERRORS
       opens = MERGE_ALL,
       // report shorts and unresolved opens (ones that had to be merged)
       #ifdef _drNoReportTextErr
          report_errors = {},
       #else
          #ifdef _drIgnoreMergeOpen
             report_errors = {
               #ifndef  _drSCAlt
                             SHORTED
               #endif 
                          },
             shorted_violation_comment = "Netlist-Connect(trcstd) SHORTED",
          #else
             report_errors = {
               #ifndef  _drSCAlt
                             SHORTED, MERGED
               #endif 
                          },
             shorted_violation_comment = "Netlist-Connect(trcstd) SHORTED",
             merged_violation_comment = "Netlist-Connect(trcstd) MERGED Opens (MERGE_ALL)",
          #endif
       #endif
   #elif _drTOPCHECK  == _drcheck
      // unresolved opens will be renamed
      // opens maintained in netlist - should be LVS errors
      opens = MERGE_CONNECTED,
      // report shorts and remaining opens that were renamed
       #ifdef _drNoReportTextErr
          report_errors = {},
       #else
          report_errors = {
               #ifndef  _drSCAlt
                          SHORTED, RENAMED
               #endif 
                       },
          shorted_violation_comment = "Netlist-Connect(trcstd) SHORTED",
          renamed_violation_comment = "Netlist-Connect(trcstd) RENAMED Opens (MERGE_CONNECTED)",
       #endif
   #elif _drTOPCHECK  == _drmixed
      // unresolved opens will be renamed except at top and they will be merged
      // child opens maintained in netlist - should be LVS errors
      opens = MERGE_TOP_THEN_CONNECTED,
      // report shorts and remaining opens that were renamed
      // add MERGED so you can see what nodes have opens at the top 
      //    but could be ignored since they are at the top-level and probably pins
      #ifdef _drNoReportTextErr
         report_errors = {},
      #else
         #ifdef _drIgnoreMergeOpen
             report_errors = {
               #ifndef  _drSCAlt
                              SHORTED, RENAMED
               #endif
                          },
             shorted_violation_comment = "Netlist-Connect(trcstd) SHORTED",
             renamed_violation_comment = "Netlist-Connect(trcstd) RENAMED Opens (MERGE_TOP_THEN_CONNECTED)",
         #else
             report_errors = {
               #ifndef  _drSCAlt
                              SHORTED, RENAMED, MERGED
               #endif
                          },
             shorted_violation_comment = "Netlist-Connect(trcstd) SHORTED",
             renamed_violation_comment = "Netlist-Connect(trcstd) RENAMED Opens (MERGE_TOP_THEN_CONNECTED)",
             merged_violation_comment = "Netlist-Connect(trcstd) MERGED Opens (MERGE_TOP_THEN_CONNECTED)",
         #endif
      #endif
   #endif // end _drTOPCHECK

   #if _drPRUNE == _drpgshort   // case 1
      // create interactive short finder data for vcc vss shorts 
      create_short_finder_nets = {
         {nets ="*", with_nets = strcat(_dr_lvsLayoutPower,_dr_lvsLayoutGround) }
      },
   #elif _drPRUNE == _drallshort     // case 2
      // create interactive short finder data for all shorts 
      create_short_finder_nets = {
         {nets ="*", with_nets = {"*"}}
      },
   #else
      // no short data generation will be done for the interactive short finder 
   #endif // if _drPRUNE
   attach_text = ALL,
   rename_prefix = "iss_trcpin_open"
   #if defined(_drDumpAsciiShort)
      , short_debugging = {vue_short_finder = true, static_output = {graphics = NONE, ascii = true}}
   #endif
   #include <p12723_UserTextPriority.rs>
);


#include <1273/p1273dx_Tchks.rs>

#endif // _P1273DX_TCONN_RS_
