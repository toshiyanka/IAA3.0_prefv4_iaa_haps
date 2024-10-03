// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273d5_Tconn.rs.rca 1.31 Thu Jan  8 10:35:55 2015 kperrey Experimental $

// $Log: p1273d5_Tconn.rs.rca $
// 
//  Revision: 1.31 Thu Jan  8 10:35:55 2015 kperrey
//  hsd 2997; updates from Mahesh
// 
//  Revision: 1.30 Thu Sep 25 10:13:03 2014 kperrey
//  hsd 2742 ; need to have/text poly_glbcon(poly - resid) layer for full texting to occur (handle text on the gate)
// 
//  Revision: 1.29 Fri Sep  5 13:12:27 2014 kperrey
//  change texted_at = TOP_OF_NET to HIGHEST_TEXT
// 
//  Revision: 1.28 Fri Jul 25 16:48:55 2014 kperrey
//  fix cut/paste typo; include file should be p12723_UserTextPriority.rs
// 
//  Revision: 1.27 Mon Jul 21 21:29:24 2014 kperrey
//  updated short_debugging = {vue_short_finder = true, static_output = {graphics = NONE, ascii = true}}
// 
//  Revision: 1.26 Mon Jul 21 20:52:44 2014 kperrey
//  add short_debugging = {static_output = {ascii = true}} if _drDumpAsciiShort is defined ; add in soft-connect include p12723_UserTextPriority.rs
// 
//  Revision: 1.25 Tue May 20 13:58:19 2014 kperrey
//  hsd 2392 ; change drNO to _drNO which is the actual define
// 
//  Revision: 1.24 Fri Mar 14 16:12:57 2014 kperrey
//  add path rcext to includes as needed
// 
//  Revision: 1.23 Mon Mar  3 13:53:37 2014 kperrey
//  hsd 2165 ; remove poly_nores_nogate referance now just all poly_nores
// 
//  Revision: 1.22 Tue Feb 25 08:57:56 2014 kperrey
//  change how the rcextract is done do connect poly_nores_nogate
// 
//  Revision: 1.21 Thu Feb 20 19:57:46 2014 kperrey
//  hsd 2130; add mos_[np]gate_stk into connectivity
// 
//  Revision: 1.20 Thu Feb 20 14:54:06 2014 kperrey
//  not used ; but updated to handle par stk rfreq gate layer names and removed all the rfreq derivation that is now just part of Tcommon
// 
//  Revision: 1.19 Sun Jan  5 15:58:29 2014 kperrey
//  connect the rf device type gates ; derive layers for calculation w/l/nf/ns since these are based upon connections
// 
//  Revision: 1.18 Thu Dec 26 20:05:53 2013 kperrey
//  change how VIRPKGROUTE connects to C4BEMIB; now connects by a VIRPKGVIA ; so you can now route VIRPKGROUTE over C4BEMIB w/o connecting to them ; enhancement from IDC
// 
//  Revision: 1.17 Wed Nov 13 10:18:02 2013 kperrey
//  virpkgroute should connect C4BEMIB instead of C4B
// 
//  Revision: 1.16 Wed Nov 13 07:36:21 2013 kperrey
//  include p12723_UserTextPriority.rs when can enable texting priority in the txt_trace_netlist_connect when there are shorts
// 
//  Revision: 1.15 Wed Nov  6 09:28:00 2013 kperrey
//  hsd 1941 ; enable unique HV list for mim gt 1.417
// 
//  Revision: 1.14 Tue Nov  5 15:57:13 2013 kperrey
//  MCR connects to m4nores by MTJ ; as per eric wang
// 
//  Revision: 1.13 Wed Oct 30 08:34:23 2013 kperrey
//  hsd 1926 ; add MCR derivations MCR connects to M4 by VCR
// 
//  Revision: 1.12 Mon Oct 14 12:13:24 2013 kperrey
//  allow VIRPKGROUTE to resolve die opens when _drVIRPKGROUTE is defined
// 
//  Revision: 1.11 Wed Oct  2 10:00:24 2013 kperrey
//  change C4B references to C4BEMIB which is the old C4B + new smaller C4EMIB bumps
// 
//  Revision: 1.10 Fri Sep 27 17:49:21 2013 kperrey
//  hsd 1869 ; define new variables not{Power/Ground} all{Power/Ground} based upon _dr_lvsLayoutPower and _dr_lvsLayoutGround; instead of VCC/VSS use allPower or allGround
// 
//  Revision: 1.9 Thu Jul 18 20:17:13 2013 kperrey
//  hsd 1808 ; moved TSV catchall to netlist connect ; build own connectivity model for vx_98 from the soft connect model
// 
//  Revision: 1.8 Mon Jun 10 09:32:40 2013 kperrey
//  add connectivity for perc djnw_cathode/anode
// 
//  Revision: 1.7 Fri Mar 22 08:52:43 2013 kperrey
//  add mos_n/pgate_tg160 to the connects for nal/pal160 support
// 
//  Revision: 1.6 Mon Jan 14 08:04:28 2013 kperrey
//  fix name usage LMI->LMIPAD ; text LMIPAD layer for the connects
// 
//  Revision: 1.5 Fri Jan 11 20:14:35 2013 kperrey
//  as per Kalyan; connect LMI to rdlnores
// 
//  Revision: 1.4 Fri Dec 28 12:00:07 2012 kperrey
//  added handling for NV3/PV3
// 
//  Revision: 1.3 Mon Dec 17 09:20:05 2012 kperrey
//  hsd 1458 ; need to remove ce1GND2Stack in determining ceNOM
// 
//  Revision: 1.2 Thu Dec 13 17:37:49 2012 kperrey
//  hsd 1430; start of support for MSR
// 
//  Revision: 1.1 Mon Nov 19 09:31:03 2012 kperrey
//  support 73d5 ; derived from 73d6 but w/o m11/v11 layers
// 
//  Revision: 1.3 Tue Oct 30 16:42:29 2012 kperrey
//  add a catch-all connect for TSV to diffcon/polycon/nsd/psd/poly these should never be in the catchcup region
// 
//  Revision: 1.2 Thu Oct 18 15:56:37 2012 kperrey
//  add rdl/rsv support
// 
//  Revision: 1.1 Fri Aug 10 11:29:26 2012 kperrey
//  new module to support the 73.6 m10/m11 connectivity
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
//  1272/p1272d5_Tcommon.rs
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

#ifndef _P1273D5_TCONN_RS_
#define _P1273D5_TCONN_RS_

// init some softcon error info
SoftConnWelltap:double = 0;
drValHash["SoftConnWelltap"] = SoftConnWelltap;
drHash["SoftConnWelltap"] = "Welltap is soft-connected to power";
drErrGDSHash[xc(SoftConnWelltap)] = { 8, 2001 };

SoftConnSubtap:double = 0;
drValHash["SoftConnSubtap"] = SoftConnSubtap;
drHash["SoftConnSubtap"] = "Subtap is soft-connected to ground";
drErrGDSHash[xc(SoftConnSubtap)] = { 1, 2001 };

// physical pin extraction (object touching(within 2 grid) or crossing TL boundary)
// create pinring for defining pins
tlPinRing = _drGeneratePinRing(TOPCELLBOUNDARY);

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
   m10TLPin = _drGetTopLevelPins__(metal10nores, tlPinRing );
   metal10nores = copy(_drFlatPortInteract__(metal10nores, m10TLPin));
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
   m10TLPin = empty_layer();
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
m10TLPort = _drGetTopLevelPorts__(met10bcpin);
metal10nores = copy(_drFlatPortInteract__(metal10nores, m10TLPort));
tm1TLPort = _drGetTopLevelPorts__(tm1bcpin);
tm1nores = copy(_drFlatPortInteract__(tm1nores, tm1TLPort));
rdlTLPort = _drGetTopLevelPorts__(rdlpin);
rdlnores = copy(_drFlatPortInteract__(rdlnores, rdlTLPort));
mcrTLPort = _drGetTopLevelPorts__(mcrpin);
mcrnores = copy(_drFlatPortInteract__(mcrnores, mcrTLPort));


#if defined(_drRCextract)
   // rcext pins
   slie1_diffcon = diffconpin and [processing_mode = CELL_LEVEL]  (SLIE1 not DIFFCONRESID);
   slie1_polycon = polyconpin and [processing_mode = CELL_LEVEL]  (SLIE1 not POLYCONRESID);
   slie1_poly = poly1pin and [processing_mode = CELL_LEVEL]  (SLIE1 not PRES_ID);
   slie1_m0 = met0bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET0BCRESID);
   slie1_m1 = met1bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET1BCRESID);
   slie1_m2 = met2bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET2BCRESID);
   slie1_m3 = met3bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET3BCRESID);
   slie1_m4 = met4bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET4BCRESID);
   slie1_m5 = met5bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET5BCRESID);
   slie1_m6 = met6bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET6BCRESID);
   slie1_m7 = met7bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET7BCRESID);
   slie1_m8 = met8bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET8BCRESID);
   slie1_m9 = met9bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET9BCRESID);
   slie1_m10 = met10bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MET10BCRESID);
   slie1_tm1 = tm1bcpin and [processing_mode = CELL_LEVEL]  (SLIE1 not TM1BCRESID);
   slie1_rdl = rdlpin and [processing_mode = CELL_LEVEL]  (SLIE1 not RDLRESID);
   slie1_mcr = mcrpin and [processing_mode = CELL_LEVEL]  (SLIE1 not MCRRESID);
#endif

// special handling for c4b/bumps
c4bPort = flatten_by_cells(C4BEMIB, cells = { "*" });
c4bump = copy(c4bPort);

// get ports for the bb template cells 
#if defined(_drRCextract)
   diffconPort = _drGetBBPorts__(drawnPortLayer = diffconpin, drawnDataLayer = diffcon_nores) or diffconpin;
   polyconPort = _drGetBBPorts__(drawnPortLayer = polyconpin, drawnDataLayer = polycon_nores) or polyconpin;
   polyPort = _drGetBBPorts__(drawnPortLayer = poly1pin, drawnDataLayer = poly_nores) or poly1pin;
   m0Port = _drGetBBPorts__(drawnPortLayer = met0bcpin, drawnDataLayer = metal0nores) or met0bcpin;
   m1Port = _drGetBBPorts__(drawnPortLayer = met1bcpin, drawnDataLayer = metal1nores) or met1bcpin;
   m2Port = _drGetBBPorts__(drawnPortLayer = met2bcpin, drawnDataLayer = metal2nores) or met2bcpin;
   m3Port = _drGetBBPorts__(drawnPortLayer = met3bcpin, drawnDataLayer = metal3nores) or met3bcpin;
   m4Port = _drGetBBPorts__(drawnPortLayer = met4bcpin, drawnDataLayer = metal4nores) or met4bcpin;
   m5Port = _drGetBBPorts__(drawnPortLayer = met5bcpin, drawnDataLayer = metal5nores) or met5bcpin;
   m6Port = _drGetBBPorts__(drawnPortLayer = met6bcpin, drawnDataLayer = metal6nores) or met6bcpin;
   m7Port = _drGetBBPorts__(drawnPortLayer = met7bcpin, drawnDataLayer = metal7nores) or met7bcpin;
   m8Port = _drGetBBPorts__(drawnPortLayer = met8bcpin, drawnDataLayer = metal8nores) or met8bcpin;
   m9Port = _drGetBBPorts__(drawnPortLayer = met9bcpin, drawnDataLayer = metal9nores) or met9bcpin;
   m10Port = _drGetBBPorts__(drawnPortLayer = met10bcpin, drawnDataLayer = metal10nores) or met10bcpin;
   tm1Port = _drGetBBPorts__(drawnPortLayer = tm1bcpin, drawnDataLayer = tm1nores) or tm1bcpin;
   rdlPort = _drGetBBPorts__(drawnPortLayer = rdlpin, drawnDataLayer = rdlnores) or rdlpin;
   mcrPort = _drGetBBPorts__(drawnPortLayer = mcrpin, drawnDataLayer = mcrnores) or mcrpin;

#else
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
   m10Port = _drGetBBPorts__(drawnPortLayer = met10bcpin, drawnDataLayer = metal10nores) or m10TLPort;
   tm1Port = _drGetBBPorts__(drawnPortLayer = tm1bcpin, drawnDataLayer = tm1nores) or tm1TLPort;
   rdlPort = _drGetBBPorts__(drawnPortLayer = rdlpin, drawnDataLayer = rdlnores) or rdlTLPort;
   mcrPort = _drGetBBPorts__(drawnPortLayer = mcrpin, drawnDataLayer = mcrnores) or mcrTLPort;
   #endif

// merge the ports pins into 1 interface object
polyInterFace = copy(polyPort);
polyconInterFace = copy(polyconPort);
diffconInterFace = copy(diffconPort);
#if (defined(_drRCextract) && !defined(_drPinTopBoundary))
   m0InterFace = copy(m0Port);
   m1InterFace = copy(m1Port);
   m2InterFace = copy(m2Port);
   m3InterFace = copy(m3Port);
   m4InterFace = copy(m4Port);
   m5InterFace = copy(m5Port);
   m6InterFace = copy(m6Port);
   m7InterFace = copy(m7Port);
   m8InterFace = copy(m8Port);
   m9InterFace = copy(m9Port);
   m10InterFace = copy(m10Port);
   tm1InterFace = copy(tm1Port);
   rdlInterFace = copy(rdlPort);
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
   m10InterFace = m10Port or m10TLPin;
   tm1InterFace = tm1Port or tm1TLPin;
   rdlInterFace = rdlPort or rdlTLPin;
#endif
c4bInterFace = copy(c4bPort);

#if defined(_drRCextract) 
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
   #endif
   polycon_nores = polycon_nores not gcn_tcn;
   poly_nores = poly_nores not p_dummy_gate_fbd;
   // grow poly pullback for device parameters and iso 
   gate_w_gcn_ext = dr_poly_diff_enc_COMMON interacting [processing_mode = CELL_LEVEL] gate_w_gcn;
   gate_w_gcn_iso = polygon_extents(gate_w_gcn or gate_w_gcn_ext);
   POLYiso = POLY not gate_w_gcn;
   POLYiso = POLYiso or gate_w_gcn_iso;
   nsd = nsd not POLYiso;
   psd = psd not POLYiso;
   all_sd_iso = all_sd not POLYiso;
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
   drPassthruStack.push_back({m10Port, {154,105} }); // m10 port
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
   drPassthruStack.push_back({m10TLPin, {154,107} }); // m10 pin
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
   drPassthruStack.push_back({m10InterFace, {154,108} }); // m10 interface
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
      	  
      #ifdef _drRCextractUnimp
         #include <rcext/unimp_net_connect.rs>
      #endif
// metal by vias  
      {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
      #if (!defined(_drRCextract))
         {layers = {tm1nores, metal10nores, CE1, CE2, CE3}, by_layer = VIA10 },
      #else
         {layers = {tm1nores, metal10nores}, by_layer = VIA10 },
         {layers = {metal10nores, CE1}, by_layer = VIA10 },
         {layers = {metal10nores, CE2}, by_layer = VIA10 },
         {layers = {metal10nores, CE3}, by_layer = VIA10 },
      #endif
      {layers = {metal10nores, metal9nores}, by_layer = VIA9 },
      {layers = {metal9nores, metal8nores}, by_layer = VIA8 },
      {layers = {metal8nores, metal7nores}, by_layer = VIA7 },
      {layers = {metal7nores, metal6nores}, by_layer = VIA6 },
      {layers = {metal6nores, metal5nores}, by_layer = VIA5 },
      {layers = {metal5nores, metal4nores}, by_layer = VIA4 },
      {layers = {mcrnores, metal4nores}, by_layer = VCR },
      {layers = {mcrnores, metal4nores}, by_layer = MTJ },
      {layers = {metal4nores, metal3nores}, by_layer = VIA3 },
      {layers = {metal3nores, metal2nores}, by_layer = VIA2 },
      {layers = {metal2nores, metal1nores}, by_layer = VIA1 },
      {layers = {metal1nores, metal0nores}, by_layer = VIA0 },
      #if (!defined(_drRCextract))
            {layers = {metal0nores, diffcon_nores}, by_layer = VIACON },
            {layers = {metal0nores, polycon_nores}, by_layer = VIACON },
      #else
          {layers = {metal0nores, diffcon_nores}, by_layer = VIACONT },
          {layers = {metal0nores, polycon_nores}, by_layer = VIACONG },
          {layers = {metal0nores, gcn_tcn}, by_layer = VIACONG },
      #endif
      {layers = {metal0nores, rdlnores}, by_layer = TSV },
      {layers = {rdlnores}, by_layer = LMIPAD },

// diffcon connects 
    #if (!defined(_drRCextract))
      {layers = {nsd, npickup, 
                 psd, ppickup,
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
    #endif

// polycon connects
      {layers = {poly_nores, diffcon_nores }, by_layer = polycon_nores },
    #if (defined(_drRCextract))
      {layers = {poly_nores,polycon_nores}, by_layer = gcn_tcn },
      {layers = {diffcon_nores,polycon_nores}, by_layer = gcn_tcn },
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
                 }, by_layer = poly_nores},
      // rfgates
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
                 }, by_layer = poly_nores },

// poly global cons
      {layers = {poly_nores}, by_layer = poly_glbcon },


#if 0 // START SKIP 
//SKIP    #else
//SKIP      {layers = {mos_ngate, mos_pgate,
//SKIP                 mos_ngate_a, mos_pgate_a,
//SKIP                 mos_ngate_av1, mos_pgate_av1,
//SKIP                 mos_ngate_av2, mos_pgate_av2,
//SKIP                 mos_ngate_av3, mos_pgate_av3,
//SKIP                 mos_ngate_alp, mos_pgate_alp,
//SKIP                 mos_ngate_v0, mos_pgate_v0,
//SKIP                 mos_ngate_v1, mos_pgate_v1,
//SKIP                 mos_ngate_v2, mos_pgate_v2,
//SKIP                 mos_ngate_v3, mos_pgate_v3,
//SKIP                 mos_ngate_v1lp, mos_pgate_v1lp,
//SKIP                 mos_ngate_v2lp, mos_pgate_v2lp,
//SKIP                 mos_ngate_uvt, mos_pgate_uvt,
//SKIP                 mos_ngate_shvt,
//SKIP                 mos_ngate_spg,
//SKIP                 mos_ngate_s, mos_pgate_s,
//SKIP                 mos_ngate_slp, mos_pgate_slp,
//SKIP                 mos_ngate_x, mos_pgate_x,
//SKIP                 //    mos_ngate_xedr,
//SKIP                 mos_ngate_tg, mos_pgate_tg,
//SKIP                 mos_ngate_tg160, mos_pgate_tg160,
//SKIP                 mos_ngate_tgulv, mos_pgate_tgulv,
//SKIP                 mos_ngate_lllp, mos_pgate_lllp,
//SKIP                 //    mos_ngate_tgmv, mos_pgate_tgmv,
//SKIP                 //    mos_ngate_tglv, mos_pgate_tglv,         
//SKIP                 cap_ngate, cap_pgate,
//SKIP                 gnac_ngate, 
//SKIP                 hvgnac_ngate,
//SKIP                 vdgate, esd_ngate, vsdgate, 
//SKIP                 p_dummy_gate_fbd, poly_nores, polyInterFace
//SKIP                 }, by_layer = poly_nores_nogate },
//SKIP// gbnwell gates
//SKIP      {layers = {esdng_c8xlrgbnevm2k1p4_prim,
//SKIP                 esdng_c8xlrgbnevm2k1p1_prim, 
//SKIP                 esdng_c8xlrgbnevm2k7p5_prim, 
//SKIP                 esdng_c8xlrgbnevm2k3p5_prim, 
//SKIP                 esdng_c8xlrgbnevm2k0p4_prim,
//SKIP                 esdng_c8xlesdclampres_prim,
//SKIP                 esdng_d8xlesdclampres_prim,
//SKIP                 esdng_d8xlesdclamptgres_prim, 
//SKIP                 poly_nores, polyInterFace }, by_layer = poly_nores_nogate },
//SKIP
//SKIP    #endif
#endif  // END SKIP 
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
      {layers = {real_m10}, by_layer = metal10nores },
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
   {layers = {diffconInterFace}, by_layer = diffcon_nores },
   {layers = {polyconInterFace}, by_layer = polycon_nores },
   {layers = {polyInterFace}, by_layer = poly_nores },
   {layers = {m0InterFace}, by_layer = metal0nores },
   {layers = {m1InterFace}, by_layer = metal1nores },
   {layers = {m2InterFace}, by_layer = metal2nores },
   {layers = {m3InterFace}, by_layer = metal3nores },
   {layers = {m4InterFace}, by_layer = metal4nores },
   {layers = {m5InterFace}, by_layer = metal5nores },
   {layers = {m6InterFace}, by_layer = metal6nores },
   {layers = {m7InterFace}, by_layer = metal7nores },
   {layers = {m8InterFace}, by_layer = metal8nores },
   {layers = {m9InterFace}, by_layer = metal9nores },
   {layers = {m10InterFace}, by_layer = metal10nores },
   {layers = {tm1InterFace}, by_layer = tm1nores },
   {layers = {rdlInterFace}, by_layer = rdlnores },
   {layers = {mcrInterFace}, by_layer = mcrnores },
   {layers = {c4bInterFace}, by_layer = C4BEMIB },
#endif  
   {layers = {nwellesd_nores}, by_layer = nwell_nores }
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
         {layer = metal10nores, text_layer = METAL10BC_txt},
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
         {layer = LMIPAD, text_layer = LMIPAD_txt}
      },
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

// validate that all nwelltaps and subtaps connected to sd are of the same node
// want nsd psd that are interacting with gate (dummy nsd/psd are dont cares)
nsd_softcon_active = nsd interacting save_gate;
psd_softcon_active = psd interacting save_gate;
nsd_softconStamped = stamp(nsd_softcon_active, nsd, trace_soft_connect, stamped_trace_soft_connect_t1);
psd_softconStamped = stamp(psd_softcon_active, psd, stamped_trace_soft_connect_t1, stamped_trace_soft_connect_t2);
save_gate_softconStamped = stamp(save_gate, poly_nores, stamped_trace_soft_connect_t2, stamped_trace_soft_connect_t3);

// get welltaps connected to devices
softcheckWelltap = net_select(
      connect_sequence = stamped_trace_soft_connect_t3,
      layer_groups = { "layerSet1" => { npickup }}, 
      net_type = ALL,
      connected_to_any = {nsd_softconStamped, psd_softconStamped, save_gate_softconStamped,
                 vdsource, vddrain, vsdsrc,
                 anode, anode_nbjt, anode_nbjt_esd,
                 nac_cathode, nac_cathode_esd,
                 bjt_collector, bjt_emitter,
                 bjt_collector_2, bjt_emitter_2,
                 bjt_collector_1, bjt_emitter_1
      },
      output_from_layers = {npickup}
);
// add welltaps back into connectivity
softcheckWelltapStamped = stamp(softcheckWelltap, npickup, trace_soft_connect, stamped_trace_WellTapsoft_connect);
// do the check
#ifndef _drTapCheck
drSoftCheck_(xc(SoftConnWelltap), softcheckWelltapStamped, (NWELL or (NWELLESDDRAWN not WELLRES_ID)), stamped_trace_WellTapsoft_connect); 
#endif

// get subtaps connected to devices
softcheckSubtapNS = net_select(
      connect_sequence = stamped_trace_soft_connect_t3,
      layer_groups = { "layerSet1" => { ppickup }}, 
      net_type = ALL,
      connected_to_any = {nsd_softconStamped, psd_softconStamped, save_gate_softconStamped,
                 vdsource, vddrain, vsdsrc,
                 anode, anode_nbjt, anode_nbjt_esd,
                 nac_cathode, nac_cathode_esd,
                 bjt_collector, bjt_emitter,
                 bjt_collector_2, bjt_emitter_2,
                 bjt_collector_1, bjt_emitter_1
      },
      output_from_layers = {ppickup}
);
softcheckSubtapID = ppickup and DIODEID;
softcheckSubtap = softcheckSubtapNS or softcheckSubtapID;

// add welltaps back into connectivity
softcheckSubtapStamped = stamp(softcheckSubtap, ppickup, trace_soft_connect, stamped_SubTapsoft_connect);
// do the check
#ifndef _drTapCheck
drSoftCheck_(xc(SoftConnSubtap), softcheckSubtapStamped, __drsubstrate, stamped_SubTapsoft_connect); 
#endif

#ifdef _drDEBUG
drPassthruStack.push_back({softcheckSubtapStamped, {1008,200} }); // 
drPassthruStack.push_back({softcheckWelltapStamped, {1001,200} }); // 
#endif

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
      #endif

	  // generic catchall for TSV - tsv will connect to any layer below M0
      {layers = {diffcon_nores, polycon_nores, poly_nores, nsd, psd, npickup, ppickup},
		   by_layer = TSV }

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
     {metal10nores, m10InterFace},
     {metal9nores, m9InterFace},
     {metal8nores, m8InterFace},
     {metal7nores, m7InterFace},
     {metal6nores, m6InterFace},
     {metal5nores, m5InterFace},
     {mcrnores, mcrInterFace},
     {metal4nores, m4InterFace},
     {metal3nores, m3InterFace},
     {metal2nores, m2InterFace},
     {metal1nores, m1InterFace},
     {metal0nores, m0InterFace},
     {rdlnores, rdlInterFace},
     {diffcon_nores, diffconInterFace},
     {polycon_nores, polyconInterFace},
     {poly_nores, polyInterFace}
   },
   report = {}
);

txt_trace_netlist_connect = text_net (
   connect_sequence = trace_netlist_connect_ported,
   text_layer_items = {
      #if (defined(_drVIRPKGROUTE) && _drFULL_DIE == _drYES)
         {layer = VIRPKGROUTE, text_layer = VIRPKGROUTE_txt},
      #endif
      #ifdef _drRCextractUnimp
          #include <rcext/unimp_net_text.rs>
      #endif
      {layer = C4BEMIB, text_layer = C4BEMIB_txt},
      {layer = tm1nores, text_layer = TM1BC_txt},
      {layer = CE1, text_layer = CE1_txt},
      {layer = CE2, text_layer = CE2_txt},
      {layer = CE3, text_layer = CE3_txt},
      {layer = metal10nores, text_layer = METAL10BC_txt},
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
      #endif
      {layer = nwell_nores, text_layer = NWELL_txt},
      {layer = cathode, text_layer = NWELL_txt},
      {layer = nwellesd_nores, text_layer = NWELLESD_txt}
      #if (defined(_drMSR) && (_drMSR !=0))
         , {layer = __drsubstrate, text_layer = PWELL_SUBISO_txt}
      #endif
   },
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


// init error handling
Error_Std_Checks = empty_violation();
txt_std_checks:connect_database; 

#if (!defined(_drSigPlot) && !defined(_drLVSONLY))
// only do mim checks if mim ||tm1 exists
if (!layer_empty(CE1) ||  !layer_empty(CE2) || !layer_empty(TM1) ) {
#else
// force to skip mim checks when doing sigPlot or LVSONLY
if (false) {
#endif
    // init error codes
    drHash[xc(MIMCONST1)] = "CE2 can not be UHV/EHV/HV";
    drHash[xc(MIM1CONST1)] = "CE1 nomimal must interact with CE2 GND";
    drHash[xc(MIM2CONST1)] = "HV must interact with float CE2";
    drHash[xc(MIM2CONST2)] = "EHV must interact with float CE2";
    drHash[xc(MIM2CONST3)] = "Floating CE2 can not interact with both HV/EHV";
    drHash[xc(MIM2CONST4)] = "CE1GND must interact with float CE2";
    drHash[xc(MIM2CONST5)] = "float CE2 interacting with HV/EHV must interact with GND ";
    drHash[xc(MIM2CONST6)] = "floating CE2 interacting with EHV >";
    drHash[xc(MIM2CONST7)] = "floating CE2 interacting with HV >";
    drHash[xc(MIM3CONST1)] = "UHV must interact with float CE2";
    drHash[xc(MIM3CONST2)] = "floating CE2 interacting with UHV can not interact with EHV/HV";
    drHash[xc(MIM3CONST3)] = "floating CE2 interacting with UHV must interact with floating CE1"; 
    drHash[xc(MIM3CONST4)] = "floating CE1 interacting with floating CE2 must interact with CE1 GND"; 
    drHash[xc(MIM3CONST5)] = "floating CE2 interacting with UHV >";

    drErrGDSHash[xc(MIMCONST1)] = {90,1961} ;
    drErrGDSHash[xc(MIM1CONST1)] = {90,1971} ;
    drErrGDSHash[xc(MIM2CONST1)] = {90,1981} ;
    drErrGDSHash[xc(MIM2CONST2)] = {90,1982} ;
    drErrGDSHash[xc(MIM2CONST3)] = {90,1983} ;
    drErrGDSHash[xc(MIM2CONST4)] = {90,1984} ;
    drErrGDSHash[xc(MIM2CONST5)] = {90,1985} ;
    drErrGDSHash[xc(MIM2CONST6)] = {90,1986} ;
    drErrGDSHash[xc(MIM2CONST7)] = {90,1987} ;
    drErrGDSHash[xc(MIM3CONST1)] = {90,1991} ;
    drErrGDSHash[xc(MIM3CONST2)] = {90,1992} ;
    drErrGDSHash[xc(MIM3CONST3)] = {90,1993} ;
    drErrGDSHash[xc(MIM3CONST4)] = {90,1994} ;
    drErrGDSHash[xc(MIM3CONST5)] = {90,1995} ;

    drValHash[xc(MIMCONST1)] = 0;
    drValHash[xc(MIM1CONST1)] = 0;
    drValHash[xc(MIM2CONST1)] = 0;
    drValHash[xc(MIM2CONST2)] = 0;
    drValHash[xc(MIM2CONST3)] = 0;
    drValHash[xc(MIM2CONST4)] = 0;
    drValHash[xc(MIM2CONST5)] = 0;
    drValHash[xc(MIM2CONST6)] = 1;
    drValHash[xc(MIM2CONST7)] = 1;
    drValHash[xc(MIM3CONST1)] = 0;
    drValHash[xc(MIM3CONST2)] = 0;
    drValHash[xc(MIM3CONST3)] = 0;
    drValHash[xc(MIM3CONST4)] = 0;
    drValHash[xc(MIM3CONST5)] = 1;

    // edm/chn waivers from (Berni L.) 
    waiver_MIM1CONST1_ce1 = copy_by_cells(CE1, cells = {"d8xtochnce12ressmall", "d8xtochnce12reslarge", "d8xtochnv9m9"} , depth = CELL_LEVEL);
    waiver_mim61_via10 = copy_by_cells(VIA10, cells = {"d8xtochnce12ressmall", "d8xtochnce12reslarge"} , depth = CELL_LEVEL);


   // MIM_61 CE1/CE2/CE3 can not be used as res
   // this is a soft_check assume shunt in TM1 or M10
   ce1v10 = (VIA10 and CE1) not waiver_mim61_via10;
   ce1_soft_connect = connect(
      connect_items = {
         {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
         {layers = {tm1nores, metal10nores, ce1v10}, by_layer = VIA10 } }
   );
   drSoftCheck_(xc(MIM_61), ce1v10, CE1, ce1_soft_connect); 
   
   ce2v10 = (VIA10 and CE2) not waiver_mim61_via10;
   ce2_soft_connect = connect(
      connect_items = {
         {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
         {layers = {tm1nores, metal10nores, ce2v10}, by_layer = VIA10 } }
   );
   drSoftCheck_(xc(MIM_61), ce2v10, CE2, ce2_soft_connect); 
   

   //these 6 cells are all from the EDM structure; the first 4 cells above form the MIM resistor chain, and the waiver is approved by Doug Ingerly.
   //the last two cells, a80toedm1270pgdmimx0 and a80toedm1270ogdmimx0, are of the MIM capacitor chain and CE1 is not connected to VCC or XVCC; 
   // make guess as to cellname
   mim_waiver_cells:list of string = { "*", 
       //TODO: the list needs to be updated for p1273 once the names are available.
       "!c80toedm1272pgdm82x0", "!c80toedm1272pgdmbex0",
       "!c80toedm1272pgdm81x0", "!c80toedm1272pgdmtex0",
       "!c80toedm1272pgdmimx0", "!c80toedm1272ogdmimx0"
   };

   // get the ce123 geos to check 
   CE12Chk = copy_by_cells(layer1=CE1, cells= mim_waiver_cells);
   CE22Chk = copy_by_cells(layer1=CE2, cells= mim_waiver_cells);

  
   // connectivity for mim construction checks                        
   mim_construction_connect = connect(
      connect_items = {
         {layers = {C4BEMIB, tm1nores}, by_layer = TV1 },
         {layers = {tm1nores, metal10nores, CE12Chk, CE22Chk}, by_layer = VIA10 },
         {layers = {metal10nores, metal9nores}, by_layer = VIA9 } }
   );

   mim_construction_connect_txt = text_net (
      connect_sequence = mim_construction_connect,
      text_layer_items = {
         {layer = C4BEMIB, text_layer = C4BEMIB_txt},
         {layer = tm1nores, text_layer = TM1BC_txt},
         {layer = metal10nores, text_layer = METAL10BC_txt},
         {layer = metal9nores, text_layer = METAL9BC_txt}
      },
      opens = IGNORE,  
      report_errors = {}, 
      attach_text = ALL,
      rename_prefix = ""
   );

   // find floating ce1/ce2
   ce1FloatingAll = CE12Chk not_interacting VIA10;
   ce2FloatingAll = CE22Chk not_interacting VIA10;

   // get node based plates
   ce1UHV = drNetTextedWith({CE12Chk}, ultra_high_voltage_list, mim_construction_connect_txt); 
   ce1EHV = drNetTextedWith({CE12Chk}, extra_high_voltage_list, mim_construction_connect_txt); 
   ce1HV = drNetTextedWith({CE12Chk}, high_voltage_list_gt1417, mim_construction_connect_txt); 
   ce1GND = drNetTextedWith({CE12Chk}, allGround, mim_construction_connect_txt); 
   ce2GND = drNetTextedWith({CE22Chk}, allGround, mim_construction_connect_txt); 

   // get potentail 3 stack terms
   ce1UHVce2FLOAT3Stack = ce1UHV interacting ce2FloatingAll;
   ce2FLOATce1UHV3Stack = ce2FloatingAll interacting ce1UHV ;
   ce2GNDce1FLOAT3Stack = ce2GND interacting ce1FloatingAll;
   ce1FLOATce2GND3Stack = ce1FloatingAll interacting ce2GND ;
   ce1FLOATce2FLOAT3Stack = ce1FloatingAll interacting ce2FLOATce1UHV3Stack;

   // get potential 2 stack terms
   ce1HVce2FLOAT2Stack = ce1HV interacting ce2FloatingAll;
   ce2FLOATce1EHV2Stack = ce2FloatingAll interacting ce1EHV;
   ce1EHVce2FLOAT2Stack = ce1EHV interacting ce2FloatingAll;
   ce2FLOATce1HV2Stack = ce2FloatingAll interacting ce1HV;
   ce1GND2Stack = ce1GND interacting ce2FloatingAll;
   ce2FLOATce1GND2Stack = ce2FloatingAll interacting ce1GND;

   // get std cap ce2 ground ce1 non-floating and not hv/ehv/uhv 
   ce1NOM = CE12Chk not (ce1FloatingAll or ce1UHV or ce1EHV or ce1HV or ce1GND2Stack);
   ce1NOMce2GNDStd = ce1NOM interacting ce2GND;

   // basic constuction checks 2/3 stack
    // CE2 can not be UHV/EHV/HV
    drNetTextedWith_(xc(MIMCONST1), {CE22Chk}, 
        strcat(strcat(ultra_high_voltage_list,extra_high_voltage_list),high_voltage_list_gt1417), mim_construction_connect_txt); 

   // basic constuction checks 2 stack
   // HV must interact with float CE2
   drCopyToError_(xc(MIM2CONST1), (ce1HV not_interacting ce2FLOATce1HV2Stack));  
   // EHV must interact with float CE2
   drCopyToError_(xc(MIM2CONST2), (ce1EHV not_interacting ce2FLOATce1EHV2Stack)); 
   // floating ce2 cant interact with both EHV/HV
   drCopyToError_(xc(MIM2CONST3), (ce2FLOATce1EHV2Stack interacting ce1HV)); 
   drCopyToError_(xc(MIM2CONST3), (ce2FLOATce1HV2Stack interacting ce1EHV)); 
   // CE1GND must interact with float CE2
   drCopyToError_(xc(MIM2CONST4), (ce1GND not_interacting (ce2FLOATce1HV2Stack or ce2FLOATce1EHV2Stack))); 
   // float CE2 interacting with HV/EHV must interact with GND 
   drCopyToError_(xc(MIM2CONST5), ((ce2FLOATce1HV2Stack or ce2FLOATce1EHV2Stack) not_interacting ce1GND)); 
    
   // basic constuction checks 3 stack
    // UHV must interact with float CE2
    drCopyToError_(xc(MIM3CONST1), (ce1UHV interacting (CE22Chk not ce2FLOATce1UHV3Stack)));  
    // floating CE2 interacting with UHV can not interact with EHV/HV
    drCopyToError_(xc(MIM3CONST2), (ce2FLOATce1UHV3Stack interacting ce1EHV )); 
    drCopyToError_(xc(MIM3CONST2), (ce2FLOATce1UHV3Stack interacting ce1HV )); 
    // floating CE2 interacting with UHV must interact with floating CE1 
    drCopyToError_(xc(MIM3CONST3), (ce2FLOATce1UHV3Stack not_interacting ce1FLOATce2GND3Stack)); 
    // floating CE1 interacting with floating CE2 must interact with gnd CE2 
    drCopyToError_(xc(MIM3CONST4), (ce1FLOATce2FLOAT3Stack not_interacting ce2GNDce1FLOAT3Stack)); 

   // basic constuction checks std mimcap
   drCopyToError_(xc(MIM1CONST1), ((ce1NOM not_interacting ce2GND) not waiver_MIM1CONST1_ce1)); 
   

#ifdef _drDEBUG
   drPassthruStack.push_back({CE12Chk, {91,300} }); 
   drPassthruStack.push_back({CE22Chk, {90,300} }); 

   drPassthruStack.push_back({ce1FloatingAll, {91,301} }); 
   drPassthruStack.push_back({ce2FloatingAll, {90,301} }); 

   drPassthruStack.push_back({ce1UHV, {91,302} }); 
   drPassthruStack.push_back({ce1EHV, {91,303} }); 
   drPassthruStack.push_back({ce1HV, {91,304} }); 
   drPassthruStack.push_back({ce1NOM, {91,305} }); 
   drPassthruStack.push_back({ce1GND, {91,306} }); 
   drPassthruStack.push_back({ce2GND, {90,306} }); 

   drPassthruStack.push_back({ce1UHVce2FLOAT3Stack , {91,307} }); 
   drPassthruStack.push_back({ce2FLOATce1UHV3Stack , {90,308} }); 
   drPassthruStack.push_back({ce2GNDce1FLOAT3Stack , {90,309} }); 
   drPassthruStack.push_back({ce1FLOATce2GND3Stack , {91,310} }); 
   drPassthruStack.push_back({ce1FLOATce2FLOAT3Stack , {91,311} }); 

   drPassthruStack.push_back({ce1HVce2FLOAT2Stack , {91,312} }); 
   drPassthruStack.push_back({ce2FLOATce1EHV2Stack , {90,313} }); 
   drPassthruStack.push_back({ce1EHVce2FLOAT2Stack , {91,314} }); 
   drPassthruStack.push_back({ce2FLOATce1HV2Stack , {90,315} }); 
   drPassthruStack.push_back({ce1GND2Stack , {91,316} }); 
   drPassthruStack.push_back({ce2FLOATce1GND2Stack , {90,317} }); 


#endif

   // trim ce1 uhv/ehv/hv nodes their ce2 floating 
   ce1UHVtrim = ce1UHV and ce2FLOATce1UHV3Stack; 
   ce1EHVtrim = ce1EHV and ce2FLOATce1EHV2Stack;
   ce1HVtrim = ce1HV and ce2FLOATce1HV2Stack; 
   
   // connect the mim layers to their source layer
   mim_lay_connect = incremental_connect(
      connect_sequence = trace_netlist_connect,
      connect_items = {
         {layers = {ce1UHVtrim, ce1EHVtrim, ce1HVtrim}, by_layer = CE1}
      }
   );

   txt_mim_lay_connect = text_net (
   connect_sequence = mim_lay_connect,
   text_layer_items = {
      {layer = C4BEMIB, text_layer = C4BEMIB_txt},
      {layer = tm1nores, text_layer = TM1BC_txt},
      {layer = metal10nores, text_layer = METAL10BC_txt},
      {layer = metal9nores, text_layer = METAL9BC_txt}
    },
    opens = MERGE_CONNECTED,
   report_errors = {}, 
   attach_text = ALL,
   rename_prefix = "MIM_OPEN"
);

drSoftCheck_(xc(MIM2CONST6), ce1EHVtrim, ce2FLOATce1EHV2Stack, txt_mim_lay_connect); 
drSoftCheck_(xc(MIM2CONST7), ce1HVtrim, ce2FLOATce1HV2Stack, txt_mim_lay_connect); 
drSoftCheck_(xc(MIM3CONST5), ce1UHVtrim, ce2FLOATce1UHV3Stack, txt_mim_lay_connect); 


}  //if (!layer_empty(CE1) ||  !layer_empty(CE2) || !layer_empty(TM1) )

// This really needs it own text - since net_select/texted_with is dependent
// upon how opens are resolve - so this needs to be just ignore opens
// this connect just treats all opens as 1 net
txt_std_checks = text_net (
   connect_sequence = trace_netlist_connect_ported,
   text_layer_items = {
      {layer = C4BEMIB, text_layer = C4BEMIB_txt},
      {layer = tm1nores, text_layer = TM1BC_txt},
      {layer = metal10nores, text_layer = METAL10BC_txt},
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
      {layer = polycon_nores, text_layer = POLYCON_txt},
      {layer = diffcon_nores, text_layer = DIFFCON_txt},
      {layer = psd, text_layer = PDIFF_txt},
      {layer = nsd, text_layer = NDIFF_txt},
      {layer = poly_glbcon, text_layer = POLY_txt},
      {layer = nwellesd_nores, text_layer = NWELLESD_txt},
      {layer = nwell_nores, text_layer = NWELL_txt},
      {layer = cathode, text_layer = NWELL_txt}
      #if (defined(_drMSR) && (_drMSR !=0))
         , {layer = __drsubstrate, text_layer = PWELL_SUBISO_txt}
      #endif
   },
   #if (!defined(_drMSR) || (_drMSR ==0))
      text_string_items = {
         #if (_drCaseSensitive == _drNO) // UPPERCASE
            {layer = __drsubstrate, text = "VSS" }
         #else
            {layer = __drsubstrate, text = "vss" }
         #endif
      },
   #endif
   opens = IGNORE,  
   report_errors = {}, 
   attach_text = ALL,
   rename_prefix = ""
);

#if _drSTDCHECKS == _dryes
osTSV = size(TSV, distance = p1272grid);
npickup_vx_98 = npickup not osTSV;
ppickup_vx_98 = ppickup not osTSV;
diffcon_nores_vx_98 = diffcon_nores not osTSV;
polycon_nores_vx_98 = polycon_nores not osTSV;
poly_nores_vx_98 = poly_nores not osTSV;
nsd_vx_98 = nsd not osTSV;
psd_vx_98 = psd not osTSV;

/*
drPassthruStack.push_back({osTSV, {217,905} });  
drPassthruStack.push_back({npickup_vx_98, {1,905} });  
drPassthruStack.push_back({ppickup_vx_98, {8,905} });  
drPassthruStack.push_back({nsd_vx_98, {1,906} });  
drPassthruStack.push_back({psd_vx_98, {8,906} });  
drPassthruStack.push_back({polycon_nores_vx_98, {6,905} });  
drPassthruStack.push_back({diffcon_nores_vx_98, {5,905} });  
drPassthruStack.push_back({poly_nores_vx_98, {2,905} });  
*/
 
trace_vx_98 = incremental_connect(
   connect_sequence = trace_soft_connect,
   connect_items = {
      // bulk __drsubstrate connections
      {layers = {npickup_vx_98}, by_layer = nwellesd_nores},
      {layers = {npickup_vx_98, djnw_cathode}, by_layer = nwell_nores },
      {layers = {ppickup, nac_anode, djnw_anode}, by_layer = __drsubstrate },
      // generic catchall for TSV - tsv will connect to any layer below M0
      {layers = {diffcon_nores_vx_98}, by_layer = diffcon_nores},
      {layers = {polycon_nores_vx_98}, by_layer = polycon_nores},
      {layers = {poly_nores_vx_98}, by_layer = poly_nores},
      {layers = {nsd_vx_98}, by_layer = nsd},
      {layers = {psd_vx_98}, by_layer = psd},
      {layers = {diffcon_nores_vx_98, polycon_nores_vx_98, poly_nores_vx_98, nsd_vx_98, psd_vx_98, npickup_vx_98, ppickup_vx_98},
            by_layer = TSV }
  }
); 

#include <p12723_metal_via_common.rs>
#include <p12723_brdgvia_on_pwr_common.rs>

nwellresistor = NWELL cutting WELLRES_ID;
esdresistor = NWELLESD cutting  WELLRES_ID;

vsspsd = net_texted_with(
  connect_sequence = txt_std_checks, 
  text =  allGround, 
  output_from_layers = { psd }, 
  texted_at = HIGHEST_TEXT, 
  processing_mode = HIERARCHICAL
);


nonvsspsd = psd not vsspsd;

waive_varactor = copy_by_cells(CELLBOUNDARY, cells = varactorTemplates, depth = CELL_LEVEL);

nwell_esddiode_id =NWELL inside ESDDIODE_ID;
nwell_cut_esddiode_id = NWELL cutting ESDDIODE_ID;
nwell_all_esd_id = nwell_esddiode_id or nwell_cut_esddiode_id;

vssn = net_select(
      connect_sequence = txt_std_checks,
      layer_groups = { "layerSet1" => { nwell_nores, nwellesd_nores }}, 
      net_type = ALL,
      connected_to_all = {ppickup},
      output_from_layers = {nwell_nores, nwellesd_nores}
   );


psd_in_vssn = vssn and psd;

psd_w_ptap = net_select(
      connect_sequence = txt_std_checks,
      layer_groups = { "layerSet1" => { psd }}, 
      net_type = ALL,
      connected_to_all = {ppickup},
      output_from_layers = {psd}
   );

fo_bi = psd_in_vssn not psd_w_ptap;

fo_bi_stamp = stamp (
   layer1 = fo_bi,
   layer2 = psd,
   in_connect_sequence = txt_std_checks,
   out_connect_sequence = txt_fo_bi_connect,
   include_touch = NONE 
);

Error_Std_Checks @= {

   @ "fo_bi: Stamp assumption violation";
   fo_bi not fo_bi_stamp ; 

   @ "pinch: pinched nwell resistor has no model in process file";
   note(CheckingString("pinch"));
   psd and nwellresistor;

   @ "diode: integrated diode not tied to ground";
   note(CheckingString("diode"));
   (nonvsspsd and esdresistor) not waive_varactor;

   @ "err0: err0 - gate within esddiodewell";
   note(CheckingString("err0"));
   allgates inside nwell_all_esd_id;
   allgates cutting nwell_all_esd_id;

   @ "fbiasedcheck1: forward - biased diode shorting power and ground";
   note(CheckingString("fbiasedcheck"));
   net_texted_with(
     connect_sequence = txt_fo_bi_connect, 
     text = allPower, 
     output_from_layers = { fo_bi_stamp }, 
     texted_at = HIGHEST_TEXT, 
     processing_mode = HIERARCHICAL
   );

}
// handle error definition and maintainence
drErrHash["Std_Checks"] = Error_Std_Checks;
drErrGDSHash["Std_Checks"] = {2, 2002};
drsaveGDSError(Error_Std_Checks, drErrGDSHash["Std_Checks"] );

#endif // end drSTDCHECK


#endif // _P1273D5_TCONN_RS_
