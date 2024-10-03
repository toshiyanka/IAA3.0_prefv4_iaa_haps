// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tcommon.rs.rca 1.70 Thu Jan  8 08:33:59 2015 kperrey Experimental $

// $Log: p1273dx_Tcommon.rs.rca $
// 
//  Revision: 1.70 Thu Jan  8 08:33:59 2015 kperrey
//  hsd 2998; missing check for m6resid w/o m6
// 
//  Revision: 1.69 Thu Dec 18 10:35:55 2014 kperrey
//  move the passthru locations of the anode/cathode/bjt to make them unique
// 
//  Revision: 1.68 Fri Nov 28 18:51:08 2014 kperrey
//  virpwell_marker needs to key off _drALLOW_DNW instead of _drPROCESS; add esdScrCells d8xsesdscruvm1_prim d8xsesdscrevm1_prim ; remove the subtaps from esdScrCells; virpwell_marker needs to be oversize operation instead of undersize for texting by genesys
// 
//  Revision: 1.67 Mon Nov 10 17:41:46 2014 kperrey
//  for some ICF thing allow _drTreatGCNStrapAsReal with POLYCONRP9 to treat some gcnstrapped dummies as real gates
// 
//  Revision: 1.66 Mon Nov 10 17:36:34 2014 kperrey
//  hsd 2858 ; change dnpdnw_anode to use derived layer pwellPhysical instead of output from buildsub
// 
//  Revision: 1.65 Tue Sep 30 13:34:19 2014 kperrey
//  pass DEEPNWELL thru for debug
// 
//  Revision: 1.64 Thu Sep 25 10:13:03 2014 kperrey
//  hsd 2742 ; need to have/text poly_glbcon(poly - resid) layer for full texting to occur (handle text on the gate)
// 
//  Revision: 1.63 Sat Aug 16 12:47:17 2014 kperrey
//  include 1273/p1273dx_Tcommon_mvsw.rs for scv/sov/scm/som/aliasd derivations for icf; remove ALTRESID references ; metal*nores is passedthru from comm_mvsw now
// 
//  Revision: 1.62 Tue Aug  5 22:23:40 2014 kperrey
//  removed reference to scm/som/scv/sov devices and via*nores since they were not program approved enhancements as per chia-hong
// 
//  Revision: 1.61 Thu Jul 31 22:34:41 2014 kperrey
//  hsd 2425 ; support for sov/sovx/scv/scvm via resistors
// 
//  Revision: 1.60 Thu Jul 17 20:26:47 2014 kperrey
//  hsd 2567 ; create nulv1/pulv1 device layers using NU1/PU1
// 
//  Revision: 1.59 Thu Jul 17 11:27:57 2014 kperrey
//  include p1273dx_Tcommon_sclmfc.rs for scaleable mfc support
// 
//  Revision: 1.58 Mon Jul  7 15:44:46 2014 kperrey
//  hsd 2425; add the derivations to create resSom altres and altresSom devices for all the metal layers ; change metal resistor construction checks to not interacting with the nores metal (i.e. flag isolated resid)
// 
//  Revision: 1.57 Wed Apr 23 10:44:14 2014 kperrey
//  RFREQDEVTYPE must be covered by TEMPLATEID1 ; makes it subject to libInteg checks
// 
//  Revision: 1.56 Fri Apr 18 10:51:22 2014 kperrey
//  hsd 2297 add check for deprecated templates d8xsdcpiptgevm2 d8xsdcpiptgevm4
// 
//  Revision: 1.55 Thu Apr 17 14:32:55 2014 kperrey
//  added another construction check pwell_subiso cant cut  DEEPNWELL
// 
//  Revision: 1.54 Thu Apr 10 16:07:52 2014 kperrey
//  change SD_03 to be inside instead of outside
// 
//  Revision: 1.53 Thu Apr 10 14:18:47 2014 kperrey
//  added construction checks SD_0[1-4] for STACKDEVTYPE
// 
//  Revision: 1.52 Fri Mar 21 15:52:14 2014 kperrey
//  hsd 2176; init hv_gnac_id when _drLIB_NOFILTER == _drYES
// 
//  Revision: 1.51 Tue Mar 18 16:38:28 2014 kperrey
//  add the ICF mim_scl stuff
// 
//  Revision: 1.50 Tue Mar 18 10:23:52 2014 kperrey
//  change variable for DNW from _drPROCESS to _drALLOW_DNW
// 
//  Revision: 1.49 Tue Mar 11 17:19:30 2014 kperrey
//  support for IMC RF devices ; replace RFREQSTLEN by using a STACKDEVTYPE qual'd by RFREQDEVTYPE ; RFREQYMULT/RFREQXMULT/RFREQSTLEN are all obsolete ; generic rcextract need to remove gates from poly_nores
// 
//  Revision: 1.48 Thu Feb 20 19:55:36 2014 kperrey
//  hsd 2130 ; support the nstk/pstk device identified by nomStack;devType 82;99
// 
//  Revision: 1.47 Thu Feb 20 10:53:13 2014 kperrey
//  moved where the rfreqgate is defined, now after all the dummies are removed from gate first
// 
//  Revision: 1.46 Thu Feb 20 07:47:29 2014 kperrey
//  hsd 2128 ; change RF device derivation since we now have ID's for stlen xmult and ymult
// 
//  Revision: 1.45 Fri Jan 24 10:43:29 2014 kperrey
//  remove metalc11 refrence ; no longer exists
// 
//  Revision: 1.44 Sun Jan  5 16:22:31 2014 kperrey
//  flag any RF devices that is not np/rf np/uv2 np/tg /np/tgulv
// 
//  Revision: 1.43 Fri Jan  3 14:56:44 2014 cpark3
//  added a switch for DTS extraction runset
// 
//  Revision: 1.42 Fri Jan  3 12:11:53 2014 kperrey
//  IMC updates for support of RF devices
// 
//  Revision: 1.41 Wed Dec 18 18:56:19 2013 kperrey
//  updated to reflect tmc1 name change and mcr2 define
// 
//  Revision: 1.40 Wed Nov  6 07:39:28 2013 kperrey
//  as per eric wang add support for MTJ
// 
//  Revision: 1.39 Wed Nov  6 07:32:45 2013 kperrey
//  hsd 1926 ; add MCR derivations and checks
// 
//  Revision: 1.38 Wed Oct  2 10:00:25 2013 kperrey
//  change C4B references to C4BEMIB which is the old C4B + new smaller C4EMIB bumps
// 
//  Revision: 1.37 Mon Sep  9 12:01:53 2013 kperrey
//  remove POLY from the pwelltaps to break them up
// 
//  Revision: 1.36 Thu Sep  5 14:26:36 2013 kperrey
//  hsd 1866 ; support ICF scaleable inductor ind2t_scl_*
// 
//  Revision: 1.35 Mon Jun 10 08:46:04 2013 kperrey
//  added djnw support for perc
// 
//  Revision: 1.34 Wed Jun  5 21:30:06 2013 kperrey
//  dot6 always treat as MSR ; update pwell generation generation for dot6
// 
//  Revision: 1.33 Thu Mar 28 18:15:44 2013 kperrey
//  add the pwell layers for 1273.6 ; add v12/m12 defs ; support diodes for pwells
// 
//  Revision: 1.32 Fri Mar 22 08:51:19 2013 kperrey
//  add support for nal160/pal160 device (V3PITCHID not TGOXID)
// 
//  Revision: 1.31 Wed Jan  9 15:06:05 2013 kperrey
//  change error message for PV* usage over P device to reflect correct device type
// 
//  Revision: 1.30 Fri Dec 28 12:00:07 2012 kperrey
//  added handling for NV3/PV3
// 
//  Revision: 1.29 Thu Dec 13 17:40:17 2012 kperrey
//  hsd 1430; start of support for MSR; optionally use PWELL_SUBISO to create virtually isolate sub regions
// 
//  Revision: 1.28 Mon Nov 19 10:15:59 2012 kperrey
//  allow all the layer derivation to occur even if layer does not exist for that dot ; make VIAX TM1RESID illegal dependant upon which dot
// 
//  Revision: 1.27 Thu Oct 18 15:57:30 2012 kperrey
//  LMIPAD should not be over RDLRESID
// 
//  Revision: 1.26 Fri Oct 12 10:57:45 2012 kperrey
//  hsd 1392 ; new rdl layers resid termID ; removed text from rdl cap/pad ; delete compound rdlall
// 
//  Revision: 1.25 Fri Aug 10 11:28:48 2012 kperrey
//  support for 73.6 add m10/m11
// 
//  Revision: 1.24 Mon Jul 30 23:28:20 2012 kperrey
//  hsd 1309 ; add d8xsesdclampres d8xsesdclamprestg to cell lists for esdng_d8xlesdclampres_prim and esdng_d8xlesdclamptgres_prim respectively
// 
//  Revision: 1.23 Fri May  4 10:40:16 2012 kperrey
//  add support for skipping stuff with _drLVSONLY mimics _drSigPlot
// 
//  Revision: 1.22 Mon Apr  9 15:09:50 2012 kperrey
//  add hooks for rcextract/scarlet
// 
//  Revision: 1.21 Tue Mar 13 16:36:24 2012 kperrey
//  most and/nots for device layers now use dev_ext_level which defaults to HIERARCHICAL and Scarlet will define to CELL_LEVEL
// 
//  Revision: 1.20 Tue Mar  6 12:23:26 2012 kperrey
//  as per rc extract team remove ZONES include
// 
//  Revision: 1.19 Tue Jan 31 14:11:35 2012 kperrey
//  add LVS_DUMMYGATE as qualifier for drFindDummyGates
// 
//  Revision: 1.18 Wed Jan 18 09:14:13 2012 kperrey
//  maybe a change to how F2011.09 code handled substrate which was never really derived; now use buildsub to build __drsubrstate and globally replace substrate with __drsubstrate
// 
//  Revision: 1.17 Wed Jan 18 09:09:52 2012 kperrey
//  1272/p1272dx_Tcommon.rs
// 
//  Revision: 1.16 Tue Jan 17 10:12:18 2012 kperrey
//  as per chinmay djx_ESDcells same between 72/73 ; also remove old name only keep term cells
// 
//  Revision: 1.15 Mon Jan 16 20:11:10 2012 kperrey
//  added d8xsesddpuvterm,d8xsesddnuvterm to djx_esdCells so djn/p_esd will be extracted as per Chinmay
// 
//  Revision: 1.14 Wed Jan  4 11:16:41 2012 kperrey
//  as per OZ ; only disallow NV* PV* touch over active gates ; moved device check code to later in runset since need n/pgateZL for check now
// 
//  Revision: 1.13 Thu Dec 29 09:18:47 2011 kperrey
//  added debug layer to PassthruStack ; removed some old variable definitions - they are actually defined in p12723_defines.rs (max_poly_cd)
// 
//  Revision: 1.12 Tue Dec 20 15:38:01 2011 kperrey
//  DIODEIDmodCells had 2 c8xmbgdiodehvm1 listed changed one to d8xmbgdiodehvm1
// 
//  Revision: 1.11 Tue Nov  8 12:30:47 2011 kperrey
//  rework the bad layer usage ; bad device checks
// 
//  Revision: 1.10 Thu Nov  3 23:01:35 2011 kperrey
//  add the annotation layers to debug the 250-3;33 layers
// 
//  Revision: 1.9 Fri Oct 21 14:03:04 2011 kperrey
//  rework bad nal/pal checks and added cases for ?v0/v1/v2 interactions; reorg all illegal_devices or bad_layer usage together
// 
//  Revision: 1.8 Fri Oct 21 10:58:10 2011 kperrey
//  add NV/PV0 (nuv0/puv0) devices and change nal/pal to nuva/puva
// 
//  Revision: 1.7 Fri Oct 14 16:47:49 2011 kperrey
//  add hook for ninghe if sigplot then can ignore dif if DR_SigplotNODIFF is set
// 
//  Revision: 1.6 Sat Oct  8 15:48:31 2011 kperrey
//  hsd 991; add support for d8xmesdclampres d8xsesdclamptgres ; assume prim name will ultimately follow naming convention d8 something
// 
//  Revision: 1.5 Tue Oct  4 17:32:41 2011 kperrey
//  skip the construction checks if _drSigPlot
// 
//  Revision: 1.4 Wed Sep 28 16:56:13 2011 kperrey
//  had to update max_poly_cd to be TPL_01
// 
//  Revision: 1.3 Tue Aug  2 21:16:47 2011 kperrey
//  flag NALMG and PALMG as illegal layers
// 
//  Revision: 1.2 Thu Jul 14 16:36:27 2011 kperrey
//  XGOXID/ULPPITCHID legal in 73; removed some old commented out stuff
// 
//  Revision: 1.1 Wed Jul 13 22:29:04 2011 kperrey
//  mvfile on Wed Jul 13 22:29:04 2011 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p12723_Tcommon.rs;1.38
// 
//  Revision: 1.38 Fri Jul  8 15:30:52 2011 kperrey
//  added c8xmesddnevm1 c8xmesddpevm1 to djx_esdCells ; hsd 903
// 
//  Revision: 1.37 Sun Jun 26 09:37:37 2011 oakin
//  added new 1273 devices.
// 
//  Revision: 1.36 Fri May 13 09:53:36 2011 oakin
//  updated diode name and clampres name.
// 
//  Revision: 1.35 Fri Apr 22 09:15:54 2011 oakin
//  updated the bgdiode cell name.
// 
//  Revision: 1.34 Wed Apr  6 22:33:44 2011 kperrey
//  create active layer from nactive/pactive for rcextract
// 
//  Revision: 1.33 Tue Mar 22 16:22:11 2011 kperrey
//  change _met*pin to met*bcpin ; change _MET*TERMID to met*bctermid ; add diffcon resistor (diffcon and diffconresid) ; removed TCN1 checks ; add TCN1 as IL
// 
//  Revision: 1.32 Fri Mar 18 10:49:15 2011 kperrey
//  change _METAL* naming convntion to METAL?BC and MET*RESID to MET*BCRESID
// 
//  Revision: 1.31 Mon Mar 14 13:03:36 2011 kperrey
//  add dummy generation to debug layers list ; *enc_COMMON limit by poly prior to diffusion ; leace max_poly_cd at BPL_01 and remove dependency on future tg widths
// 
//  Revision: 1.30 Thu Feb 24 08:19:27 2011 kperrey
//  change algorithm for dr_poly_diff_enc_COMMON from enclose to size/boolean ; add TGPITCHID/XGOXID/ULPPITCHID as illegal
// 
//  Revision: 1.29 Tue Feb 22 10:37:47 2011 kperrey
//  flag POLYTD/ALTLEIDLL/LLPMG/LLNMG as illegal layers
// 
//  Revision: 1.28 Sat Feb 19 11:43:28 2011 kperrey
//  pass thru taps and ndiff/pdiff text in debug mode
// 
//  Revision: 1.27 Wed Feb 16 19:21:40 2011 kperrey
//  removed _2txt layer generation - use text as drawn as per x72 and library (kamal/leslie) to match scarlet
// 
//  Revision: 1.26 Tue Feb  1 10:02:27 2011 kperrey
//  for IDC provide method to ignore n/pv1 and n/pv2 layers
// 
//  Revision: 1.25 Fri Jan 14 16:05:33 2011 kperrey
//  change XLLPITCHID to ULPPITCHID
// 
//  Revision: 1.24 Wed Jan 12 15:50:45 2011 kperrey
//  mte/mbe to ce1/ce2 name change ; add ce3 into connect
// 
//  Revision: 1.23 Tue Dec 21 16:28:23 2010 kperrey
//  changed original esd_ngate to all_esd_ngate ; all_esd_ngate is now only used for 1st gate-blocked 4-terminal nwell resistor extraction ; change illdev gate and wellres_id to be (allgates not all_esd_ngate) and WELLRES_ID
// 
//  Revision: 1.22 Mon Dec 20 19:15:22 2010 kperrey
//  removed the _METAL? and _MET?RESID generation - these are now assigned ; change b/c pin merging to be _met?pin instead of _MET?PORT (consistant name)
// 
//  Revision: 1.21 Fri Dec 17 16:29:41 2010 kperrey
//  fixed typo in p version of djx_esdCells ; then n version was listed twice
// 
//  Revision: 1.20 Fri Dec 17 13:01:04 2010 kperrey
//  add some more resistor construction checks - rbody cant have ports/via/cons in them
// 
//  Revision: 1.19 Thu Dec  9 20:24:25 2010 kperrey
//  add illdev checks for device with both nv1/2 or pv1/2
// 
//  Revision: 1.18 Thu Dec  9 15:25:50 2010 kperrey
//  use empty_violation() to init Error layersp12723_Tconn.rs
// 
//  Revision: 1.17 Tue Dec  7 14:41:58 2010 kperrey
//  dupe code from common to handle poly diff pullback ; updated drFindDummyGates to handle dr_poly_diff_enc_COMMON as POLYDUMMYID ; handle n/paluv1/2 dev creation from mos_n/pgate_a and with N/PV1/2
// 
//  Revision: 1.16 Fri Nov 19 10:24:03 2010 kperrey
//  change include Zones to ZONES remove DFM as per Phillip
// 
//  Revision: 1.15 Thu Nov 18 16:41:20 2010 kperrey
//  change djx_esdCells from c8xm to c8xl
// 
//  Revision: 1.14 Wed Nov 17 22:21:55 2010 kperrey
//  change POLYTD references to NAL or PAL, for analog device recognition
// 
//  Revision: 1.13 Tue Oct 26 16:02:51 2010 kperrey
//  pass extracted gates to drFindGateZL function
// 
//  Revision: 1.12 Tue Oct 26 13:58:59 2010 kperrey
//  add hook for RC extract code - extract new layer npickup_notrim
// 
//  Revision: 1.11 Fri Oct 15 15:05:49 2010 kperrey
//  updated b8/c8 names to latest spec from S Zickel
// 
//  Revision: 1.10 Tue Oct 12 09:18:12 2010 kperrey
//  major rewrite to support N/PV1 and N/PV2 layers  ; make device layers follow consistant naming convention ; add new 1272 device table ; add some more device generation checks
// 
//  Revision: 1.9 Mon Oct 11 10:16:50 2010 kperrey
//  METALC*PORT to METC*PORT ; METALC*RESID to METC*RESID ; simplify gate removal in inductors ; add new 1272 dev table ; remove altle support ; add nuv/puv1 and nuv/puv2 support ; remove lllp and add v1/2lp support ; move gnac construction checks from Tconn
// 
//  Revision: 1.8 Mon Sep 20 16:09:03 2010 kperrey
//  v0/mh/vh namechange vc/m0/v0
// 
//  Revision: 1.7 Thu Aug 26 21:44:47 2010 kperrey
//  add full-time support thru M11
// 
//  Revision: 1.6 Wed Aug 11 14:16:15 2010 kperrey
//  change rbgnwell cells to expected 1272 c8 lib name b8 to c8 prefix reference
// 
//  Revision: 1.5 Mon Aug  9 21:28:00 2010 kperrey
//  change DIFFCONPORT/POLYCONPORT to diffconpin/polyconpin which is the merged MW data
// 
//  Revision: 1.4 Mon Aug  9 19:50:27 2010 kperrey
//  change MET*PORT to be met*pin for post MWDATA merge
// 
//  Revision: 1.3 Wed Aug  4 23:23:03 2010 kperrey
//  added support for djn_esd and djp_esd
// 
//  Revision: 1.2 Fri Jul 23 11:27:20 2010 kperrey
//  change EDRAM_ID to FE_EDRAM_ID
// 
//  Revision: 1.1 Thu Jul 22 14:07:24 2010 kperrey
//  mvfile on Thu Jul 22 14:07:24 2010 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p1272_Tcommon.rs;1.4
// 
//  Revision: 1.4 Thu Jul 22 14:07:13 2010 kperrey
//  update 1272/12723 name change ; handle met0 and via0 ; remove tcn1/2 reference ; remove bit partical gate handling - handle normally - no longer need zl function - finddummy should generate needed info
// 
//  Revision: 1.3 Thu Jun 24 23:16:02 2010 kperrey
//  add 1271 device types - add TH_03-5 and max_poly_cd till in dr - add b8x 1271 cells - hvgnac support - limit polycon/diffcon text - remove POLY from diode regions
// 
//  Revision: 1.2 Wed Jun 23 20:36:04 2010 kperrey
//  simplify bb extraction - handle the primary/complement layers texting ports resid
// 
//  Revision: 1.1 Tue May 25 15:04:40 2010 kperrey
//  from p1270
// 
// 
//  converted p1270_Tcommon.rs

#ifndef _P1273DX_TCOMMON_RS_
#define _P1273DX_TCOMMON_RS_

// init error handling
Error_Bad_NV0_PV0_NV1_PV1_NV2_PV2_NV3_PV3 = empty_violation();
drErrHash["Bad_NV0_PV0_NV1_PV1_NV2_PV2_NV3_PV3"] = Error_Bad_NV0_PV0_NV1_PV1_NV2_PV2_NV3_PV3 ;
drErrGDSHash["Bad_NV0_PV0_NV1_PV1_NV2_PV2_NV3_PV3"] = {999,3500};
Error_Bad_NAL_PAL = empty_violation();
drErrHash["Bad_NAL_PAL"] = Error_Bad_NAL_PAL ;
drErrGDSHash["Bad_NAL_PAL"] = {999,3501};
Error_Bad_GATED_NACID = empty_violation();
drErrHash["Bad_GATED_NACID"] = Error_Bad_GATED_NACID ;
drErrGDSHash["Bad_GATED_NACID"] = {999,3502};
Error_Bad_ACTCAP_ID = empty_violation();
drErrHash["Bad_ACTCAP_ID"] = Error_Bad_ACTCAP_ID ;
drErrGDSHash["Bad_ACTCAP_ID"] = {999,3503};
Error_Bad_POLYOD = empty_violation();
drErrHash["Bad_POLYOD"] = Error_Bad_POLYOD ;
drErrGDSHash["Bad_POLYOD"] = {999,3504};
Error_Bad_ULPPITCHID = empty_violation();
drErrHash["Bad_ULPPITCHID"] = Error_Bad_ULPPITCHID ;
drErrGDSHash["Bad_ULPPITCHID"] = {999,3505};
Error_Bad_V3PITCHID = empty_violation();
drErrHash["Bad_V3PITCHID"] = Error_Bad_V3PITCHID ;
drErrGDSHash["Bad_V3PITCHID"] = {999,3506};
Error_Bad_V1PITCHID = empty_violation();
drErrHash["Bad_V1PITCHID"] = Error_Bad_V1PITCHID ;
drErrGDSHash["Bad_V1PITCHID"] = {999,3507};
Error_Bad_XGOXID = empty_violation();
drErrHash["Bad_XGOXID"] = Error_Bad_XGOXID ;
drErrGDSHash["Bad_XGOXID"] = {999,3508};
Error_illdev_nxingwell = empty_violation();
drErrHash["illdev_nxingwell"] = Error_illdev_nxingwell ;
drErrGDSHash["illdev_nxingwell"] = {999,3509};
Error_illdev_pxingwell = empty_violation();
drErrHash["illdev_pxingwell"] = Error_illdev_pxingwell ;
drErrGDSHash["illdev_pxingwell"] = {999,3510};
Error_illdev = empty_violation();
drErrHash["illdev"] = Error_illdev ;
drErrGDSHash["illdev"] = {999,3511};

// initialize cell lists variables for trace
djx_esdCells:list of string = {"c8xmesddnevterm", "c8xmesddpevterm", "d8xsesddpuvterm", "d8xsesddnuvterm"};
DIODEIDmodCells:list of string = {"*","!c8xmbgdiodehvm1*","!d8xmbgdiodehvm1*" };
gateNoEDMCells:list of string =  {"*"};
esdScrCells:list of string = {
  "d8xsesdscruvm1_prim", "d8xsesdscrevm1_prim" //, 
//  "d87sesdscruvm1_prim", "d87sesdscrevm1_prim" 
};


// buildsub
// if msr generate the "virtual" pwell markers ; by default DEEPNWELL allows MSR
#if (defined(_drMSR) || _drALLOW_DNW )
   // marker rings  to create the pwell regions
   // needs to be oversize else text at ll will be dropped
   virpwell_marker = size(PWELL_SUBISO, distance = .0002) not PWELL_SUBISO ;   
#else
   virpwell_marker = empty_layer();
#endif

// if dot6 generate the real pwell markers
#if _drALLOW_DNW
   pwell_marker = DEEPNWELL and ALLNWELL;
   pwellPhysical = DEEPNWELL not ALLNWELL;
   pwell_dnw = buildsub(pwell_marker);
   all_pwell_marker = virpwell_marker or pwell_marker;
   pwell = buildsub(all_pwell_marker);
#else
   pwell_marker = empty_layer();
   pwellPhysical = empty_layer();
   pwell_dnw = empty_layer();
   all_pwell_marker = empty_layer();
   pwell = empty_layer();
#endif

__drsubstrate = buildsub(virpwell_marker);

// merge metal and metalc port layers (*pin is now the post MWData merge)
// treat _metxpin as metxpin and DO NOT MODIFY 
met0bcpin = met0pin or metc0pin;
met1bcpin = met1pin or metc1pin;
met2bcpin = met2pin or metc2pin;
met3bcpin = met3pin or metc3pin;
met4bcpin = met4pin or metc4pin;
met5bcpin = met5pin or metc5pin;
met6bcpin = met6pin or metc6pin;
met7bcpin = met7pin or metc7pin;
met8bcpin = met8pin or metc8pin;
met9bcpin = met9pin or metc9pin;
met10bcpin = met10pin or metc10pin;
met11bcpin = copy(met11pin);
met12bcpin = copy(met12pin);
tm1bcpin = copy(tm1pin);

// merge metal and metalc termid layers
// treat METxTERMID as METxTERMID[1-4] and DO NOT MODIFY 
polytermid = POLYTERMID1 or POLYTERMID2 or 
   POLYTERMID3 or POLYTERMID4;
pctermid = PCTERMID1 or PCTERMID2 or 
   PCTERMID3 or PCTERMID4;
dctermid = DCTERMID1 or DCTERMID2 or 
   DCTERMID3 or DCTERMID4;
met0bctermid = MET0TERMID1 or METC0TERMID1 or
   MET0TERMID2 or METC0TERMID2 or
   MET0TERMID3 or METC0TERMID3 or
   MET0TERMID4 or METC0TERMID4;
met1bctermid = MET1TERMID1 or METC1TERMID1 or
   MET1TERMID2 or METC1TERMID2 or
   MET1TERMID3 or METC1TERMID3 or
   MET1TERMID4 or METC1TERMID4;
met2bctermid = MET2TERMID1 or METC2TERMID1 or
   MET2TERMID2 or METC2TERMID2 or
   MET2TERMID3 or METC2TERMID3 or
   MET2TERMID4 or METC2TERMID4;
met3bctermid = MET3TERMID1 or METC3TERMID1 or
   MET3TERMID2 or METC3TERMID2 or
   MET3TERMID3 or METC3TERMID3 or
   MET3TERMID4 or METC3TERMID4;
met4bctermid = MET4TERMID1 or METC4TERMID1 or
   MET4TERMID2 or METC4TERMID2 or
   MET4TERMID3 or METC4TERMID3 or
   MET4TERMID4 or METC4TERMID4;
met5bctermid = MET5TERMID1 or METC5TERMID1 or
   MET5TERMID2 or METC5TERMID2 or
   MET5TERMID3 or METC5TERMID3 or
   MET5TERMID4 or METC5TERMID4;
met6bctermid = MET6TERMID1 or METC6TERMID1 or
   MET6TERMID2 or METC6TERMID2 or
   MET6TERMID3 or METC6TERMID3 or
   MET6TERMID4 or METC6TERMID4;
met7bctermid = MET7TERMID1 or METC7TERMID1 or
   MET7TERMID2 or METC7TERMID2 or
   MET7TERMID3 or METC7TERMID3 or
   MET7TERMID4 or METC7TERMID4;
met8bctermid = MET8TERMID1 or METC8TERMID1 or
   MET8TERMID2 or METC8TERMID2 or
   MET8TERMID3 or METC8TERMID3 or
   MET8TERMID4 or METC8TERMID4;
met9bctermid = MET9TERMID1 or METC9TERMID1 or
   MET9TERMID2 or METC9TERMID2 or
   MET9TERMID3 or METC9TERMID3 or
   MET9TERMID4 or METC9TERMID4;
met10bctermid = MET10TERMID1 or METC10TERMID1 or
   MET10TERMID2 or METC10TERMID2 or
   MET10TERMID3 or METC10TERMID3 or
   MET10TERMID4 or METC10TERMID4;
met11bctermid = MET11TERMID1 or MET11TERMID2 or 
   MET11TERMID3 or MET11TERMID4;
met12bctermid = MET12TERMID1 or MET12TERMID2 or 
   MET12TERMID3 or MET12TERMID4;
tm1bctermid = TM1TERMID1 or TM1TERMID2 or TM1TERMID3 or TM1TERMID4 ;
rdltermid = RDLTERMID1 or RDLTERMID2 or RDLTERMID3 or RDLTERMID4 ;
mcrtermid = MCRTERMID1 or MCRTERMID2 or MCRTERMID3 or MCRTERMID4 ;
mcr2termid = MCR2TERMID1 or MCR2TERMID2 or MCR2TERMID3 or MCR2TERMID4 ;

// poly extent after closing the gap with negative diff enclosure.  
  ogd_poly_edges = angle_edge(POLY and DIFF, angles = non_gate_angle);
  //  takes too much memory on x72 100G and 22min or 70g and 31 min
  // dr_poly_diff_enc_COMMON = enclose(ogd_poly_edges, DIFF, distance <= PL_13, direction = gate_dir, extension = NONE_INCLUSIVE);
  // find poly ends on diff and grow by pl_13 and clip back to diffusion
#ifdef _drRCextract
  dr_poly_diff_enc_COMMON = (edge_size(ogd_poly_edges, outside = PL_13, processing_mode=CELL_LEVEL) not [processing_mode=CELL_LEVEL] POLY) and [processing_mode=CELL_LEVEL] DIFF; 
#else
  dr_poly_diff_enc_COMMON = (edge_size(ogd_poly_edges, outside = PL_13) not POLY) and DIFF;
#endif
  POLY_ext = polygon_extents(POLY or dr_poly_diff_enc_COMMON);

// handle DIODEID from bx8bgdiode cells
// used in cell but not for device recognition 
DIODEIDmod = copy_by_cells(DIODEID, DIODEIDmodCells, depth = CELL_LEVEL);

// controls whether or not caps and gnac are extracted and then filtered
#if _drLIB_NOFILTER == _drYES
   // if DR_LIB_NOFILTER then ignore GATED_NACID and ACTCAP_ID 
   hv_gnac_id = empty_layer();
   drGATED_NACID = empty_layer();
   drACTCAP_ID = empty_layer();
#else
   // new methodology want user to GATED_NACID on both gates of hvgnac 
   // these will make new type nhvgatednac
   hv_gnac_id = copy_by_cells(GATED_NACID, hvgnacs, depth = CELL_LEVEL);
   drGATED_NACID = GATED_NACID not hv_gnac_id;
   drACTCAP_ID = copy(ACTCAP_ID);
#endif  // end _drLIB_NOFILTER

#if _drSigPlot == _drYES
   #ifdef  _drSigplotNODIFF
      NDIFF = empty_layer();
      PDIFF = empty_layer();
   #endif
#endif

#ifndef _drIGNORE_NV_PV 
   _NV0 = copy(NV0);
   _NV1 = copy(NV1);
   _NV2 = copy(NV2);
   _NV3 = copy(NV3);
   _PV0 = copy(PV0);
   _PV1 = copy(PV1);
   _PV2 = copy(PV2);
   _PV3 = copy(PV3);
#else
   _NV0 = empty_layer();
   _NV1 = empty_layer();
   _NV2 = empty_layer();
   _NV3 = empty_layer();
   _PV0 = empty_layer();
   _PV1 = empty_layer();
   _PV2 = empty_layer();
   _PV3 = empty_layer();
#endif

#if (! defined(_drTreatGCNStrapAsReal))
   _POLYCONRP9 = empty_layer();
#else
   _POLYCONRP9 = copy(POLYCONRP9);
#endif

// cleanup and generate stackdevtype and stackdevtyperf
stackdevtyperf = STACKDEVTYPE and RFREQDEVTYPE;
stackdevtype = STACKDEVTYPE not RFREQDEVTYPE;

// base diffusion typing
// p inside well is pactive
// n outside well is nactive
pactive = PDIFF and [dev_ext_level] ALLNWELL;
nactive = NDIFF not [dev_ext_level] ALLNWELL;

// handle scr cells (hack for subtaps) 
esdScrSubtap = copy_by_cells(PDIFF, esdScrCells) not ALLNWELL;

// n inside well is npickup (also source layer for special devices bgdiodes/rgbnwell/varactors)
// p outside well is ppickup
ppickup = PDIFF not [dev_ext_level] ALLNWELL;
pwelltap = ppickup and DEEPNWELL;
ppickup = ppickup not (DEEPNWELL or esdScrSubtap);
npickup = NDIFF and [dev_ext_level] ALLNWELL;  // will need further classification later
npickup_notrim = copy(npickup);

// create the sd regions for mosfet
nsd = nactive not [dev_ext_level] POLY; 
psd = pactive not [dev_ext_level] POLY;
all_sd = nsd or psd;

// create the mos gates
gate = (nactive or pactive) and [dev_ext_level] POLY;
all_gate = copy(gate);  // save for later use

// remove all gates in the etchring 
gate = gate not [dev_ext_level] ETCHRINGID;

// remove gates from the edm cell
// only 1 cell based upon X10
gate = copy_by_cells(gate, gateNoEDMCells, depth = CELL_LEVEL);
 
// remove gates from the PRS cells 
gate = gate not [dev_ext_level] (FIDUCIALID or PRSDUMMYID);

// remove gates from the DIC
gate = gate not [dev_ext_level] (NES_ID or ISO_ID);

// remove gates from the inductors 
gate = gate not [dev_ext_level] INDUCTORID1;


// // ANALOG GATE definition
// // analog gate is defined by NAL/PAL implant
// 
// gate_A = gate and (NALMG or PALMG);
// 
// drFindDummyGates(_gate_all = gate_A, _sd_regions = all_sd, _dummy_id = (POLYDUMMYID or dr_poly_diff_enc_COMMON), _polycon = POLYCON);
// gate_w_gcn_A = return4.layer1;
// gate_dummyid_A  = return4.layer2;
// nonrect_gate_A = return4.layer3;
// half_gate_A = return4.layer4;
// 
// all_dummy_A = gate_w_gcn_A or gate_dummyid_A or nonrect_gate_A or half_gate_A;
// 
// // valid analog gate is analog gate not the dummies
// gate_A = gate_A not all_dummy_A;

// ANALOG GATE ends


// // DIGITAL GATE definition
// // remove all the dummy analog gates from digital
// gate_D = gate not (NALMG or PALMG);
// 
// drFindDummyGates(_gate_all = gate_D, _sd_regions = all_sd, _dummy_id = (POLYDUMMYID or dr_poly_diff_enc_COMMON), _polycon = POLYCON);
// gate_w_gcn_D = return4.layer1;
// gate_dummyid_D  = return4.layer2;
// nonrect_gate_D = return4.layer3;
// half_gate_D = return4.layer4;
// 
// all_dummy_D = gate_w_gcn_D or gate_dummyid_D or nonrect_gate_D or half_gate_D;
// 
// // valid digital gate is digital gate not the dummies
// gate_D = gate_D not all_dummy_D;
// 
// // DIGITAL GATE ends


// OZ: add the analog  to the  gate and all_dummy_gate definitions 
//gate = gate_D or gate_A;


//  GATE definition
// remove all the dummy analog gates from digital

drFindDummyGates(_gate_all = gate, _sd_regions = all_sd, _dummy_id = (POLYDUMMYID or LVS_DUMMYGATE or dr_poly_diff_enc_COMMON), _polycon = POLYCON);
gate_w_gcn = return4.layer1 not _POLYCONRP9;
gate_dummyid  = return4.layer2;
nonrect_gate = return4.layer3;
half_gate = return4.layer4;

all_dummy = gate_w_gcn or gate_dummyid or nonrect_gate or half_gate;

// valid digital gate is digital gate not the dummies
gate = gate not [dev_ext_level] all_dummy;

// remove gates from RF cells will be extracted separately
rfreqgate = gate and RFREQDEVTYPE;   // these will have to be typed later 
gate = gate not rfreqgate; 

// GATE ends

// handle gates that are in diodeid
dummy_diode_gate = gate and [dev_ext_level] DIODEIDmod;
gate = gate not [dev_ext_level] dummy_diode_gate;
all_dummy_gate = all_dummy or dummy_diode_gate;
save_gate = copy(gate);

// save gates for forward bias diode check
all_dummy_gate_fbd = (gate_w_gcn or gate_dummyid or dummy_diode_gate) not [dev_ext_level] (half_gate);
p_dummy_gate_fbd = all_dummy_gate_fbd and [dev_ext_level] PDIFF and [dev_ext_level] ALLNWELL;

// make np gates
all_pgate = pactive and [dev_ext_level] gate;
all_ngate = nactive and [dev_ext_level] gate;

// create gnac gates 
// these gnac_ngate will be removed later
gnac_ngate = all_ngate and [dev_ext_level] drGATED_NACID;
hvgnac_ngate = all_ngate and [dev_ext_level] hv_gnac_id;


// extract diode definition layers 
nwell_touch_wid = NWELL interacting [ processing_mode = CELL_LEVEL ] WELLRES_ID;
isolated_nwell = NWELL not nwell_touch_wid;
cathode = isolated_nwell and DIODEIDmod;
pactive_diode = (pactive and ALLNWELL) not POLY;
anode = cathode and pactive_diode;
nac_cathode = (nactive and [ processing_mode = CELL_LEVEL ] DIODEIDmod) not POLY;
nac_anode = size(nac_cathode, distance = p1272grid);
nac_cathode_esd = copy_by_cells(nac_cathode, djx_esdCells, depth = CELL_LEVEL);
nac_cathode = nac_cathode not nac_cathode_esd ;

// deep nwell diodes
dnpdnw_anode = pwellPhysical;   // use the physical pwell and not the pwell from the buildsub
dnpdnw_cathode = size(dnpdnw_anode, distance = p1272grid);

dpndnw_cathode = copy(DEEPNWELL);
dpndnw_anode = size(dpndnw_cathode, distance = p1272grid);


// extract vdmos device 

vdwell = VDMOSID and NWELL;
vdndiff = NDIFF and VDMOSID;
// vdmos drain 
vddrain = vdwell or vdwell;
vdsrcdiff = vdndiff not vddrain;
// vdmos source 
vdsource = vdsrcdiff not POLY;
// vdmos gate 
vdgate = vdsrcdiff and POLY;
vdpoly = POLY and VDMOSID;
vsdpoly = vdpoly interacting [ count = 2 ] vdwell ;
vsdpolyndiff = vsdpoly and vdndiff;
// vsdmos gate 
vsdgate = vsdpolyndiff not [dev_ext_level] vdwell;
// vsdmos s/d 
vsdsrc = vdwell and vsdpolyndiff;

#ifdef _drCADNAV
cadnav_allngateactive = copy(all_ngate); 
cadnav_allpgateactive = copy(all_pgate);
#endif

// generate the gate used for z/l calcalulations
ngateZL = drFindGateZL(all_ngate,POLY);
pgateZL = drFindGateZL(all_pgate,POLY);
 
#if (!defined(_drSigPlot) && !defined(_drLVSONLY))
Error_Bad_NV0_PV0_NV1_PV1_NV2_PV2_NV3_PV3 @= {
  // at least 2 of the four (NV0/NV1/NV2/NV3 or PV0/PV1/PV2/PV3) are drawn over the device
  @"illdev: Badly drawn NV0 and NV1 can not overlap the same N device" ;
  (NV0 and NV1) and all_ngate;
  @"illdev: Badly drawn NV0 and NV2 can not overlap the same N device" ;
  (NV0 and NV2) and all_ngate;
  @"illdev: Badly drawn NV0 and NV3 can not overlap the same N device" ;
  (NV0 and NV3) and all_ngate;
  @"illdev: Badly drawn NV1 and NV2 can not overlap the same N device" ;
  (NV1 and NV2) and all_ngate;
  @"illdev: Badly drawn NV1 and NV3 can not overlap the same N device" ;
  (NV1 and NV3) and all_ngate;
  @"illdev: Badly drawn NV2 and NV3 can not overlap the same N device" ;
  (NV2 and NV3) and all_ngate;
  @"illdev: Badly drawn PV0 and PV1 can not overlap the same P device" ;
  (PV0 and PV1) and all_pgate;
  @"illdev: Badly drawn PV0 and PV2 can not overlap the same P device" ;
  (PV0 and PV2) and all_pgate;
  @"illdev: Badly drawn PV0 and PV3 can not overlap the same P device" ;
  (PV0 and PV3) and all_pgate;
  @"illdev: Badly drawn PV1 and PV2 can not overlap the same P device" ;
  (PV1 and PV2) and all_pgate;
  @"illdev: Badly drawn PV1 and PV3 can not overlap the same P device" ;
  (PV1 and PV3) and all_pgate;
  @"illdev: Badly drawn PV2 and PV3 can not overlap the same P device" ;
  (PV2 and PV3) and all_pgate;

  // at least 2 of the three (NV0/NV1/NV2 or PV0/PV1/PV2) abut a device
  @"illdev: Badly drawn NV0,NV1 can not touch over the same N device" ;
  edge_size((NV0 coincident_outside_edge NV1),p1272grid,p1272grid) and all_ngate and ngateZL;
  @"illdev: Badly drawn NV0,NV2 can not touch over the same N device" ;
  edge_size((NV0 coincident_outside_edge NV2),p1272grid,p1272grid) and all_ngate and ngateZL;
  @"illdev: Badly drawn NV0,NV3 can not touch over the same N device" ;
  edge_size((NV0 coincident_outside_edge NV3),p1272grid,p1272grid) and all_ngate and ngateZL;
  @"illdev: Badly drawn NV1,NV2 can not touch over the same N device" ;
  edge_size((NV1 coincident_outside_edge NV2),p1272grid,p1272grid) and all_ngate and ngateZL;
  @"illdev: Badly drawn NV1,NV3 can not touch over the same N device" ;
  edge_size((NV1 coincident_outside_edge NV3),p1272grid,p1272grid) and all_ngate and ngateZL;
  @"illdev: Badly drawn NV2,NV3 can not touch over the same N device" ;
  edge_size((NV2 coincident_outside_edge NV3),p1272grid,p1272grid) and all_ngate and ngateZL;
  @"illdev: Badly drawn PV0,PV1 can not touch over the same P device" ;
  edge_size((PV0 coincident_outside_edge PV1),p1272grid,p1272grid) and all_pgate and pgateZL;
  @"illdev: Badly drawn PV0,PV2 can not touch over the same P device" ;
  edge_size((PV0 coincident_outside_edge PV2),p1272grid,p1272grid) and all_pgate and pgateZL;
  @"illdev: Badly drawn PV0,PV3 can not touch over the same P device" ;
  edge_size((PV0 coincident_outside_edge PV3),p1272grid,p1272grid) and all_pgate and pgateZL;
  @"illdev: Badly drawn PV1,PV2 can not touch over the same P device" ;
  edge_size((PV1 coincident_outside_edge PV2),p1272grid,p1272grid) and all_pgate and pgateZL;
  @"illdev: Badly drawn PV1,PV3 can not touch over the same P device" ;
  edge_size((PV1 coincident_outside_edge PV3),p1272grid,p1272grid) and all_pgate and pgateZL;
  @"illdev: Badly drawn PV2,PV3 can not touch over the same P device" ;
  edge_size((PV2 coincident_outside_edge PV3),p1272grid,p1272grid) and all_pgate and pgateZL;
}
drPushErrorStack(Error_Bad_NV0_PV0_NV1_PV1_NV2_PV2_NV3_PV3, xc(Bad_NV0_PV0_NV1_PV1_NV2_PV2_NV3_PV3));

nalpal = NALMG or PALMG; 
Error_Bad_NAL_PAL @= {
   @"illdev: Badly drawn (NAL/PAL) can not overlap POLYOD" ;
   nalpal and POLYOD;
   @"illdev: Badly drawn (NAL/PAL) can not overlap ULPPITCHID" ;
   nalpal and ULPPITCHID;
   @"illdev: Badly drawn (NAL/PAL) can not overlap V3PITCHID" ;
   nalpal and V3PITCHID;
   @"illdev: Badly drawn (NAL/PAL) can not overlap XGOXID" ;
   nalpal and XGOXID;
   @"illdev: Badly drawn (NAL/PAL) can not overlap VDMOSID" ;
   nalpal and VDMOSID;
   @"illdev: Badly drawn (NAL/PAL) can not overlap V1PITCHID" ;
   nalpal and V1PITCHID;
   @"illdev: Badly drawn (NAL/PAL) can not overlap NV0/PV0" ;
   nalpal and (NV0 or PV0);
   @"illdev: Badly drawn (NAL/PAL) can not overlap NV1/PV1" ;
   nalpal and (NV1 or PV1);
   @"illdev: Badly drawn (NAL/PAL) can not overlap NV2/PV2" ;
   nalpal and (NV2 or PV2);
   @"illdev: Badly drawn (NAL/PAL) can not overlap NV3/PV3" ;
   nalpal and (NV3 or PV3);
}
drPushErrorStack(Error_Bad_NAL_PAL, xc(Bad_NAL_PAL));

Error_Bad_GATED_NACID @= {
   @"illdev: Badly drawn GATED_NACID can not overlap p device" ;
   all_pgate and GATED_NACID;
   @ "illdev: Badly drawn GATED_NACID must enclose ngate";
   all_ngate cutting GATED_NACID;
   @ "warning: Floating GATED_NACID";
   GATED_NACID not_interacting all_ngate;
}
drPushErrorStack(Error_Bad_GATED_NACID, xc(Bad_GATED_NACID));

Error_Bad_ACTCAP_ID @= {
   @ "warning: Floating ACTCAP_ID";
   ACTCAP_ID not_interacting (all_pgate or all_ngate);
}
drPushErrorStack(Error_Bad_ACTCAP_ID, xc(Bad_ACTCAP_ID));

Error_Bad_POLYOD @= {
   @"illdev: Badly drawn POLYOD can not overlap NAL/PAL/ULPPITCHID/V3PITCHID" ;
   POLYOD and (nalpal or ULPPITCHID or V3PITCHID or V1PITCHID);
}
drPushErrorStack(Error_Bad_POLYOD, xc(Bad_POLYOD));

Error_Bad_ULPPITCHID @= {
   @"illdev: Badly drawn ULPPITCHID can not overlap NAL/PAL/POLYOD/V3PITCHID/FE_EDRAM_ID" ;
   ULPPITCHID and (nalpal or POLYOD or V3PITCHID or V1PITCHID or FE_EDRAM_ID);
}
drPushErrorStack(Error_Bad_ULPPITCHID, xc(Bad_ULPPITCHID));

Error_Bad_V3PITCHID @= {
   @"illdev: Badly drawn V3PITCHID can not overlap NAL/PAL/POLYOD/ULPPITCHID" ;
   V3PITCHID and (nalpal or POLYOD or ULPPITCHID or V1PITCHID);
}
drPushErrorStack(Error_Bad_V3PITCHID, xc(Bad_V3PITCHID));

Error_Bad_V1PITCHID @= {
   @"illdev: Badly drawn V3PITCHID can not overlap NAL/PAL/POLYOD/ULPPITCHID" ;
   V1PITCHID and (nalpal or POLYOD or ULPPITCHID or V3PITCHID);
}
drPushErrorStack(Error_Bad_V1PITCHID, xc(Bad_V1PITCHID));

Error_Bad_XGOXID @= {
   @"illdev: Badly drawn XGOXID can not overlap NAL/PAL" ;
   XGOXID and nalpal;
   @"illdev: Badly drawn XGOXID can not overlap NV0/NV1/NV2/NV3/PV0/PV1/PV2/PV3" ;
   XGOXID and (NV0 or NV1 or NV2 or NV3 or PV0 or PV1 or PV2 or PV3);
}
drPushErrorStack(Error_Bad_XGOXID, xc(Bad_XGOXID));

#endif

// id the cap gates
cap_ngate = ngateZL and [dev_ext_level] drACTCAP_ID;
cap_pgate = pgateZL and [dev_ext_level] drACTCAP_ID;

// remove the caps
nocap_ngate = ngateZL not [dev_ext_level] drACTCAP_ID;
nocap_pgate = pgateZL not [dev_ext_level] drACTCAP_ID;



// remove VD ngate
nonvd_ngate = nocap_ngate not [dev_ext_level] VDMOSID;

// get the mos gates
mos_ngate = nonvd_ngate not [dev_ext_level] (gnac_ngate or hvgnac_ngate);
mos_pgate = copy(nocap_pgate);

// classify the mos gates into digital, analog, sram, xll, tg 
// analog
mos_ngate_a = mos_ngate and [dev_ext_level] NALMG;
mos_pgate_a = mos_pgate and [dev_ext_level] PALMG;

// sram
mos_ngate_s = mos_ngate and [dev_ext_level] POLYOD;
mos_pgate_s = mos_pgate and [dev_ext_level] POLYOD;

// xll
mos_ngate_x = mos_ngate and [dev_ext_level] (ULPPITCHID and [dev_ext_level] XGOXID);
mos_pgate_x = mos_pgate and [dev_ext_level] (ULPPITCHID and [dev_ext_level] XGOXID);

// // xlledr
// mos_ngate_xedr = mos_ngate_x and FE_EDRAM_ID;
// mos_ngate_x = mos_ngate_x not FE_EDRAM_ID;
// Error_Bad_FE_EDRAM_ID @= {
//    @"illdev: Badly drawn FE_EDRAM_ID can not exist outside ULPPITCHID" ;
//    FE_EDRAM_ID not ULPPITCHID;
// }


// tg
mos_ngate_tg = mos_ngate and [dev_ext_level] (V3PITCHID and [dev_ext_level] TGOXID);
mos_pgate_tg = mos_pgate and [dev_ext_level] (V3PITCHID and [dev_ext_level] TGOXID);

// tg160
mos_ngate_tg160 = mos_ngate and [dev_ext_level] (V3PITCHID not [dev_ext_level] TGOXID);
mos_pgate_tg160 = mos_pgate and [dev_ext_level] (V3PITCHID not [dev_ext_level] TGOXID);

// tgulv
mos_ngate_tgulv = mos_ngate and [dev_ext_level] (V1PITCHID and [dev_ext_level] TGOXID);
mos_pgate_tgulv = mos_pgate and [dev_ext_level] (V1PITCHID and [dev_ext_level] TGOXID);

// flag bad le of tg gates
// Error_Bad_TG_Le @= {
//    @"illdev: illegal Le for P thickgate device" ;
//    all_mos_ngate_tg not (mos_ngate_tg or mos_ngate_tgmv or mos_ngate_tglv);
//    @"illdev: illegal Le for P thickgate device" ;
//    all_mos_pgate_tg not (mos_pgate_tg or mos_pgate_tgmv or mos_pgate_tglv);
// }

// mos
mos_ngate = mos_ngate not [dev_ext_level] (NALMG or PALMG or POLYOD or (ULPPITCHID and [dev_ext_level] XGOXID) or (V3PITCHID and [dev_ext_level] TGOXID) or (V1PITCHID and [dev_ext_level] TGOXID) or V3PITCHID);
mos_pgate = mos_pgate not [dev_ext_level] (NALMG or PALMG or POLYOD or (ULPPITCHID and [dev_ext_level] XGOXID) or (V3PITCHID and [dev_ext_level] TGOXID) or (V1PITCHID and [dev_ext_level] TGOXID) or V3PITCHID);

// mos stk
mos_ngate_stk = mos_ngate and [dev_ext_level] stackdevtype;
mos_pgate_stk = mos_pgate and [dev_ext_level] stackdevtype;

mos_ngate = mos_ngate not [dev_ext_level] stackdevtype;
mos_pgate = mos_pgate not [dev_ext_level] stackdevtype;

// xlllp
mos_ngate_lllp = mos_ngate and [dev_ext_level] XGOXID;
mos_pgate_lllp = mos_pgate and [dev_ext_level] XGOXID;

mos_ngate = mos_ngate not [dev_ext_level] XGOXID;
mos_pgate = mos_pgate not [dev_ext_level] XGOXID;

// extract a[np]v1 from analog mos
mos_ngate_av1 = mos_ngate_a and [dev_ext_level] _NV1;
mos_pgate_av1 = mos_pgate_a and [dev_ext_level] _PV1;

// extract a[np]v2 from analog mos
mos_ngate_av2 = mos_ngate_a and [dev_ext_level] _NV2;
mos_pgate_av2 = mos_pgate_a and [dev_ext_level] _PV2;

// extract a[np]v3 from analog mos
mos_ngate_av3 = mos_ngate_a and [dev_ext_level] _NV3;
mos_pgate_av3 = mos_pgate_a and [dev_ext_level] _PV3;

// remove a[np]v[123] from analog mos 
mos_ngate_a = mos_ngate_a not [dev_ext_level] (_NV1 or _NV2 or _NV3);
mos_pgate_a = mos_pgate_a not [dev_ext_level] (_PV1 or _PV2 or _PV3);

// get n/pallp devices (Xgid + analog)
mos_ngate_alp = mos_ngate_a and [dev_ext_level] XGOXID;
mos_ngate_a = mos_ngate_a not [dev_ext_level] XGOXID;
mos_pgate_alp = mos_pgate_a and [dev_ext_level] XGOXID;
mos_pgate_a = mos_pgate_a not [dev_ext_level] XGOXID;

// rfreq classifications
// make np rfreq gates
all_prfreq = pactive and [dev_ext_level] rfreqgate;
all_nrfreq = nactive and [dev_ext_level] rfreqgate;
// the stack rf from a logic view will be the stackdevtyperf 
all_prfreq_stk = pactive and [dev_ext_level] stackdevtyperf;
all_nrfreq_stk = nactive and [dev_ext_level] stackdevtyperf;
// the rf gates under the stackdevtyperf will be used to derive the props for the stacked device
all_prfreq_stk_prop = all_prfreq and [dev_ext_level] stackdevtyperf;
all_nrfreq_stk_prop = all_nrfreq and [dev_ext_level] stackdevtyperf;
// the rf parallel gates are the rest
all_prfreq_par = all_prfreq not [dev_ext_level] stackdevtyperf;
all_nrfreq_par = all_nrfreq not [dev_ext_level] stackdevtyperf;

// adjust the nsd psd for the stacked rf devices ; assuming stackdevtyperf is line on line with the stacked rf gate region 
nsd = nsd not stackdevtyperf;
psd = psd not stackdevtyperf;

// generic rfreq
rfreq_ngate_par = copy(all_nrfreq_par);
rfreq_pgate_par = copy(all_prfreq_par);
rfreq_ngate_stk = copy(all_nrfreq_stk);
rfreq_pgate_stk = copy(all_prfreq_stk);

// rfreq analog
rfreq_ngate_par_a = rfreq_ngate_par and [dev_ext_level] NALMG;
rfreq_pgate_par_a = rfreq_pgate_par and [dev_ext_level] PALMG;
rfreq_ngate_stk_a = rfreq_ngate_stk and [dev_ext_level] NALMG;
rfreq_pgate_stk_a = rfreq_pgate_stk and [dev_ext_level] PALMG;

// rfreq xll
rfreq_ngate_par_x = rfreq_ngate_par and [dev_ext_level] (ULPPITCHID and [dev_ext_level] XGOXID);
rfreq_pgate_par_x = rfreq_pgate_par and [dev_ext_level] (ULPPITCHID and [dev_ext_level] XGOXID);
rfreq_ngate_stk_x = rfreq_ngate_stk and [dev_ext_level] (ULPPITCHID and [dev_ext_level] XGOXID);
rfreq_pgate_stk_x = rfreq_pgate_stk and [dev_ext_level] (ULPPITCHID and [dev_ext_level] XGOXID);

// rfreq tg
rfreq_ngate_par_tg = rfreq_ngate_par and [dev_ext_level] (V3PITCHID and [dev_ext_level] TGOXID);
rfreq_pgate_par_tg = rfreq_pgate_par and [dev_ext_level] (V3PITCHID and [dev_ext_level] TGOXID);
rfreq_ngate_stk_tg = rfreq_ngate_stk and [dev_ext_level] (V3PITCHID and [dev_ext_level] TGOXID);
rfreq_pgate_stk_tg = rfreq_pgate_stk and [dev_ext_level] (V3PITCHID and [dev_ext_level] TGOXID);

// rfreq tg160
rfreq_ngate_par_tg160 = rfreq_ngate_par and [dev_ext_level] (V3PITCHID not [dev_ext_level] TGOXID);
rfreq_pgate_par_tg160 = rfreq_pgate_par and [dev_ext_level] (V3PITCHID not [dev_ext_level] TGOXID);
rfreq_ngate_stk_tg160 = rfreq_ngate_stk and [dev_ext_level] (V3PITCHID not [dev_ext_level] TGOXID);
rfreq_pgate_stk_tg160 = rfreq_pgate_stk and [dev_ext_level] (V3PITCHID not [dev_ext_level] TGOXID);

// rfreq tgulv
rfreq_ngate_par_tgulv = rfreq_ngate_par and [dev_ext_level] (V1PITCHID and [dev_ext_level] TGOXID);
rfreq_pgate_par_tgulv = rfreq_pgate_par and [dev_ext_level] (V1PITCHID and [dev_ext_level] TGOXID);
rfreq_ngate_stk_tgulv = rfreq_ngate_stk and [dev_ext_level] (V1PITCHID and [dev_ext_level] TGOXID);
rfreq_pgate_stk_tgulv = rfreq_pgate_stk and [dev_ext_level] (V1PITCHID and [dev_ext_level] TGOXID);

// rfreq 
rfreq_ngate_par = rfreq_ngate_par not [dev_ext_level] (NALMG or PALMG or POLYOD or (ULPPITCHID and [dev_ext_level] XGOXID) or (V3PITCHID and [dev_ext_level] TGOXID) or (V1PITCHID and [dev_ext_level] TGOXID) or V3PITCHID);
rfreq_pgate_par = rfreq_pgate_par not [dev_ext_level] (NALMG or PALMG or POLYOD or (ULPPITCHID and [dev_ext_level] XGOXID) or (V3PITCHID and [dev_ext_level] TGOXID) or (V1PITCHID and [dev_ext_level] TGOXID) or V3PITCHID);
rfreq_ngate_stk = rfreq_ngate_stk not [dev_ext_level] (NALMG or PALMG or POLYOD or (ULPPITCHID and [dev_ext_level] XGOXID) or (V3PITCHID and [dev_ext_level] TGOXID) or (V1PITCHID and [dev_ext_level] TGOXID) or V3PITCHID);
rfreq_pgate_stk = rfreq_pgate_stk not [dev_ext_level] (NALMG or PALMG or POLYOD or (ULPPITCHID and [dev_ext_level] XGOXID) or (V3PITCHID and [dev_ext_level] TGOXID) or (V1PITCHID and [dev_ext_level] TGOXID) or V3PITCHID);

// rfreq xlllp
rfreq_ngate_par_lllp = rfreq_ngate_par and [dev_ext_level] XGOXID;
rfreq_pgate_par_lllp = rfreq_pgate_par and [dev_ext_level] XGOXID;
rfreq_ngate_stk_lllp = rfreq_ngate_stk and [dev_ext_level] XGOXID;
rfreq_pgate_stk_lllp = rfreq_pgate_stk and [dev_ext_level] XGOXID;

rfreq_ngate_par = rfreq_ngate_par not [dev_ext_level] XGOXID;
rfreq_pgate_par = rfreq_pgate_par not [dev_ext_level] XGOXID;
rfreq_ngate_stk = rfreq_ngate_stk not [dev_ext_level] XGOXID;
rfreq_pgate_stk = rfreq_pgate_stk not [dev_ext_level] XGOXID;

// extract rfreq a[np]v1 from analog rfreq mos
rfreq_ngate_par_av1 = rfreq_ngate_par_a and [dev_ext_level] _NV1;
rfreq_pgate_par_av1 = rfreq_pgate_par_a and [dev_ext_level] _PV1;
rfreq_ngate_stk_av1 = rfreq_ngate_stk_a and [dev_ext_level] _NV1;
rfreq_pgate_stk_av1 = rfreq_pgate_stk_a and [dev_ext_level] _PV1;

// extract rfreq a[np]v2 from analog rfreq mos
rfreq_ngate_par_av2 = rfreq_ngate_par_a and [dev_ext_level] _NV2;
rfreq_pgate_par_av2 = rfreq_pgate_par_a and [dev_ext_level] _PV2;
rfreq_ngate_stk_av2 = rfreq_ngate_stk_a and [dev_ext_level] _NV2;
rfreq_pgate_stk_av2 = rfreq_pgate_stk_a and [dev_ext_level] _PV2;

// extract rfreq a[np]v3 from analog rfreq mos
rfreq_ngate_par_av3 = rfreq_ngate_par_a and [dev_ext_level] _NV3;
rfreq_pgate_par_av3 = rfreq_pgate_par_a and [dev_ext_level] _PV3;
rfreq_ngate_stk_av3 = rfreq_ngate_stk_a and [dev_ext_level] _NV3;
rfreq_pgate_stk_av3 = rfreq_pgate_stk_a and [dev_ext_level] _PV3;

// remove rfreq a[np]v[123] from analog rfreq mos 
rfreq_ngate_par_a = rfreq_ngate_par_a not [dev_ext_level] (_NV1 or _NV2 or _NV3);
rfreq_pgate_par_a = rfreq_pgate_par_a not [dev_ext_level] (_PV1 or _PV2 or _PV3);
rfreq_ngate_stk_a = rfreq_ngate_stk_a not [dev_ext_level] (_NV1 or _NV2 or _NV3);
rfreq_pgate_stk_a = rfreq_pgate_stk_a not [dev_ext_level] (_PV1 or _PV2 or _PV3);

// get rfreq n/pallp devices (Xgid + analog)
rfreq_ngate_par_alp = rfreq_ngate_par_a and [dev_ext_level] XGOXID;
rfreq_ngate_par_a = rfreq_ngate_par_a not [dev_ext_level] XGOXID;
rfreq_pgate_par_alp = rfreq_pgate_par_a and [dev_ext_level] XGOXID;
rfreq_pgate_par_a = rfreq_pgate_par_a not [dev_ext_level] XGOXID;

rfreq_ngate_stk_alp = rfreq_ngate_stk_a and [dev_ext_level] XGOXID;
rfreq_ngate_stk_a = rfreq_ngate_stk_a not [dev_ext_level] XGOXID;
rfreq_pgate_stk_alp = rfreq_pgate_stk_a and [dev_ext_level] XGOXID;
rfreq_pgate_stk_a = rfreq_pgate_stk_a not [dev_ext_level] XGOXID;

// extract vt from all mos
rfreq_ngate_par_uvt = rfreq_ngate_par and [dev_ext_level] LLNMG;
rfreq_pgate_par_uvt = rfreq_pgate_par and [dev_ext_level] LLPMG;
rfreq_ngate_stk_uvt = rfreq_ngate_stk and [dev_ext_level] LLNMG;
rfreq_pgate_stk_uvt = rfreq_pgate_stk and [dev_ext_level] LLPMG;

// remove vt from all mos
rfreq_ngate_par = rfreq_ngate_par not [dev_ext_level] LLNMG;
rfreq_pgate_par = rfreq_pgate_par not [dev_ext_level] LLPMG;
rfreq_ngate_stk = rfreq_ngate_stk not [dev_ext_level] LLNMG;
rfreq_pgate_stk = rfreq_pgate_stk not [dev_ext_level] LLPMG;

// extract [np]v0 from mos
rfreq_ngate_par_v0 = rfreq_ngate_par and [dev_ext_level] NV0;
rfreq_pgate_par_v0 = rfreq_pgate_par and [dev_ext_level] PV0;
rfreq_ngate_stk_v0 = rfreq_ngate_stk and [dev_ext_level] NV0;
rfreq_pgate_stk_v0 = rfreq_pgate_stk and [dev_ext_level] PV0;

// extract [np]v1 from mos
rfreq_ngate_par_v1 = rfreq_ngate_par and [dev_ext_level] NV1;
rfreq_pgate_par_v1 = rfreq_pgate_par and [dev_ext_level] PV1;
rfreq_ngate_stk_v1 = rfreq_ngate_stk and [dev_ext_level] NV1;
rfreq_pgate_stk_v1 = rfreq_pgate_stk and [dev_ext_level] PV1;

// extract [np]v2 from mos
rfreq_ngate_par_v2 = rfreq_ngate_par and [dev_ext_level] NV2;
rfreq_pgate_par_v2 = rfreq_pgate_par and [dev_ext_level] PV2;
rfreq_ngate_stk_v2 = rfreq_ngate_stk and [dev_ext_level] NV2;
rfreq_pgate_stk_v2 = rfreq_pgate_stk and [dev_ext_level] PV2;

// extract [np]v3 from mos
rfreq_ngate_par_v3 = rfreq_ngate_par and [dev_ext_level] NV3;
rfreq_pgate_par_v3 = rfreq_pgate_par and [dev_ext_level] PV3;
rfreq_ngate_stk_v3 = rfreq_ngate_stk and [dev_ext_level] NV3;
rfreq_pgate_stk_v3 = rfreq_pgate_stk and [dev_ext_level] PV3;

// remove [np]v[012] from mos 
rfreq_ngate_par = rfreq_ngate_par not [dev_ext_level] (NV0 or NV1 or NV2 or NV3);
rfreq_pgate_par = rfreq_pgate_par not [dev_ext_level] (PV0 or PV1 or PV2 or PV3);
rfreq_ngate_stk = rfreq_ngate_stk not [dev_ext_level] (NV0 or NV1 or NV2 or NV3);
rfreq_pgate_stk = rfreq_pgate_stk not [dev_ext_level] (PV0 or PV1 or PV2 or PV3);

//extract lp devices
rfreq_ngate_par_v1lp = rfreq_ngate_par_v1 and [dev_ext_level] XGOXID;
rfreq_pgate_par_v1lp = rfreq_pgate_par_v1 and [dev_ext_level] XGOXID;
rfreq_ngate_par_v2lp = rfreq_ngate_par_v2 and [dev_ext_level] XGOXID;
rfreq_pgate_par_v2lp = rfreq_pgate_par_v2 and [dev_ext_level] XGOXID;
rfreq_ngate_stk_v1lp = rfreq_ngate_stk_v1 and [dev_ext_level] XGOXID;
rfreq_pgate_stk_v1lp = rfreq_pgate_stk_v1 and [dev_ext_level] XGOXID;
rfreq_ngate_stk_v2lp = rfreq_ngate_stk_v2 and [dev_ext_level] XGOXID;
rfreq_pgate_stk_v2lp = rfreq_pgate_stk_v2 and [dev_ext_level] XGOXID;


//remove lp from v1/v2 definition
rfreq_ngate_par_v1 = rfreq_ngate_par_v1 not [dev_ext_level] XGOXID;
rfreq_pgate_par_v1 = rfreq_pgate_par_v1 not [dev_ext_level] XGOXID;
rfreq_ngate_par_v2 = rfreq_ngate_par_v2 not [dev_ext_level] XGOXID;
rfreq_pgate_par_v2 = rfreq_pgate_par_v2 not [dev_ext_level] XGOXID;
rfreq_ngate_stk_v1 = rfreq_ngate_stk_v1 not [dev_ext_level] XGOXID;
rfreq_pgate_stk_v1 = rfreq_pgate_stk_v1 not [dev_ext_level] XGOXID;
rfreq_ngate_stk_v2 = rfreq_ngate_stk_v2 not [dev_ext_level] XGOXID;
rfreq_pgate_stk_v2 = rfreq_pgate_stk_v2 not [dev_ext_level] XGOXID;


// RESISTORS 
// get poly resistor
poly_res_cl = POLY and [processing_mode = CELL_LEVEL ] PRES_ID;
poly_nores = POLY not PRES_ID;
poly_glbcon = copy(poly_nores) ;  // needed for case where text is over gate

// handle poly in gcn resistors - remove the outer edge poly
gcnTemplate_boundary = copy_by_cells(CELLBOUNDARY, cells = gcnResistorTemplates, depth = CELL_LEVEL); 
us030GcnTemplate_boundary = size(gcnTemplate_boundary, distance = -.030, processing_mode = CELL_LEVEL);

_drtmp_edge = inside_touching_edge(POLY, us030GcnTemplate_boundary, processing_mode = CELL_LEVEL);  
os_drtmp_edge = edge_size(_drtmp_edge, inside = .001);
dr_gcn_ignore_poly = poly_nores interacting [processing_mode = CELL_LEVEL] os_drtmp_edge;
poly_nores = poly_nores not dr_gcn_ignore_poly;


nwellesd_res_cl = NWELLESD and [processing_mode = CELL_LEVEL ] WELLRES_ID;
nwellesd_nores = NWELLESD not WELLRES_ID;
nwell_res_cl = NWELL and [processing_mode = CELL_LEVEL ] WELLRES_ID;
nwell_nores = NWELL not WELLRES_ID ;
nwellresistor = NWELL cutting [processing_mode = CELL_LEVEL ] WELLRES_ID;
esdresistor = NWELLESD cutting [processing_mode = CELL_LEVEL ] WELLRES_ID;
nwellresterm = nwell_nores and nwellresistor;
esdresterm = nwellesd_nores and esdresistor;

// extract djnw for perc
#if (!defined(_drPERCDIODE))
   djnw_cathode = empty_layer();
   djnw_anode = empty_layer();
#else
   djnw_cathode = (nwell_nores not DEEPNWELL);
   djnw_anode = size(djnw_cathode, distance = p1272grid);
#endif

// extract esd_ngate
id_inside_nwesd = WELLRES_ID interacting NWELLESD;
poly_interact_idlayer = id_inside_nwesd and [processing_mode = CELL_LEVEL ] POLY;
all_esd_ngate = poly_interact_idlayer and [processing_mode = CELL_LEVEL ] NDIFF;
all_ngate = all_esd_ngate or mos_ngate ;
npickup = npickup not [dev_ext_level] POLY ;
esdng_enclosed_nwellesd_res_cl = nwellesd_res_cl enclosing [processing_mode = CELL_LEVEL ] all_esd_ngate;

#ifdef _drCADNAV
   // add esd_ngate to allngateactive 
   cadnav_allngateactive = cadnav_allngateactive or all_esd_ngate; 
#endif

// OZ: why not cell_level ????
nwellesd_res_cl	= nwellesd_res_cl not esdng_enclosed_nwellesd_res_cl;

#ifdef _drCADNAV
   nnogate = NDIFF not POLY;  // this makes more sense
   pnogate = PDIFF not POLY;
#else
   nnogate = NDIFF not (all_ngate or all_dummy_gate);
   pnogate = PDIFF not (all_pgate or all_dummy_gate);
#endif

// BJT diode 
bjt_cell = copy_by_cells(CELLBOUNDARY, cells = bgdiodes, depth = CELL_LEVEL);
us_bjt_cell = size(bjt_cell, distance = - p1272grid, processing_mode = CELL_LEVEL);
bjt_base = us_bjt_cell and isolated_nwell;
bjt_emitter = bjt_base and pactive;
bjt_collector = us_bjt_cell and ppickup;
bjt_emit = us_bjt_cell interacting bjt_emitter;
bjt_coll = bjt_emit interacting bjt_collector;



bjt_cell_2 = copy_by_cells(CELLBOUNDARY, cells = ddr2diodes, depth = CELL_LEVEL);
us_bjt_cell_2 = size(bjt_cell_2, distance = - p1272grid, processing_mode = CELL_LEVEL);
bjt_base_2 = us_bjt_cell_2 and isolated_nwell;
bjt_emitter_2 = bjt_base_2 and pactive;
bjt_collector_2 = us_bjt_cell_2 and ppickup;

cl_drd_pdiff = copy_by_cells(PDIFF, cells = ddr2diodes, depth = CELL_LEVEL); 
 
cl_drd_ptap = cl_drd_pdiff not [ processing_mode = CELL_LEVEL ] NWELL;

two_poly = POLY interacting [ processing_mode = CELL_LEVEL ] cl_drd_ptap;
space_two_poly = external1(two_poly, distance < 0.175,  processing_mode = CELL_LEVEL, extension = NONE);
us_us_bjt_cell_2 = size(us_bjt_cell_2, distance = - 0.077);
us_bjt_cell_2 = us_us_bjt_cell_2 not space_two_poly;
//
// size cl_drd_ptap {grow_gate_a = 0.4 grow_gate_b = 0.4  cell_level} temp = os_cl_drd_ptap
// boolean us_bjt_cell_2 not os_cl_drd_ptap { cell_level } temp = us_bjt_cell_2
//
bjt_emit_2 = us_bjt_cell_2 interacting bjt_emitter_2;
bjt_coll_2 = bjt_emit_2 interacting bjt_collector_2;



bjt_cell_1 = copy_by_cells(CELLBOUNDARY, cells = ddr1diodes, depth = CELL_LEVEL);
us_bjt_cell_1 = size(bjt_cell_1, distance = - p1272grid, processing_mode = CELL_LEVEL);
bjt_base_1 = us_bjt_cell_1 and isolated_nwell;
bjt_emitter_1 = bjt_base_1 and pactive;
bjt_collector_1 = us_bjt_cell_1 and ppickup;

cl_drd_pdiff = copy_by_cells(PDIFF, cells = ddr1diodes, depth = CELL_LEVEL);
cl_drd_ptap = cl_drd_pdiff not [ processing_mode = CELL_LEVEL ] NWELL;

two_poly = POLY interacting [ processing_mode = CELL_LEVEL ] cl_drd_ptap;
space_two_poly = external1(two_poly, distance < 0.085, processing_mode = CELL_LEVEL, extension = NONE);
us_us_bjt_cell_1 = size(us_bjt_cell_1, distance = - 0.077); 
us_bjt_cell_1 = us_us_bjt_cell_1 not space_two_poly; 
//
// size cl_drd_ptap {grow_gate_a = 0.4 grow_gate_b = 0.4   cell_level} temp = os_cl_drd_ptap
// boolean us_bjt_cell_1 not os_cl_drd_ptap { cell_level } temp = us_bjt_cell_1
//
bad_us_bjt_cell_1 = internal1(us_bjt_cell_1, distance < 1.5, processing_mode = CELL_LEVEL, extension = NONE);
us_bjt_cell_1 = us_bjt_cell_1 not [ processing_mode = CELL_LEVEL ] bad_us_bjt_cell_1;

bjt_emit_1 = us_bjt_cell_1 interacting bjt_emitter_1;
bjt_coll_1 = bjt_emit_1 interacting bjt_collector_1;

bjt_cell = bjt_cell or bjt_cell_2 or bjt_cell_1;

// break ppickup segments by poly
ppickup = ppickup not POLY;
pwelltap = pwelltap not POLY;

// DR_ENABLE_UVT only control uvt of device
// 1272 device table - 
// nom vt:        n             p      
// analog nom vt: nuva          puva    
// analog ll1 nom vt: naluv1    paluv1    
// analog ll2 nom vt: naluv2    paluv2    
// analog lp:     nallp         pallp  
// ll0 nom vt:    nuv0          puv0   
// ll1 nom vt:    nuv1          puv1   
// ll2 nom vt:    nuv2          puv2   
// ll1 lp:        nuv1lp        puv1lp   
// ll2 lp:        nuv2lp        puv2lp
// hi vt:         nuvt          puvt
// sram hi vt:    nsrhvt
// sram pass:     nsrpg
// sram nom vt:   nsr           psr
// sram lp:       nsrlp         psrlp
// gnac:          ngatednac
// hvgnac:        hvngatednac
// cap:           mncap         mpcap
//
//      all_ngate                 = nactive and gate
//      all_pgate                 = pactive and gate
//      cap_ngate(mncap)          = all_ngate and drACTCAP_ID
//      cap_pgate(mpcap)          = all_pgate and drACTCAP_ID
//      gnac_ngate(ngatednac)     = all_ngate and drGATED_NACID
//      hvgnac_ngate(hvngatednac) = all_ngate and hv_gnac_id
//      mos_ngate                 = all_ngate not (drACTCAP_ID or drGATED_NACID 
//                                      or hv_gnac_id or VDMOSID)
//      mos_pgate                 = all_pgate not (drACTCAP_ID)
//      mos_ngate_a(nuva)          = mos_ngate and NAL
//      mos_pgate_a(puva)          = mos_pgate and PAL
//      mos_ngate_av1(naluv1)     = mos_ngate_a and _NV1
//      mos_pgate_av1(paluv1)     = mos_pgate_a and _PV1
//      mos_ngate_av2(naluv2)     = mos_ngate_a and _NV2
//      mos_pgate_av2(paluv2)     = mos_pgate_a and _PV2
//      mos_ngate_av3(naluv3)     = mos_ngate_a and _NV3
//      mos_pgate_av3(paluv3)     = mos_pgate_a and _PV3
//      mos_ngate_alp(nallp)      = mos_ngate_a and XGOXID
//      mos_pgate_alp(pallp)      = mos_pgate_a and XGOXID
//      mos_ngate_v0(nuv0)        = mos_ngate and _NV0
//      mos_pgate_v0(puv0)        = mos_pgate and _PV0
//      mos_ngate_v1(nuv1)        = mos_ngate and _NV1
//      mos_pgate_v1(puv1)        = mos_pgate and _PV1
//      mos_ngate_v2(nuv2)        = mos_ngate and _NV2
//      mos_pgate_v2(puv2)        = mos_pgate and _PV2
//      mos_ngate_v3(nuv3)        = mos_ngate and _NV3
//      mos_pgate_v3(puv3)        = mos_pgate and _PV3
//      mos_ngate_ulv1(nulv)      = mos_ngate and NU1
//      mos_pgate_ulv1(pulv)      = mos_pgate and PU1
//      mos_ngate_v1lp(nuv1lp)    = mos_ngate_v1 and XGOXID
//      mos_pgate_v1lp(puv1lp)    = mos_pgate_v1 and XGOXID
//      mos_ngate_v2lp(nuv2lp)    = mos_ngate_v2 and XGOXID
//      mos_pgate_v2lp(puv2lp)    = mos_pgate_v2 and XGOXID
//      mos_ngate_uvt(nuvt)       = mos_ngate and LLNMG
//      mos_pgate_uvt(puvt)       = mos_pgate and LLPMG
//      mos_ngate_shvt(nsrhvt)    = mos_ngate and POLYOD  (base sram n-device)
//      mos_ngate_spg(nsrpg)      = mos_ngate_shvt and LLNMG
//      mos_ngate_s(nsr)          = mos_ngate_shvt and SVNTG
//      mos_pgate_s(psr)          = mos_pgate and POLYOD
//      mos_ngate_slp(nsrlp)      = mos_ngate_shvt and XGOXID
//      mos_pgate_slp(psrlp)      = mos_pgate_s and XGOXID
//      mos_ngate_x(nxlllp)       = mos_ngate and ULPPITCHID 
//      mos_pgate_x(pxlllp)       = mos_pgate and ULPPITCHID 
//      mos_ngate_xedr(ndrxlllp)  = mos_ngate_x and FE_EDRAM_ID 
//      all_mos_gate_tg           = mos_ngate and TGPITCHID 
//      all_mos_pgate_tg          = mos_pgate and TGPITCHID 
//      mos_ngate_tg(ntg)         = all_mos_ngate_tg (width1) 
//      mos_pgate_tg(ptg)         = all_mos_pgate_tg (width1)
//      mos_ngate_tgmv(ntgmv)     = all_mos_ngate_tg (width2) 
//      mos_pgate_tgmv(ptgmv)     = all_mos_pgate_tg (width2)
//      mos_ngate_tglv(ntglv)     = all_mos_ngate_tg (width3) 
//      mos_pgate_tglv(ptglv)     = all_mos_pgate_tg (width3)
//      mos_ngate(n)              = mos_ngate not (NALMG or PALMG or POLYOD or XGOXID 
//                                      or ULPPITCHID or TGPITCHID)
//      mos_pgate(p)              = mos_pgate not (NALMG or PALMG or POLYOD or XGOXID or TGPITCHID)

#if _drENABLE_UVT == _drYES
   p_altvtid = copy(LLPMG);
   n_altvtid = copy(LLNMG);
#else
   p_altvtid = empty_layer();
   n_altvtid = empty_layer();
#endif  // end _drENABLE_UVT

// the uvt-ness of sram always active
p_altvtid_s = empty_layer(); 
n_altvtid_s = copy(SVNTG);

// extract vt from all mos
mos_ngate_uvt = mos_ngate and [dev_ext_level] n_altvtid;
mos_pgate_uvt = mos_pgate and [dev_ext_level] p_altvtid;

// remove vt from all mos
mos_ngate = mos_ngate not [dev_ext_level] n_altvtid;
mos_pgate = mos_pgate not [dev_ext_level] p_altvtid;

// extract [np]v0 from mos
mos_ngate_v0 = mos_ngate and [dev_ext_level] _NV0;
mos_pgate_v0 = mos_pgate and [dev_ext_level] _PV0;

// extract [np]v1 from mos
mos_ngate_v1 = mos_ngate and [dev_ext_level] _NV1;
mos_pgate_v1 = mos_pgate and [dev_ext_level] _PV1;

// extract [np]v2 from mos
mos_ngate_v2 = mos_ngate and [dev_ext_level] _NV2;
mos_pgate_v2 = mos_pgate and [dev_ext_level] _PV2;

// extract [np]v3 from mos
mos_ngate_v3 = mos_ngate and [dev_ext_level] _NV3;
mos_pgate_v3 = mos_pgate and [dev_ext_level] _PV3;

// extract [np]ulv1 from mos
mos_ngate_ulv1 = mos_ngate and [dev_ext_level] NU1;
mos_pgate_ulv1 = mos_pgate and [dev_ext_level] PU1;

// remove [np]v[012] [np]ulv1 from mos 
mos_ngate = mos_ngate not [dev_ext_level] (_NV0 or _NV1 or _NV2 or _NV3 or NU1);
mos_pgate = mos_pgate not [dev_ext_level] (_PV0 or _PV1 or _PV2 or _PV3 or PU1);

//extract lp devices
mos_ngate_v1lp = mos_ngate_v1 and [dev_ext_level] XGOXID;
mos_pgate_v1lp = mos_pgate_v1 and [dev_ext_level] XGOXID;
mos_ngate_v2lp = mos_ngate_v2 and [dev_ext_level] XGOXID;
mos_pgate_v2lp = mos_pgate_v2 and [dev_ext_level] XGOXID;


//remove lp from v1/v2 definition
mos_ngate_v1 = mos_ngate_v1 not [dev_ext_level] XGOXID;
mos_pgate_v1 = mos_pgate_v1 not [dev_ext_level] XGOXID;
mos_ngate_v2 = mos_ngate_v2 not [dev_ext_level] XGOXID;
mos_pgate_v2 = mos_pgate_v2 not [dev_ext_level] XGOXID;

//extract srlp
mos_ngate_slp = mos_ngate_s and [dev_ext_level] XGOXID;
mos_pgate_slp = mos_pgate_s and [dev_ext_level] XGOXID;

// remove srlp from all gate_s
mos_ngate_s = mos_ngate_s not [dev_ext_level] XGOXID;
mos_pgate_s = mos_pgate_s not [dev_ext_level] XGOXID;

// get the passgate for nsrpg */
mos_ngate_spg = mos_ngate_s and [dev_ext_level] LLNMG;
mos_ngate_s = mos_ngate_s not [dev_ext_level] LLNMG ;

// extract vt from all gate_s
mos_ngate_shvt = mos_ngate_s and [dev_ext_level] n_altvtid_s;

// remove vt from all gate_s
mos_ngate_s = mos_ngate_s not [dev_ext_level] n_altvtid_s;
mos_pgate_s = mos_pgate_s not [dev_ext_level] p_altvtid_s;

// gate-blocked 4-terminal nwell resistor extraction 
esdng_c8xlrgbnevm2k1p4_prim = copy_by_cells(all_esd_ngate, cells = { "c8xlrgbnevm2k1p4_base", "C8XLRGBNEVM2K1P4_BASE" }); 
esd_ngate = all_esd_ngate not [dev_ext_level] esdng_c8xlrgbnevm2k1p4_prim; 

esdng_c8xlrgbnevm2k1p1_prim = copy_by_cells(esd_ngate, cells = { "c8xlrgbnevm2k1p1_base", "C8XLRGBNEVM2K1P1_BASE" });
esd_ngate = esd_ngate not [dev_ext_level] esdng_c8xlrgbnevm2k1p1_prim; 

esdng_c8xlrgbnevm2k7p5_prim = copy_by_cells(esd_ngate, cells = { "c8xlrgbnevm2k7p5_base", "C8XLRGBNEVM2K7P5_BASE" });
esd_ngate = esd_ngate not [dev_ext_level] esdng_c8xlrgbnevm2k7p5_prim; 

esdng_c8xlrgbnevm2k3p5_prim = copy_by_cells(esd_ngate, cells = { "c8xlrgbnevm2k3p5_base", "C8XLRGBNEVM2K3P5_BASE" });
esd_ngate = esd_ngate not [dev_ext_level] esdng_c8xlrgbnevm2k3p5_prim; 

esdng_c8xlrgbnevm2k0p4_prim = copy_by_cells(esd_ngate, cells = { "c8xlrgbnevm2k0p4_base", "C8XLRGBNEVM2K0P4_BASE" });
esd_ngate = esd_ngate not [dev_ext_level] esdng_c8xlrgbnevm2k0p4_prim; 

esdng_c8xlesdclampres_prim = copy_by_cells(esd_ngate, cells = { "c8xmesdclampres" });
esd_ngate = esd_ngate not [dev_ext_level] esdng_c8xlesdclampres_prim; 

esdng_d8xlesdclampres_prim = copy_by_cells(esd_ngate, cells = { "d8xmesdclampres", "d8xsesdclampres" });
esd_ngate = esd_ngate not [dev_ext_level] esdng_d8xlesdclampres_prim;

esdng_d8xlesdclamptgres_prim = copy_by_cells(esd_ngate, cells = { "d8xsesdclamptgres", "d8xsesdclamprestg" });
esd_ngate = esd_ngate not [dev_ext_level] esdng_d8xlesdclamptgres_prim;

// remove all the gates from poly_nores
poly_nores = poly_nores not (
   mos_ngate or mos_pgate or 
   mos_ngate_stk or mos_pgate_stk or 
   mos_ngate_a or mos_pgate_a or 
   mos_ngate_av1 or mos_pgate_av1 or 
   mos_ngate_av2 or mos_pgate_av2 or 
   mos_ngate_av3 or mos_pgate_av3 or 
   mos_ngate_alp or mos_pgate_alp or 
   mos_ngate_v0 or mos_pgate_v0 or 
   mos_ngate_v1 or mos_pgate_v1 or 
   mos_ngate_v2 or mos_pgate_v2 or 
   mos_ngate_v3 or mos_pgate_v3 or 
   mos_ngate_ulv1 or mos_pgate_ulv1 or 
   mos_ngate_v1lp or mos_pgate_v1lp or 
   mos_ngate_v2lp or mos_pgate_v2lp or 
   mos_ngate_uvt or mos_pgate_uvt or 
   mos_ngate_shvt or mos_ngate_spg or 
   mos_ngate_s or mos_pgate_s or 
   mos_ngate_slp or mos_pgate_slp or 
   mos_ngate_x or mos_pgate_x or 
   mos_ngate_lllp or mos_pgate_lllp or 
   mos_ngate_tg or mos_pgate_tg or 
   mos_ngate_tgulv or mos_pgate_tgulv or 
   rfreq_ngate_par or rfreq_pgate_par or
   rfreq_ngate_par_a or rfreq_pgate_par_a or
   rfreq_ngate_par_av1 or rfreq_pgate_par_av1 or
   rfreq_ngate_par_av2 or rfreq_pgate_par_av2 or
   rfreq_ngate_par_alp or rfreq_pgate_par_alp or
   rfreq_ngate_par_v0 or rfreq_pgate_par_v0 or
   rfreq_ngate_par_v1 or rfreq_pgate_par_v1 or
   rfreq_ngate_par_v2 or rfreq_pgate_par_v2 or
   rfreq_ngate_par_v1lp or rfreq_pgate_par_v1lp or
   rfreq_ngate_par_v2lp or rfreq_pgate_par_v2lp or
   rfreq_ngate_par_uvt or rfreq_pgate_par_uvt or
   rfreq_ngate_par_x or rfreq_pgate_par_x or
   rfreq_ngate_par_tg or rfreq_pgate_par_tg or
   rfreq_ngate_par_tgulv or rfreq_pgate_par_tgulv or
   rfreq_ngate_stk or rfreq_pgate_stk or
   rfreq_ngate_stk_a or rfreq_pgate_stk_a or
   rfreq_ngate_stk_av1 or rfreq_pgate_stk_av1 or
   rfreq_ngate_stk_av2 or rfreq_pgate_stk_av2 or
   rfreq_ngate_stk_alp or rfreq_pgate_stk_alp or
   rfreq_ngate_stk_v0 or rfreq_pgate_stk_v0 or
   rfreq_ngate_stk_v1 or rfreq_pgate_stk_v1 or
   rfreq_ngate_stk_v2 or rfreq_pgate_stk_v2 or
   rfreq_ngate_stk_v1lp or rfreq_pgate_stk_v1lp or
   rfreq_ngate_stk_v2lp or rfreq_pgate_stk_v2lp or
   rfreq_ngate_stk_uvt or rfreq_pgate_stk_uvt or
   rfreq_ngate_stk_x or rfreq_pgate_stk_x or
   rfreq_ngate_stk_tg or rfreq_pgate_stk_tg or
   rfreq_ngate_stk_tgulv or rfreq_pgate_stk_tgulv or
   cap_ngate or cap_pgate or 
   gnac_ngate or hvgnac_ngate or 
   vdgate or esd_ngate or vsdgate or 
   esdng_c8xlrgbnevm2k1p4_prim or esdng_c8xlrgbnevm2k1p1_prim or 
   esdng_c8xlrgbnevm2k7p5_prim or esdng_c8xlrgbnevm2k3p5_prim or 
   esdng_c8xlrgbnevm2k0p4_prim or esdng_c8xlesdclampres_prim or 
   esdng_d8xlesdclampres_prim or esdng_d8xlesdclamptgres_prim 
);


// something simpler for bbox cells
bbTermPLID = POLY and [processing_mode = CELL_LEVEL] copy_by_cells(polytermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermDCID = DIFFCON and [processing_mode = CELL_LEVEL] copy_by_cells(dctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermPCID = POLYCON and [processing_mode = CELL_LEVEL] copy_by_cells(pctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM1ID = METAL1BC and [processing_mode = CELL_LEVEL] copy_by_cells(met1bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM2ID = METAL2BC and [processing_mode = CELL_LEVEL] copy_by_cells(met2bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM3ID = METAL3BC and [processing_mode = CELL_LEVEL] copy_by_cells(met3bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM4ID = METAL4BC and [processing_mode = CELL_LEVEL] copy_by_cells(met4bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM5ID = METAL5BC and [processing_mode = CELL_LEVEL] copy_by_cells(met5bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM6ID = METAL6BC and [processing_mode = CELL_LEVEL] copy_by_cells(met6bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM7ID = METAL7BC and [processing_mode = CELL_LEVEL] copy_by_cells(met7bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM8ID = METAL8BC and [processing_mode = CELL_LEVEL] copy_by_cells(met8bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM9ID = METAL9BC and [processing_mode = CELL_LEVEL] copy_by_cells(met9bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM10ID = METAL10BC and [processing_mode = CELL_LEVEL] copy_by_cells(met10bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM11ID = METAL11BC and [processing_mode = CELL_LEVEL] copy_by_cells(met11bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermM12ID = METAL12BC and [processing_mode = CELL_LEVEL] copy_by_cells(met12bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermTM1ID = TM1BC and [processing_mode = CELL_LEVEL] copy_by_cells(tm1bctermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermRDLID = RDL and [processing_mode = CELL_LEVEL] copy_by_cells(rdltermid, cells = bbTemplates, depth = CELL_LEVEL);
bbTermMCRID = MCR and [processing_mode = CELL_LEVEL] copy_by_cells(mcrtermid, cells = bbTemplates, depth = CELL_LEVEL);

#ifdef _drDEBUG
   // primary drawn layers
   drPassthruStack.push_back({CELLBOUNDARY, {50,0} });
   drPassthruStack.push_back({NDIFF, {1,0} });
   drPassthruStack.push_back({POLY, {2,0} });
   drPassthruStack.push_back({PRES_ID, {2,4} });
   drPassthruStack.push_back({POLYOD, {2,22} });
   drPassthruStack.push_back({POLYDUMMYID, {2,33} });
   drPassthruStack.push_back({ULPPITCHID, {2,43} });
   drPassthruStack.push_back({TGPITCHID, {2,44} });
   drPassthruStack.push_back({DIFFCON, {5,0} });
   drPassthruStack.push_back({DIFFCONRESID, {5,4} });
   drPassthruStack.push_back({POLYCON, {6,0} });
   drPassthruStack.push_back({POLYCONRESID, {6,4} });
   drPassthruStack.push_back({PDIFF, {8,0} });
   drPassthruStack.push_back({NWELL, {11,0} });
   drPassthruStack.push_back({DEEPNWELL, {20,0} });
   drPassthruStack.push_back({PWELL_SUBISO, {36,6} });
   drPassthruStack.push_back({PWELL_SUBISO_txt, {36,6} });
   drPassthruStack.push_back({LLPMG, {51,0} });
   drPassthruStack.push_back({LLNMG, {49,0} });
   drPassthruStack.push_back({SUBISOTEXT, {81,7} });
   drPassthruStack.push_back({SUBISOTEXT_txt, {81,7} });
   drPassthruStack.push_back({XGOXID, {81,146} });
   drPassthruStack.push_back({NV0, {117,0} });
   drPassthruStack.push_back({PV0, {116,0} });
   drPassthruStack.push_back({NV1, {94,0} });
   drPassthruStack.push_back({PV1, {97,0} });
   drPassthruStack.push_back({NV2, {98,0} });
   drPassthruStack.push_back({PV2, {97,0} });
   drPassthruStack.push_back({NV3, {103,0} });
   drPassthruStack.push_back({PV3, {102,0} });
   drPassthruStack.push_back({LLNMG, {49,0} });
   drPassthruStack.push_back({NALMG, {140,0} });
   drPassthruStack.push_back({PALMG, {141,0} });
   drPassthruStack.push_back({SVNTG, {155,18} });
   drPassthruStack.push_back({SVPTG, {156,18} });
   drPassthruStack.push_back({V1PITCHID, {2,151} });
   drPassthruStack.push_back({V2PITCHID, {2,152} });
   drPassthruStack.push_back({V3PITCHID, {2,153} });
   drPassthruStack.push_back({V3PITCHID, {2,153} });
   drPassthruStack.push_back({stackdevtyperf, {82,96} });
   drPassthruStack.push_back({RFREQDEVTYPE, {82,251} });

   // metal
   drPassthruStack.push_back({METAL0BC, {55,0}});
   drPassthruStack.push_back({METAL1BC, {4,0}});
   drPassthruStack.push_back({METAL2BC, {14,0}});
   drPassthruStack.push_back({METAL3BC, {18,0}});
   drPassthruStack.push_back({METAL4BC, {22,0}});
   drPassthruStack.push_back({METAL5BC, {26,0}});
   drPassthruStack.push_back({METAL6BC, {30,0}});
   drPassthruStack.push_back({METAL7BC, {34,0}});
   drPassthruStack.push_back({METAL8BC, {38,0}}); 
   drPassthruStack.push_back({METAL9BC, {46,0}}); 
   drPassthruStack.push_back({METAL10BC, {54,0}}); 
   drPassthruStack.push_back({METAL11BC, {58,0}}); 
   drPassthruStack.push_back({TM1BC,     {42,0}}); 
   drPassthruStack.push_back({RDL,     {217,0}}); 
   drPassthruStack.push_back({MCR, {70,0}});
   // met resid
   drPassthruStack.push_back({MET0BCRESID, {55,4}});
   drPassthruStack.push_back({MET1BCRESID, {4,4}});
   drPassthruStack.push_back({MET2BCRESID, {14,4}});
   drPassthruStack.push_back({MET3BCRESID, {18,4}});
   drPassthruStack.push_back({MET4BCRESID, {22,4}});
   drPassthruStack.push_back({MET5BCRESID, {26,4}});
   drPassthruStack.push_back({MET6BCRESID, {30,4}});
   drPassthruStack.push_back({MET7BCRESID, {34,4}});
   drPassthruStack.push_back({MET8BCRESID, {38,4}}); 
   drPassthruStack.push_back({MET9BCRESID, {46,4}}); 
   drPassthruStack.push_back({MET10BCRESID, {54,4}}); 
   drPassthruStack.push_back({MET11BCRESID, {58,4}}); 
   drPassthruStack.push_back({MET12BCRESID, {62,4}}); 
   drPassthruStack.push_back({TM1BCRESID, {42,4}}); 
   drPassthruStack.push_back({RDLRESID, {217,4}}); 
   // met pin/ports
   drPassthruStack.push_back({met0bcpin, {55,2}});
   drPassthruStack.push_back({met1bcpin, {4,2}});
   drPassthruStack.push_back({met2bcpin, {14,2}});
   drPassthruStack.push_back({met3bcpin, {18,2}});
   drPassthruStack.push_back({met4bcpin, {22,2}});
   drPassthruStack.push_back({met5bcpin, {26,2}});
   drPassthruStack.push_back({met6bcpin, {30,2}});
   drPassthruStack.push_back({met7bcpin, {34,2}});
   drPassthruStack.push_back({met8bcpin, {38,2}}); 
   drPassthruStack.push_back({met9bcpin, {46,2}}); 
   drPassthruStack.push_back({met10bcpin, {54,2}}); 
   drPassthruStack.push_back({met11bcpin, {58,2}}); 
   drPassthruStack.push_back({met12bcpin, {62,2}}); 
   drPassthruStack.push_back({tm1bcpin, {42,2}}); 
   drPassthruStack.push_back({rdlpin, {217,2}}); 
   // termid
   drPassthruStack.push_back({polytermid, {2,1110}});
   drPassthruStack.push_back({dctermid, {5,1110}});
   drPassthruStack.push_back({pctermid, {6,1110}});
   drPassthruStack.push_back({met0bctermid, {55,1110}});
   drPassthruStack.push_back({met1bctermid, {4,1110}});
   drPassthruStack.push_back({met2bctermid, {14,1110}});
   drPassthruStack.push_back({met3bctermid, {18,1110}});
   drPassthruStack.push_back({met4bctermid, {22,1110}});
   drPassthruStack.push_back({met5bctermid, {26,1110}});
   drPassthruStack.push_back({met6bctermid, {30,1110}});
   drPassthruStack.push_back({met7bctermid, {34,1110}});
   drPassthruStack.push_back({met8bctermid, {38,1110}}); 
   drPassthruStack.push_back({met9bctermid, {46,1110}}); 
   drPassthruStack.push_back({met10bctermid, {54,1110}}); 
   drPassthruStack.push_back({met11bctermid, {58,1110}}); 
   drPassthruStack.push_back({met12bctermid, {62,1110}}); 
   drPassthruStack.push_back({tm1bctermid, {42,1110}}); 
   drPassthruStack.push_back({rdltermid, {217,1110}}); 

   // text
   drPassthruStack.push_back({NWELL_txt, {11,0}});
   drPassthruStack.push_back({NWELLESD_txt, {19,0}});
   drPassthruStack.push_back({NDIFF_txt, {1,0}});
   drPassthruStack.push_back({PDIFF_txt, {8,0}});
   drPassthruStack.push_back({POLY_txt, {2,0}});
   drPassthruStack.push_back({POLYCON_txt, {6,0}});
   drPassthruStack.push_back({DIFFCON_txt, {5,0}});
   drPassthruStack.push_back({METAL0BC_txt, {55,0}});
   drPassthruStack.push_back({METAL1BC_txt, {4,0}});
   drPassthruStack.push_back({METAL2BC_txt, {14,0}});
   drPassthruStack.push_back({METAL3BC_txt, {18,0}});
   drPassthruStack.push_back({METAL4BC_txt, {22,0}});
   drPassthruStack.push_back({METAL5BC_txt, {26,0}});
   drPassthruStack.push_back({METAL6BC_txt, {30,0}});
   drPassthruStack.push_back({METAL7BC_txt, {34,0}});
   drPassthruStack.push_back({METAL8BC_txt, {38,0}}); 
   drPassthruStack.push_back({METAL9BC_txt, {46,0}}); 
   drPassthruStack.push_back({METAL10BC_txt, {54,0}}); 
   drPassthruStack.push_back({METAL11BC_txt, {58,0}}); 
   drPassthruStack.push_back({TM1BC_txt, {42,0}}); 
   drPassthruStack.push_back({RDL_txt, {217,0}}); 
   drPassthruStack.push_back({MCR_txt, {70,0}});
   // via layer
   drPassthruStack.push_back({VIA0, {56,0}});
   drPassthruStack.push_back({VIACON, {3,0}});
   drPassthruStack.push_back({VIA1, {13,0}});
   drPassthruStack.push_back({VIA2, {17,0}});
   drPassthruStack.push_back({VIA3, {21,0}});
   drPassthruStack.push_back({VIA4, {25,0}});
   drPassthruStack.push_back({VIA5, {29,0}});
   drPassthruStack.push_back({VIA6, {33,0}});
   drPassthruStack.push_back({VIA7, {37,0}});
   drPassthruStack.push_back({VIA8, {41,0}});
   drPassthruStack.push_back({VIA9, {45,0}});
   drPassthruStack.push_back({VIA10, {53,0}});
   drPassthruStack.push_back({VIA11, {57,0}});
   drPassthruStack.push_back({TV1, {80,10}});
   drPassthruStack.push_back({CE3, {77,0}});
   drPassthruStack.push_back({CE2, {90,0}});
   drPassthruStack.push_back({CE2HOLE, {90,61}});
   drPassthruStack.push_back({CE1, {91,0}});
   drPassthruStack.push_back({CE1HOLE, {91,61}});
   drPassthruStack.push_back({VCR, {65,0}});
   drPassthruStack.push_back({MTJ, {186,0}});

   // annotation
   drPassthruStack.push_back({M8PGDUMMYID,{250,33}});
   drPassthruStack.push_back({M8PGDUMMYID_txt,{250,33}});
   drPassthruStack.push_back({M9PGDUMMYID,{251,33}});
   drPassthruStack.push_back({M9PGDUMMYID_txt,{251,33}});
   drPassthruStack.push_back({M10PGDUMMYID,{252,33}});
   drPassthruStack.push_back({M10PGDUMMYID_txt,{252,33}});
   drPassthruStack.push_back({M11PGDUMMYID,{253,33}});
   drPassthruStack.push_back({M11PGDUMMYID_txt,{253,33}});

   // extracted ngates
   drPassthruStack.push_back({mos_ngate, {301,100} });  // n
   drPassthruStack.push_back({mos_pgate, {308,100} }); // p

   drPassthruStack.push_back({mos_ngate_stk, {301,132} });  // nstk
   drPassthruStack.push_back({mos_pgate_stk, {308,132} }); // pstk

   drPassthruStack.push_back({mos_ngate_a, {301,101} }); // nuva - used to be nal
   drPassthruStack.push_back({mos_pgate_a, {308,101} }); // puva - used to be pal

   drPassthruStack.push_back({mos_ngate_av1, {301,102} }); // naluv1
   drPassthruStack.push_back({mos_pgate_av1, {308,102} }); // paluv1

   drPassthruStack.push_back({mos_ngate_av2, {301,103} }); // naluv2
   drPassthruStack.push_back({mos_pgate_av2, {308,103} }); // paluv2

   drPassthruStack.push_back({mos_ngate_alp, {301,104} }); // nallp
   drPassthruStack.push_back({mos_pgate_alp, {308,104} }); // pallp

   drPassthruStack.push_back({mos_ngate_v0, {301,116} }); // nuv0
   drPassthruStack.push_back({mos_pgate_v0, {308,116} }); // puv0

   drPassthruStack.push_back({mos_ngate_v1, {301,105} }); // nuv1
   drPassthruStack.push_back({mos_pgate_v1, {308,105} }); // puv1
   
   drPassthruStack.push_back({mos_ngate_v2, {301,106} }); // nuv2
   drPassthruStack.push_back({mos_pgate_v2, {308,106} }); // puv2

   drPassthruStack.push_back({mos_ngate_v1lp, {301,107} }); // nuv1lp
   drPassthruStack.push_back({mos_pgate_v1lp, {308,107} }); // puv1lp

   drPassthruStack.push_back({mos_ngate_v2lp, {301,108} }); // nuv2lp
   drPassthruStack.push_back({mos_pgate_v2lp, {308,108} }); // puv2lp

   drPassthruStack.push_back({mos_ngate_uvt, {301,109} }); // nuvt
   drPassthruStack.push_back({mos_pgate_uvt, {308,109} }); // puvt

   drPassthruStack.push_back({mos_ngate_shvt, {301,110} }); // nsrhvt

   drPassthruStack.push_back({mos_ngate_spg, {301,111} }); // nsrpg

   drPassthruStack.push_back({mos_ngate_s, {301,112} }); // nsr
   drPassthruStack.push_back({mos_pgate_s, {308,112} }); // psr

   drPassthruStack.push_back({mos_ngate_slp, {301,113} }); // nsrlp
   drPassthruStack.push_back({mos_pgate_slp, {308,113} }); // psrlp

   drPassthruStack.push_back({mos_ngate_x, {301,114} }); // nxlllp
   drPassthruStack.push_back({mos_pgate_x, {308,114} }); // pxlllp

   drPassthruStack.push_back({mos_ngate_tg, {301,115} }); // ntg
   drPassthruStack.push_back({mos_pgate_tg, {308,115} }); // ptg

   drPassthruStack.push_back({mos_ngate_ulv1, {301,117} }); // nulv
   drPassthruStack.push_back({mos_pgate_ulv1, {308,117} }); // pulv

   // extracted rfreq
   drPassthruStack.push_back({rfreq_ngate_par, {301,200} });  // n
   drPassthruStack.push_back({rfreq_pgate_par, {308,200} }); // p

   drPassthruStack.push_back({rfreq_ngate_par_a, {301,201} }); // nuva - used to be nal
   drPassthruStack.push_back({rfreq_pgate_par_a, {308,201} }); // puva - used to be pal

   drPassthruStack.push_back({rfreq_ngate_par_av1, {301,202} }); // naluv1
   drPassthruStack.push_back({rfreq_pgate_par_av1, {308,202} }); // paluv1

   drPassthruStack.push_back({rfreq_ngate_par_av2, {301,203} }); // naluv2
   drPassthruStack.push_back({rfreq_pgate_par_av2, {308,203} }); // paluv2

   drPassthruStack.push_back({rfreq_ngate_par_alp, {301,204} }); // nallp
   drPassthruStack.push_back({rfreq_pgate_par_alp, {308,204} }); // pallp

   drPassthruStack.push_back({rfreq_ngate_par_v0, {301,216} }); // nuv0
   drPassthruStack.push_back({rfreq_pgate_par_v0, {308,216} }); // puv0

   drPassthruStack.push_back({rfreq_ngate_par_v1, {301,205} }); // nuv1
   drPassthruStack.push_back({rfreq_pgate_par_v1, {308,205} }); // puv1

   drPassthruStack.push_back({rfreq_ngate_par_v2, {301,206} }); // nuv2
   drPassthruStack.push_back({rfreq_pgate_par_v2, {308,206} }); // puv2

   drPassthruStack.push_back({rfreq_ngate_par_v1lp, {301,207} }); // nuv1lp
   drPassthruStack.push_back({rfreq_pgate_par_v1lp, {308,207} }); // puv1lp

   drPassthruStack.push_back({rfreq_ngate_par_v2lp, {301,208} }); // nuv2lp
   drPassthruStack.push_back({rfreq_pgate_par_v2lp, {308,208} }); // puv2lp

   drPassthruStack.push_back({rfreq_ngate_par_uvt, {301,209} }); // nuvt
   drPassthruStack.push_back({rfreq_pgate_par_uvt, {308,209} }); // puvt

   drPassthruStack.push_back({rfreq_ngate_par_x, {301,214} }); // nxlllp
   drPassthruStack.push_back({rfreq_pgate_par_x, {308,214} }); // pxlllp

   drPassthruStack.push_back({rfreq_ngate_par_tg, {301,215} }); // ntg
   drPassthruStack.push_back({rfreq_pgate_par_tg, {308,215} }); // ptg

   drPassthruStack.push_back({rfreq_ngate_par_tgulv, {301,217} }); // ntglv
   drPassthruStack.push_back({rfreq_pgate_par_tgulv, {308,217} }); // ptglv

   drPassthruStack.push_back({rfreq_ngate_stk, {301,300} });  // n
   drPassthruStack.push_back({rfreq_pgate_stk, {308,300} }); // p

   drPassthruStack.push_back({rfreq_ngate_stk_a, {301,301} }); // nuva - used to be nal
   drPassthruStack.push_back({rfreq_pgate_stk_a, {308,301} }); // puva - used to be pal

   drPassthruStack.push_back({rfreq_ngate_stk_av1, {301,302} }); // naluv1
   drPassthruStack.push_back({rfreq_pgate_stk_av1, {308,302} }); // paluv1

   drPassthruStack.push_back({rfreq_ngate_stk_av2, {301,303} }); // naluv2
   drPassthruStack.push_back({rfreq_pgate_stk_av2, {308,303} }); // paluv2

   drPassthruStack.push_back({rfreq_ngate_stk_alp, {301,304} }); // nallp
   drPassthruStack.push_back({rfreq_pgate_stk_alp, {308,304} }); // pallp

   drPassthruStack.push_back({rfreq_ngate_stk_v0, {301,316} }); // nuv0
   drPassthruStack.push_back({rfreq_pgate_stk_v0, {308,316} }); // puv0

   drPassthruStack.push_back({rfreq_ngate_stk_v1, {301,305} }); // nuv1
   drPassthruStack.push_back({rfreq_pgate_stk_v1, {308,305} }); // puv1

   drPassthruStack.push_back({rfreq_ngate_stk_v2, {301,306} }); // nuv2
   drPassthruStack.push_back({rfreq_pgate_stk_v2, {308,306} }); // puv2

   drPassthruStack.push_back({rfreq_ngate_stk_v1lp, {301,307} }); // nuv1lp
   drPassthruStack.push_back({rfreq_pgate_stk_v1lp, {308,307} }); // puv1lp

   drPassthruStack.push_back({rfreq_ngate_stk_v2lp, {301,308} }); // nuv2lp
   drPassthruStack.push_back({rfreq_pgate_stk_v2lp, {308,308} }); // puv2lp

   drPassthruStack.push_back({rfreq_ngate_stk_uvt, {301,309} }); // nuvt
   drPassthruStack.push_back({rfreq_pgate_stk_uvt, {308,309} }); // puvt

   drPassthruStack.push_back({rfreq_ngate_stk_x, {301,314} }); // nxlllp
   drPassthruStack.push_back({rfreq_pgate_stk_x, {308,314} }); // pxlllp

   drPassthruStack.push_back({rfreq_ngate_stk_tg, {301,315} }); // ntg
   drPassthruStack.push_back({rfreq_pgate_stk_tg, {308,315} }); // ptg

   drPassthruStack.push_back({rfreq_ngate_stk_tgulv, {301,317} }); // ntglv
   drPassthruStack.push_back({rfreq_pgate_stk_tgulv, {308,317} }); // ptglv

//   drPassthruStack.push_back({mos_ngate_tgmv, {301,131} }); // ntgmv
//   drPassthruStack.push_back({mos_pgate_tgmv, {308,131} }); // ptgmv

//   drPassthruStack.push_back({mos_ngate_tglv, {301,117} }); // ntglv
//   drPassthruStack.push_back({mos_pgate_tglv, {308,117} }); // ptglv

   drPassthruStack.push_back({cap_ngate, {301,118} }); // ncap
   drPassthruStack.push_back({cap_pgate, {308,118} }); // pcap

   drPassthruStack.push_back({gnac_ngate, {301,119} }); // ngatednac

   drPassthruStack.push_back({hvgnac_ngate, {301,120} }); // hvngatednac

   drPassthruStack.push_back({all_ngate, {301,121} }); // all ngates
   drPassthruStack.push_back({all_pgate, {308,121} }); // all ngates

   drPassthruStack.push_back({ngateZL, {301,122} }); // the ngate used for ZL extraction
   drPassthruStack.push_back({pgateZL, {308,122} }); // the ngate used for ZL extraction

   // gbnwell gates
   drPassthruStack.push_back({esdng_c8xlrgbnevm2k1p4_prim, {301,123} });
   drPassthruStack.push_back({esdng_c8xlrgbnevm2k1p1_prim, {301,124} });
   drPassthruStack.push_back({esdng_c8xlrgbnevm2k7p5_prim, {301,125} });
   drPassthruStack.push_back({esdng_c8xlrgbnevm2k3p5_prim, {301,126} });
   drPassthruStack.push_back({esdng_c8xlrgbnevm2k0p4_prim, {301,127} });
   drPassthruStack.push_back({esdng_c8xlesdclampres_prim, {301,128} });
   drPassthruStack.push_back({esdng_d8xlesdclamptgres_prim, {301,129} });
   drPassthruStack.push_back({esd_ngate, {301,130} });

   drPassthruStack.push_back({p_dummy_gate_fbd, {308,150} }); 
   drPassthruStack.push_back({dr_gcn_ignore_poly, {302,3} }); // rgcn dummy poly to ignore 
   drPassthruStack.push_back({all_dummy_gate_fbd, {302,4} }); // dummy gates 
   drPassthruStack.push_back({dr_poly_diff_enc_COMMON, {302,5} }); // pullback fill
   drPassthruStack.push_back({POLY_ext, {302,6} }); // poly + the pullback fill 
 //  drPassthruStack.push_back({all_dummy_A, {302,7} }); // dummy gates analog
   drPassthruStack.push_back({all_dummy, {302,8} }); // dummy gates digital
 //  drPassthruStack.push_back({gate_w_gcn_A, {302,9} }); // dummy gates analog
 //  drPassthruStack.push_back({gate_dummyid_A, {302,10} }); // dummy gates analog
 //  drPassthruStack.push_back({nonrect_gate_A, {302,11} }); // dummy gates analog
 //  drPassthruStack.push_back({half_gate_A, {302,12} }); // dummy gates analog
   drPassthruStack.push_back({gate_w_gcn, {302,13} }); // dummy gates digital
   drPassthruStack.push_back({gate_dummyid, {302,14} }); // dummy gates digital
   drPassthruStack.push_back({nonrect_gate, {302,15} }); // dummy gates digital
   drPassthruStack.push_back({half_gate, {302,16} }); // dummy gates digital
   drPassthruStack.push_back({dummy_diode_gate, {302,17} }); // dummy gates digital
   drPassthruStack.push_back({save_gate, {302,18} }); // source of all active gates

#endif  // end _drDEBUG

// gcn resistor 
polycon_res_cl = POLYCON and [processing_mode = CELL_LEVEL ] POLYCONRESID;
polycon_nores = POLYCON not POLYCONRESID;

// tcn resistor 
diffcon_res_cl = DIFFCON and [processing_mode = CELL_LEVEL ] DIFFCONRESID;
diffcon_nores = DIFFCON not DIFFCONRESID;

// this should create opens if not drawn correctly 
// for inductors their will be a m8/m7 nores running over body of inductor 
// but should be connected to one of the inductor terms
metal0res_cl = METAL0BC and [processing_mode = CELL_LEVEL ] MET0BCRESID;
metal0nores = METAL0BC not MET0BCRESID;

metal1res_cl = METAL1BC and [processing_mode = CELL_LEVEL ] MET1BCRESID;
metal1nores = METAL1BC not MET1BCRESID;

metal2res_cl = METAL2BC and [processing_mode = CELL_LEVEL ] MET2BCRESID;
metal2nores = METAL2BC not MET2BCRESID;

metal3res_cl = METAL3BC and [processing_mode = CELL_LEVEL ] MET3BCRESID;
metal3nores = METAL3BC not MET3BCRESID;

metal4res_cl = METAL4BC and [processing_mode = CELL_LEVEL ] MET4BCRESID;
metal4nores = METAL4BC not MET4BCRESID;

metal5res_cl = METAL5BC and [processing_mode = CELL_LEVEL ] MET5BCRESID;
metal5nores = METAL5BC not MET5BCRESID;

metal6res_cl = METAL6BC and [processing_mode = CELL_LEVEL ] MET6BCRESID;
metal6nores = METAL6BC not MET6BCRESID;

metal7res_cl = METAL7BC and [processing_mode = CELL_LEVEL ] MET7BCRESID;
metal7nores = METAL7BC not MET7BCRESID;

metal8res_cl = METAL8BC and [processing_mode = CELL_LEVEL ] MET8BCRESID;
metal8nores = METAL8BC not MET8BCRESID;

metal9res_cl = METAL9BC and [processing_mode = CELL_LEVEL ] MET9BCRESID;
metal9nores = METAL9BC not MET9BCRESID;

metal10res_cl = METAL10BC and [processing_mode = CELL_LEVEL ] MET10BCRESID;
metal10nores = METAL10BC not MET10BCRESID;

metal11res_cl = METAL11BC and [processing_mode = CELL_LEVEL ] MET11BCRESID;
metal11nores = METAL11BC not MET11BCRESID;

metal12res_cl = METAL12BC and [processing_mode = CELL_LEVEL ] MET12BCRESID;
metal12nores = METAL12BC not MET12BCRESID;

tm1res_cl = TM1BC and [processing_mode = CELL_LEVEL ] TM1BCRESID;
tm1nores = TM1BC not TM1BCRESID;

rdlres_cl = RDL and [processing_mode = CELL_LEVEL ] RDLRESID;
rdlnores = RDL not RDLRESID;

mcrres_cl = MCR and [processing_mode = CELL_LEVEL ] MCRRESID;
mcrnores = MCR not MCRRESID;

// include the metal via switch derivations
#include <1273/p1273dx_Tcommon_mvsw.rs>


// djp/djn diode layers
esdresistor = NWELLESD cutting  [ processing_mode = CELL_LEVEL ] WELLRES_ID ;
int_diode_err = psd and esdresistor;
anode_nbjt = anode not bjt_cell;
anode_nbjt_esd = copy_by_cells(anode_nbjt, djx_esdCells, depth = CELL_LEVEL);
anode_nbjt = anode_nbjt not anode_nbjt_esd;

// layer for rcextract
active = nactive or pactive;

// include the scaleable mfc  derivations
#include <1273/p1273dx_Tcommon_sclmfc.rs>

#ifdef _drDEBUG
   // output routing info
   drPassthruStack.push_back({nsd, {301,0} });  
   drPassthruStack.push_back({npickup, {301,1} });  
   drPassthruStack.push_back({poly_nores, {302,0} });  
   drPassthruStack.push_back({dr_gcn_ignore_poly, {302,3} });  
   drPassthruStack.push_back({polycon_nores, {306,0} });  
   drPassthruStack.push_back({diffcon_nores, {305,0} });  
   drPassthruStack.push_back({psd, {308,0} });  
   drPassthruStack.push_back({ppickup, {308,1} });  
   drPassthruStack.push_back({pwelltap, {308,2} });  
   drPassthruStack.push_back({rdlnores,    {517,0} });  
   drPassthruStack.push_back({mcrnores,    {370,0} });  
   drPassthruStack.push_back({C4BEMIB, {392,0} });  

   // misc device layers
   drPassthruStack.push_back({anode_nbjt, {308,320} });  
   drPassthruStack.push_back({cathode, {308,321} });  
   drPassthruStack.push_back({nac_anode, {301,320} });  
   drPassthruStack.push_back({nac_cathode, {301,321} });  
   drPassthruStack.push_back({bjt_coll, {308,322} });  
   drPassthruStack.push_back({bjt_base, {308,323} });  
   drPassthruStack.push_back({bjt_emit, {308,324} });  
   drPassthruStack.push_back({dnpdnw_anode, {320,320} });  
   drPassthruStack.push_back({dpndnw_cathode, {320,321} });  

   drPassthruStack.push_back({pwell, {320,0} });  
   drPassthruStack.push_back({virpwell_marker, {320,2} });  
   drPassthruStack.push_back({pwellPhysical, {320,3} });  
   drPassthruStack.push_back({__drsubstrate, {320,1} });  
   
#endif  // end _drDEBUG


#if (! defined(_drICFDEVICES))
   // initialize to empty for non ICF products
   ind_tm1_id = empty_layer();
   ind_tm1_term = empty_layer();
   ind_tm1_sp_w = empty_layer();
   ind_tm1_coin_edge = empty_layer();
   ind_tm1_nTurns = empty_layer();
   ind_tm1_inner_x = empty_layer();
   ind_tm1_inner_y = empty_layer();

   ind_m12_id = empty_layer();
   ind_m12_term = empty_layer();
   ind_m12_sp_w = empty_layer();
   ind_m12_coin_edge = empty_layer();
   ind_m12_nTurns = empty_layer();
   ind_m12_inner_x = empty_layer();
   ind_m12_inner_y = empty_layer();

   // ********** ICF MIMCAP *************************
   SCL_MIM_ID2_metal = empty_layer();
   SCL_MIM_ID3_metal = empty_layer();
   mim_scl_top_plate = empty_layer();
   mim_scl_bottem_plate = empty_layer();
   mim_scl_top_plate_hole1 = empty_layer();
   mim_scl_bottem_plate_hole1 = empty_layer();
   mim_scl_hole1 = empty_layer();
   stacked_mim = empty_layer();
   mim_scl_hole = empty_layer();
   mim_scl_body = empty_layer();
   mim_scl_body_stacked = empty_layer();
   mim_scl_body_p = empty_layer();
   mim_scl_top_plate_for_Z = empty_layer();
   mim_scl_top_plate_for_L1_and_L2 = empty_layer();
   mim_scl_top_plate_LH = empty_layer();
   mim_scl_top_plate_LH_01 = empty_layer();
   poly_devtermID1_LH = empty_layer();
   poly_devtermID1_LH_coin_edge_ID2 = empty_layer();
   mim_scl_body_and_L1 = empty_layer();
   mim_scl_body_and_L1_touch_edge_poly_devtermID4 = empty_layer();
   mim_scl_body_and_L3 = empty_layer();
   mim_scl_body_and_L3_touch_edge_poly_devtermID4 = empty_layer();
  // ***************** END OF ICF MIMCAP ******************

#else
   // ***************** ICF INDUCTOR ****************** 

   //************ ICF TM1INDUCTOR **************************
   // Pick inductor body layer and tm1 core
   ind_tm1_id :polygon_layer = texted_with(layer1 = TM1IND, layer2 = TM1IND_txt, text = {"Inductor2Scl_TM1"});
   ind_tm1_core = tm1nores and ind_tm1_id;

   // Layers needed to process the device parameters
   ind_tm1_props = ind_tm1_id and INDUCTORPROPS;
   ind_tm1_id_inside = inside(layer1 = ind_tm1_props, layer2 = ind_tm1_core, processing_mode = CELL_LEVEL);
   ind_tm1_coin_edge = edge_size(coincident_edge(layer1 = ind_tm1_id_inside, layer2 = ind_tm1_id, processing_mode = CELL_LEVEL), inside=0.001);
   ind_tm1_sp_w = interacting(layer1 = ind_tm1_id_inside, layer2 = ind_tm1_coin_edge, processing_mode = CELL_LEVEL);
   
   ind_tm1_resid = ind_tm1_id_inside not ind_tm1_sp_w;
   tm1nores = tm1nores not ind_tm1_resid;
   ind_tm1_term = tm1nores and tm1pin;
	
   ind_tm1_id_outside = outside(layer1 = ind_tm1_props, layer2 = ind_tm1_core);
   ind_tm1_inner_y = rectangles(layer1 = ind_tm1_id_outside);
   ind_tm1_nTurns = not_rectangles(layer1 = ind_tm1_id_outside);
   ind_tm1_inner_x = ind_tm1_props not ind_tm1_id_inside not ind_tm1_id_outside;

   //************ ICF M12INDUCTOR **************************
  ind_m12_id:polygon_layer = texted_with(layer1 = METAL12IND, layer2 = METAL12IND_txt, text = {"Inductor2Scl_M12"});
  ind_m12_core = metal12nores and ind_m12_id;
  
  ind_m12_props = ind_m12_id and INDUCTORPROPS;
  ind_m12_coin_edge = edge_size(coincident_edge(layer1 = ind_m12_props, layer2 = ind_m12_id, processing_mode = CELL_LEVEL), inside=0.001);
  ind_m12_sp_w = interacting(layer1 = ind_m12_props, layer2 = ind_m12_coin_edge, processing_mode = CELL_LEVEL);
 
  ind_m12_resid = inside(layer1 = ind_m12_props, layer2 = ind_m12_core, processing_mode = CELL_LEVEL);
  metal12nores = metal12nores not ind_m12_resid;
  metal11nores = metal11nores not ind_m12_resid;
  ind_m12_term = metal12nores and met12pin;

  ind_m12_id_outside = outside(layer1 = ind_m12_props, layer2 = ind_m12_core);
  ind_m12_inner_y = rectangles(layer1 = ind_m12_id_outside);
  ind_m12_nTurns = not_rectangles(layer1 = ind_m12_id_outside);
  ind_m12_inner_x = ind_m12_props not (ind_m12_resid or ind_m12_sp_w or ind_m12_inner_y or ind_m12_nTurns); 
   // ***************** END OF ICF INDUCTOR ******************
   // ********** ICF MIMCAP *************************
   // generate scaleable mimcap layers
   // Adding MIMCAP device layers and its booleans
   // This will defferenciate ID1 + ID2 + ID3 layer used in non-stacked mim cap
   
     SCL_MIM_ID2_metal = SCL_MIM_ID2 interacting (TM1DRAWN and SCL_MIM_ID1);
     SCL_MIM_ID3_metal = SCL_MIM_ID3 interacting (TM1DRAWN and SCL_MIM_ID1);
   
   
     mim_scl_top_plate = CE2DRAWN and SCL_MIM_ID1 ;
     mim_scl_bottem_plate = CE1DRAWN and SCL_MIM_ID1 ;
   
     // There is other function also to get the hole use of not is faster 
     mim_scl_top_plate_hole1 = mim_scl_top_plate not mim_scl_bottem_plate;
     mim_scl_bottem_plate_hole1 = mim_scl_bottem_plate not mim_scl_top_plate;
     mim_scl_hole1 = mim_scl_top_plate_hole1 or mim_scl_bottem_plate_hole1 ;
   
     // Non stacked Mim Interacting with ID1 + ID2 + ID3 will create Stacked mim
     stacked_mim = (SCL_MIM_ID1 and SCL_MIM_ID2) and SCL_MIM_ID3;
   
     // Making sure to pick only hole
     mim_scl_hole = mim_scl_hole1 not_interacting stacked_mim;
   
     // Defining body of stacked_mim and non-stacked_mim 
     mim_scl_body = (mim_scl_top_plate and mim_scl_bottem_plate) not_interacting stacked_mim;
     mim_scl_body_stacked = mim_scl_top_plate interacting stacked_mim;
   
     // defiend mim_scl_body_p for parameter calculation.
   
     mim_scl_body_p = ((SCL_MIM_ID1 interacting (mim_scl_body or mim_scl_body_stacked)) not SCL_MIM_ID2_metal) not SCL_MIM_ID3_metal;
   
     /************Calculation of LH , NH and W parameter **************************************/
   
   
     mim_scl_top_plate_for_Z = SCL_MIM_ID1 not SCL_MIM_ID2_metal ;
     mim_scl_top_plate_for_L1_and_L2 = (mim_scl_top_plate not SCL_MIM_ID2_metal) not SCL_MIM_ID3_metal;
   
     //mim_scl_top_plate_LH = poly_devtermID4 and poly_devtermID1;
     mim_scl_top_plate_LH = copy(mim_scl_top_plate_hole1);
     mim_scl_top_plate_LH_01 = edge_size((touching_edge (mim_scl_top_plate_LH,SCL_MIM_ID2_metal)),inside = 0.1);
     poly_devtermID1_LH = SCL_MIM_ID1 not (CE2DRAWN interacting SCL_MIM_ID1);
     poly_devtermID1_LH_coin_edge_ID2 = poly_devtermID1_LH and (edge_size(touching_edge(SCL_MIM_ID2_metal,poly_devtermID1_LH), outside = 0.0001));
   
   // Layers below will be used to calculate L1 , L2 and L3 parameter.
   
     mim_scl_body_and_L1 = SCL_MIM_ID2_metal interacting (mim_scl_body or mim_scl_body_stacked) ;
     mim_scl_body_and_L1_touch_edge_poly_devtermID4 = edge_size((touching_edge (mim_scl_body_and_L1,mim_scl_hole)),inside = 0.1);
   
     mim_scl_body_and_L3 = SCL_MIM_ID3_metal interacting (mim_scl_body or mim_scl_body_stacked) ;
     mim_scl_body_and_L3_touch_edge_poly_devtermID4 = edge_size((touching_edge (mim_scl_body_and_L3,mim_scl_hole)),inside = 0.1);
   
   // ***************** END OF ICF MIMCAP ******************

   #ifdef _drDEBUG
      drPassthruStack.push_back({ind_m12_id, {999,1} });
      drPassthruStack.push_back({ind_m12_core, {999,2} });
      drPassthruStack.push_back({ind_m12_props, {999,3} });
      drPassthruStack.push_back({ind_m12_resid, {999,4} });
      drPassthruStack.push_back({ind_m12_inner_y, {999,5} });
      drPassthruStack.push_back({ind_m12_inner_x, {999,6} });
      drPassthruStack.push_back({ind_m12_nTurns, {999,7} });
   
      drPassthruStack.push_back({ind_tm1_id, {998,1} });
      drPassthruStack.push_back({ind_tm1_core, {998,2} });
      drPassthruStack.push_back({ind_tm1_props, {998,3} });
      drPassthruStack.push_back({ind_tm1_resid, {998,4} });
      drPassthruStack.push_back({ind_tm1_inner_y, {998,5} });
      drPassthruStack.push_back({ind_tm1_inner_x, {998,6} });
      drPassthruStack.push_back({ind_tm1_nTurns, {998,7} });
      drPassthruStack.push_back({ind_tm1_id_inside, {998,8} });
      drPassthruStack.push_back({ind_tm1_coin_edge, {998,9} });
   #endif
#endif

// illegal devices 

// looks like not needed but rember pn/np are not reserved function/device names
//pn = POLY and NDIFF ;
//pn = pn not VDMOSID ;
//pn = pn not drACTCAP_ID ;
//pn = pn not WELLRES_ID ;
// pp = POLY and PDIFF ;

allgates = all_ngate or all_pgate ;
allgates = allgates not esd_ngate ;
vd_nwell = NWELL and VDMOSID ;
vd_ndiff = NDIFF and VDMOSID ;
vd_poly = POLY and VDMOSID ;
vd_gate = vd_ndiff and vd_poly ;
nwell_poly_ndiff = vd_nwell and vd_gate ;


// data validity checks - diffusion can not cut well 
#if (!defined(_drSigPlot) && !defined(_drLVSONLY))
Error_illdev_nxingwell @= {
   @"illdev: illegal structure ndiff crossing well" ;
   NDIFF cutting [include_enclosing = false] ALLNWELL;
}
drPushErrorStack(Error_illdev_nxingwell, xc(illdev_nxingwell));

Error_illdev_pxingwell @= {
   @"illdev: illegal structure pdiff crossing well" ;
   PDIFF cutting [include_enclosing = false] ALLNWELL;
}
drPushErrorStack(Error_illdev_pxingwell, xc(illdev_pxingwell));

// more illegal devices 
Error_illdev @= {
   // WELLRES_ID cant be in NWELL
   @"illdev: illdev - illegal device formation - nwell and wellres_id" ;
   note(CheckingString("illdev_nwell_wellres_id"));
   NWELL and WELLRES_ID;

   // gates cant be in WELLRES_ID 
   @"illdev: illdev - illegal device formation - gate and wellres_id";
   note(CheckingString("illdev_gate_wellres_id"));
   (allgates not all_esd_ngate) and WELLRES_ID;

   // gates cant be in PRES_ID 
   @"illdev: illdev - illegal device formation - gate and pres_id";
   note(CheckingString("illdev_gate_pres_id"));
   allgates and PRES_ID;

   // POLYCON cant be in PRES_ID 
   @"illdev: illdev - illegal device formation - polycon and pres_id";
   note(CheckingString("illdev_polycon_pres_id"));
   POLYCON and PRES_ID;

   // PRES_ID must touch poly res body
   @"illdev: illdev - illegal RESID usage - PRES_ID without underlying POLY";
   note(CheckingString("illdev_poly_pres_id"));
   PRES_ID not_interacting poly_res_cl;

   // diff with WELLRES_ID must be covered by poly
   @"illdev: illdev - illegal device formation - diff_wr_id not poly";
   note(CheckingString("illdev_diff_wr_id_poly"));
   diff_w_id = DIFF and WELLRES_ID;
   diff_w_id not POLY;

   // VIACON cant be in DIFFCONRESID 
   @"illdev: illdev - illegal device formation - viacon diffconresid";
   note(CheckingString("illdev_vc_dcresid"));
   VIACON and DIFFCONRESID;

   // POLYCON cant be in DIFFCONRESID 
   @"illdev: illdev - illegal device formation - polycon diffconresid";
   note(CheckingString("illdev_pc_dcresid"));
   POLYCON and DIFFCONRESID;

   // DIFFCONRESID shouldnt be inside DIFFCONPORT 
   @"illdev: illdev - illegal RESID usage - DIFFCONRESID should not overlap DIFFCONPORT";
   note(CheckingString("illdev_diffconport_diffconresid"));
   diffconpin and DIFFCONRESID; 

   // VIACON cant be in POLYCONRESID 
   @"illdev: illdev - illegal device formation - viacon polyconresid";
   note(CheckingString("illdev_vc_pcresid"));
   VIACON and POLYCONRESID;

   // DIFFCON cant be in POLYCONRESID 
   @"illdev: illdev - illegal device formation - diffcon polyconresid";
   note(CheckingString("illdev_dc_pcresid"));
   DIFFCON and POLYCONRESID;

   // POLY cant be in POLYCONRESID 
   @"illdev: illdev - illegal device formation - poly polyconresid";
   note(CheckingString("illdev_poly_pcresid"));
   POLY and POLYCONRESID;

   // POLYCONRESID shouldnt be inside POLYCONPORT 
   @"illdev: illdev - illegal RESID usage - POLYCONRESID should not overlap POLYCONPORT";
   note(CheckingString("illdev_polyconport_polyconresid"));
   polyconpin and POLYCONRESID; 

   // VIACON cant be in MET0RESID 
   @"illdev: illdev - illegal device formation - viacon and met0resid";
   note(CheckingString("illdev_vcn_m0resid"));
   VIACON and MET0BCRESID;

   // VIA0 cant be in MET0RESID 
   @"illdev: illdev - illegal device formation - via0 and met0resid";
   note(CheckingString("illdev_v0_m0resid"));
   VIA0 and MET0BCRESID;

   // MET0RESID must touch m0 res body
   @"illdev: illdev - illegal RESID usage - MET0RESID without underlying METAL0";
   note(CheckingString("illdev_met0_met0resid"));
   MET0BCRESID not_interacting metal0nores;

   // MET0RESID shouldnt be inside MET0PORT 
   @"illdev: illdev - illegal RESID usage - MET0RESID should not overlap MET0PORT";
   note(CheckingString("illdev_met0port_met0resid"));
   met0bcpin and MET0BCRESID;

   // VIA0 cant be in MET1RESID 
   @"illdev: illdev - illegal device formation - via0 and met1resid";
   note(CheckingString("illdev_v0_m1resid"));
   VIA0 and MET1BCRESID;

   // VIA1 cant be in MET1RESID 
   @"illdev: illdev - illegal device formation - via1 and met1resid";
   note(CheckingString("illdev_v1_m1resid"));
   VIA1 and MET1BCRESID;

   // MET1RESID must touch m1 res body
   @"illdev: illdev - illegal RESID usage - MET1RESID without underlying METAL1";
   note(CheckingString("illdev_met1_met1resid"));
   MET1BCRESID not_interacting metal1nores;

   // MET1RESID shouldnt be inside MET1PORT 
   @"illdev: illdev - illegal RESID usage - MET1RESID should not overlap MET1PORT";
   note(CheckingString("illdev_met1port_met1resid"));
   met1bcpin and MET1BCRESID;

   // VIA1 cant be in MET2RESID 
   @"illdev: illdev - illegal device formation - via1 and met2resid";
   note(CheckingString("illdev_v1_m2resid"));
   VIA1 and MET2BCRESID;

   // VIA2 cant be in MET2RESID 
   @"illdev: illdev - illegal device formation - via2 and met2resid";
   note(CheckingString("illdev_v2_m2resid"));
   VIA2 and MET2BCRESID;

   // MET2RESID must touch m2 res body
   @"illdev: illdev - illegal RESID usage - MET2RESID without underlying METAL2";
   note(CheckingString("illdev_met2_met2resid"));
   MET2BCRESID not_interacting metal2nores;

   // MET2RESID shouldnt be inside MET2PORT 
   @"illdev: illdev - illegal RESID usage - MET2RESID should not overlap MET2PORT";
   note(CheckingString("illdev_met2port_met2resid"));
   met2bcpin and MET2BCRESID;

   // VIA2 cant be in MET3RESID 
   @"illdev: illdev - illegal device formation - via2 and met3resid";
   note(CheckingString("illdev_v2_m3resid"));
   VIA2 and MET3BCRESID;

   // VIA3 cant be in MET3RESID 
   @"illdev: illdev - illegal device formation - via3 and met3resid";
   note(CheckingString("illdev_v3_m3resid"));
   VIA3 and MET3BCRESID;

   // MET3RESID must touch m3 res body
   @"illdev: illdev - illegal RESID usage - MET3RESID without underlying METAL3";
   note(CheckingString("illdev_met3_met3resid"));
   MET3BCRESID not_interacting metal3nores;

   // MET3RESID shouldnt be inside MET3PORT 
   @"illdev: illdev - illegal RESID usage - MET3RESID should not overlap MET3PORT";
   note(CheckingString("illdev_met3port_met3resid"));
   met3bcpin and MET3BCRESID;

   // VIA3 cant be in MET4RESID 
   @"illdev: illdev - illegal device formation - via3 and met4resid";
   note(CheckingString("illdev_v3_m4resid"));
   VIA3 and MET4BCRESID;

   // VIA4 cant be in MET4RESID 
   @"illdev: illdev - illegal device formation - via4 and met4resid";
   note(CheckingString("illdev_v4_m4resid"));
   VIA4 and MET4BCRESID;

   // MET4RESID must touch m4 res body
   @"illdev: illdev - illegal RESID usage - MET4RESID without underlying METAL4";
   note(CheckingString("illdev_met4_met4resid"));
   MET4BCRESID not_interacting metal4nores;

   // MET4RESID shouldnt be inside MET4PORT 
   @"illdev: illdev - illegal RESID usage - MET4RESID should not overlap MET4PORT";
   note(CheckingString("illdev_met4port_met4resid"));
   met4bcpin and MET4BCRESID;

   // VIA4 cant be in MET5RESID 
   @"illdev: illdev - illegal device formation - via4 and met5resid";
   note(CheckingString("illdev_v4_m5resid"));
   VIA4 and MET5BCRESID;

   // VIA5 cant be in MET5RESID 
   @"illdev: illdev - illegal device formation - via5 and met5resid";
   note(CheckingString("illdev_v5_m5resid"));
   VIA5 and MET5BCRESID;

   // MET5RESID must touch m5 res body
   @"illdev: illdev - illegal RESID usage - MET5RESID without underlying METAL5";
   note(CheckingString("illdev_met5_met5resid"));
   MET5BCRESID not_interacting metal5nores;

   // MET5RESID shouldnt be inside MET5PORT 
   @"illdev: illdev - illegal RESID usage - MET5RESID should not overlap MET5PORT";
   note(CheckingString("illdev_met5port_met5resid"));
   met5bcpin and MET5BCRESID;

   // VIA5 cant be in MET6RESID 
   @"illdev: illdev - illegal device formation - via5 and met6resid";
   note(CheckingString("illdev_v5_m6resid"));
   VIA5 and MET6BCRESID;

   // VIA6 cant be in MET6RESID 
   @"illdev: illdev - illegal device formation - via6 and met6resid";
   note(CheckingString("illdev_v6_m6resid"));
   VIA6 and MET6BCRESID;

   // MET6RESID must touch m6 res body
   @"illdev: illdev - illegal RESID usage - MET6RESID without underlying METAL6";
   note(CheckingString("illdev_met6_met6resid"));
   MET6BCRESID not_interacting metal6nores;

   // MET6RESID shouldnt be inside MET6PORT 
   @"illdev: illdev - illegal RESID usage - MET6RESID should not overlap MET6PORT";
   note(CheckingString("illdev_met6port_met6resid"));
   met6bcpin and MET6BCRESID;

   // VIA6 cant be in MET7RESID 
   @"illdev: illdev - illegal device formation - via6 and met7resid";
   note(CheckingString("illdev_v6_m7resid"));
   VIA6 and MET7BCRESID;

   // VIA7 cant be in MET7RESID 
   @"illdev: illdev - illegal device formation - via7 and met7resid";
   note(CheckingString("illdev_v7_m7resid"));
   VIA7 and MET7BCRESID;

   // MET7RESID must touch m7 res body
   @"illdev: illdev - illegal RESID usage - MET7RESID without underlying METAL7";
   note(CheckingString("illdev_met7_met7resid"));
   MET7BCRESID not_interacting metal7nores;

   // MET7RESID shouldnt be inside MET7PORT 
   @"illdev: illdev - illegal RESID usage - MET7RESID should not overlap MET7PORT";
   note(CheckingString("illdev_met7port_met7resid"));
   met7bcpin and MET7BCRESID;

   // VIA7 cant be in MET8RESID 
   @"illdev: illdev - illegal device formation - via7 and met8resid";
   note(CheckingString("illdev_v7_m8resid"));
   VIA7 and MET8BCRESID;

   // VIA8 cant be in MET8RESID 
   @"illdev: illdev - illegal device formation - via8 and met8resid";
   note(CheckingString("illdev_v8_m8resid"));
   VIA8 and MET8BCRESID;

   // MET8RESID must touch m8 res body
   @"illdev: illdev - illegal RESID usage - MET8RESID without underlying METAL8";
   note(CheckingString("illdev_met8_met8resid"));
   MET8BCRESID not_interacting metal8nores;

   // MET8RESID shouldnt be inside MET8PORT 
   @"illdev: illdev - illegal RESID usage - MET8RESID should not overlap MET8PORT";
   note(CheckingString("illdev_met8port_met8resid"));
   met8bcpin and MET8BCRESID;


   // VIA8 cant be in MET9RESID 
   @"illdev: illdev - illegal device formation - via8 and met9resid";
   note(CheckingString("illdev_v8_m9resid"));
   VIA8 and MET9BCRESID;

   // VIA9 cant be in MET9RESID 
   @"illdev: illdev - illegal device formation - via9 and met9resid";
   note(CheckingString("illdev_v9_m9resid"));
   VIA9 and MET9BCRESID;

   // MET9RESID must touch m9 res body
   @"illdev: illdev - illegal RESID usage - MET9RESID without underlying METAL9";
   note(CheckingString("illdev_met9_met9resid"));
   MET9BCRESID not_interacting metal9nores;

   // MET9RESID shouldnt be inside MET9PORT 
   @"illdev: illdev - illegal RESID usage - MET9RESID should not overlap MET9PORT";
   note(CheckingString("illdev_met9port_met9resid"));
   met9bcpin and MET9BCRESID;

   #if _drPROCESS != 6 && _drPROCESS != 5 
      // VIA9 cant be in TM1RESID 
      @"illdev: illdev - illegal device formation - via9 and tm1resid";
      note(CheckingString("illdev_v9_tm1resid"));
      VIA9 and TM1BCRESID;
   #endif

   // VIA9 cant be in MET10RESID 
   @"illdev: illdev - illegal device formation - via9 and met10resid";
   note(CheckingString("illdev_v9_m10resid"));
   VIA9 and MET10BCRESID;
   
   // VIA10 cant be in MET10RESID 
   @"illdev: illdev - illegal device formation - via10 and met10resid";
   note(CheckingString("illdev_v10_m10resid"));
   VIA10 and MET10BCRESID;
   
   // MET10RESID must touch m10 res body
   @"illdev: illdev - illegal RESID usage - MET10RESID without underlying METAL10";
   note(CheckingString("illdev_met10_met10resid"));
   MET10BCRESID not_interacting metal10nores;

   // MET10RESID shouldnt be inside MET10PORT 
   @"illdev: illdev - illegal RESID usage - MET10RESID should not overlap MET10PORT";
   note(CheckingString("illdev_met10port_met10resid"));
   met10bcpin and MET10BCRESID;

   #if _drPROCESS == 5
      // VIA10 cant be in TM1RESID 
      @"illdev: illdev - illegal device formation - via10 and tm1resid";
      note(CheckingString("illdev_v10_tm1resid"));
      VIA10 and TM1BCRESID;
   #endif

   // VIA10 cant be in MET11RESID 
   @"illdev: illdev - illegal device formation - via10 and met11resid";
   note(CheckingString("illdev_v10_m11resid"));
   VIA10 and MET11BCRESID;

   // VIA11 cant be in MET11RESID 
   @"illdev: illdev - illegal device formation - via11 and met11resid";
   note(CheckingString("illdev_v11_m11resid"));
   VIA11 and MET11BCRESID;

   // MET11RESID must touch m11 res body
   @"illdev: illdev - illegal RESID usage - MET11RESID without underlying METAL11";
   note(CheckingString("illdev_met11_met11resid"));
   MET11BCRESID not_interacting metal11nores;

   // MET11RESID shouldnt be inside MET11PORT 
   @"illdev: illdev - illegal RESID usage - MET11RESID should not overlap MET11PORT";
   note(CheckingString("illdev_met11port_met11resid"));
   met11bcpin and MET11BCRESID;

   // VIA11 cant be in MET12RESID 
   @"illdev: illdev - illegal device formation - via11 and met12resid";
   note(CheckingString("illdev_v11_m12resid"));
   VIA11 and MET12BCRESID;

   // VIA12 cant be in MET12RESID 
   @"illdev: illdev - illegal device formation - via12 and met12resid";
   note(CheckingString("illdev_v12_m12resid"));
   VIA12 and MET12BCRESID;

   // MET12RESID must touch m12 res body
   @"illdev: illdev - illegal RESID usage - MET12RESID without underlying METAL12";
   note(CheckingString("illdev_met12_met12resid"));
   MET12BCRESID not_interacting metal12nores;

   // MET12RESID shouldnt be inside MET12PORT 
   @"illdev: illdev - illegal RESID usage - MET12RESID should not overlap MET12PORT";
   note(CheckingString("illdev_met12port_met12resid"));
   met12bcpin and MET12BCRESID;

   // VIA12 cant be in TM1RESID 
   @"illdev: illdev - illegal device formation - via12 and tm1resid";
   note(CheckingString("illdev_v12_tm1resid"));
   VIA12 and TM1BCRESID;

   // TV1 cant be in TM1RESID 
   @"illdev: illdev - illegal device formation - tv1 and tm1resid";
   note(CheckingString("illdev_tv1_tm1resid"));
   TV1 and TM1BCRESID;

   // TM1RESID must touch tm1 res body
   @"illdev: illdev - illegal RESID usage - TM1RESID without underlying TM1";
   note(CheckingString("illdev_tm1_tm1resid"));
   TM1BCRESID not_interacting tm1nores;

   // TM1RESID shouldnt be inside TM1PORT 
   @"illdev: illdev - illegal RESID usage - TM1RESID should not overlap TM1PORT";
   note(CheckingString("illdev_tm1port_tm1resid"));
   tm1bcpin and TM1BCRESID;

   // TSV cant be in RDLRESID 
   @"illdev: illdev - illegal device formation - tsv and rdlresid";
   note(CheckingString("illdev_tsv_rdlresid"));
   TSV and RDLRESID;

   // LMIPAD cant be in RDLRESID 
   @"illdev: illdev - illegal device formation - lmipad and rdlresid";
   note(CheckingString("illdev_lmipad_rdlresid"));
   LMIPAD and RDLRESID;

   // RDLRESID must touch rdl res body
   @"illdev: illdev - illegal RESID usage - RDLRESID without underlying RDL";
   note(CheckingString("illdev_rdl_rdlresid"));
   RDLRESID not_interacting rdlres_cl;

   // RDLRESID shouldnt be inside RDLPORT 
   @"illdev: illdev - illegal RESID usage - RDLRESID should not overlap RDLPORT";
   note(CheckingString("illdev_rdlport_rdlresid"));
   rdlpin and RDLRESID;

   // MTJ cant be in MCRRESID 
   @"illdev: illdev - illegal device formation - mtj and mcrresid";
   note(CheckingString("illdev_mtj_mcrresid"));
   MTJ and MCRRESID;

   // MTJ cant be in MET4BCRESID 
   @"illdev: illdev - illegal device formation - mtj and m4resid";
   note(CheckingString("illdev_mtj_m4resid"));
   MTJ and MET4BCRESID;

   // VCR cant be in MCRRESID 
   @"illdev: illdev - illegal device formation - vcr and mcrresid";
   note(CheckingString("illdev_vcr_mcrresid"));
   VCR and MCRRESID;

   // VCR cant be in MET4BCRESID 
   @"illdev: illdev - illegal device formation - vcr and m4resid";
   note(CheckingString("illdev_vcr_m4resid"));
   VCR and MET4BCRESID;

   // MCRRESID must touch mcr res body
   @"illdev: illdev - illegal RESID usage - MCRRESID without underlying MCR";
   note(CheckingString("illdev_mcr_mcrresid"));
   MCRRESID not_interacting mcrres_cl;

   // MCRRESID shouldnt be inside MCRPORT 
   @"illdev: illdev - illegal RESID usage - MCRRESID should not overlap MCRPORT";
   note(CheckingString("illdev_mcrport_mcrresid"));
   mcrpin and MCRRESID;

   // POLYCON cant be in vdgate
   @"illdev: illdev - illegal device formation - vdgate and polycon";
   note(CheckingString("illdev_vdgate_polycon"));
   nwell_poly_ndiff and POLYCON;

   // subtap cant touch psd
   @"illdev: illdev - illegal device formation - psd touching ppickup";
   note(CheckingString("illdev_psd_ppickup"));
   psd interacting ppickup;

   // duplicates of IL layers
   // TCN1 illegal layer
   @"illdev: illdev - illegal usage TCN1";
   note(CheckingString("illdev_TCN1"));
   copy(TCN1);

   // LLNMG illegal layer
   @"illdev: illdev - illegal usage LLNMG";
   note(CheckingString("illdev_LLNMG"));
   copy(LLNMG);

   // LLPMG illegal layer
   @"illdev: illdev - illegal usage LLPMG";
   note(CheckingString("illdev_LLPMG"));
   copy(LLPMG);

   // ALTLEIDLL illegal layer
   @"illdev: illdev - illegal usage ALTLEIDLL";
   note(CheckingString("illdev_ALTLEIDLL"));
   copy(ALTLEIDLL);

   // POLYTD illegal layer
   @"illdev: illdev - illegal usage POLYTD";
   note(CheckingString("illdev_POLYTD"));
   copy(POLYTD);

   // TGPITCHID illegal layer
   @"illdev: illdev - illegal usage TGPITCHID";
   note(CheckingString("illdev_TGPITCHID"));
   copy(TGPITCHID);

   // NALMG illegal layer
   @"illdev: illdev - illegal usage NALMG";
   note(CheckingString("illdev_NALMG"));
   copy(NALMG);

   // PALMG illegal layer
   @"illdev: illdev - illegal usage PALMG";
   note(CheckingString("illdev_PALMG"));
   copy(PALMG);

   // uppsupported RF device types
   @"illdev: illdev - illegal RF device type";
   note(CheckingString("unsupported_RF_uva"));
   copy(rfreq_ngate_par_a or rfreq_pgate_par_a);
   copy(rfreq_ngate_stk_a or rfreq_pgate_stk_a);
   note(CheckingString("unsupported_RF_aluv1"));
   copy(rfreq_ngate_par_av1 or rfreq_pgate_par_av1);
   copy(rfreq_ngate_stk_av1 or rfreq_pgate_stk_av1);
   note(CheckingString("unsupported_RF_aluv2"));
   copy(rfreq_ngate_par_av2 or rfreq_pgate_par_av2);
   copy(rfreq_ngate_stk_av2 or rfreq_pgate_stk_av2);
   note(CheckingString("unsupported_RF_allp"));
   copy(rfreq_ngate_par_alp or rfreq_pgate_par_alp);
   copy(rfreq_ngate_stk_alp or rfreq_pgate_stk_alp);
   note(CheckingString("unsupported_RF_uv0"));
   copy(rfreq_ngate_par_v0 or rfreq_pgate_par_v0);
   copy(rfreq_ngate_stk_v0 or rfreq_pgate_stk_v0);
   note(CheckingString("unsupported_RF_uv1"));
   copy(rfreq_ngate_par_v1 or rfreq_pgate_par_v1);
   copy(rfreq_ngate_stk_v1 or rfreq_pgate_stk_v1);
   note(CheckingString("unsupported_RF_uv1lp"));
   copy(rfreq_ngate_par_v1lp or rfreq_pgate_par_v1lp);
   copy(rfreq_ngate_stk_v1lp or rfreq_pgate_stk_v1lp);
   note(CheckingString("unsupported_RF_uv2lp"));
   copy(rfreq_ngate_par_v2lp or rfreq_pgate_par_v2lp);
   copy(rfreq_ngate_stk_v2lp or rfreq_pgate_stk_v2lp);
   note(CheckingString("unsupported_RF_uvt"));
   copy(rfreq_ngate_par_uvt or rfreq_pgate_par_uvt);
   copy(rfreq_ngate_stk_uvt or rfreq_pgate_stk_uvt);
   note(CheckingString("unsupported_RF_xlllp"));
   copy(rfreq_ngate_par_x or rfreq_pgate_par_x);
   copy(rfreq_ngate_stk_x or rfreq_pgate_stk_x);

   // STACKDEVTYPE 82,99,nomStack,devType construction
   // must be a rectangle
   @ "SD_01: " + drHash[xc(SD_01)] ;
   not_rectangles(STACKDEVTYPE);
   // must have coincident inside edges with diffusion
   @ "SD_02: " + drHash[xc(SD_02)] ;
   not_coincident_inside_edge(angle_edge_dir(STACKDEVTYPE, gate_dir), DIFF);
   // must have coincident outside edges with POLY
   @ "SD_03: " + drHash[xc(SD_03)] ;
   not_coincident_inside_edge(angle_edge_dir(STACKDEVTYPE, non_gate_dir), POLY);
   // diffcon with stackdevtype cant have viacon
   @ "SD_04: " + drHash[xc(SD_04)] ;
   interacting(interacting(DIFFCON, STACKDEVTYPE),VIACON);

   // PWELL_SUBISO and DEEPNWELL should not cross
   @ "illdev: PWELL_SUBISO should not cut DEEPNWELL";
   PWELL_SUBISO cutting [include_enclosing = false] DEEPNWELL; 

   // deprecated cells which should no longer be used
   // hsd 2297
   @"illdev: illdev - Deprecated templates no longer supported";
   deprecatedTemplates:list of string = {"d8xsdcpiptgevm2", "d8xsdcpiptgevm4" };
   copy_by_cells(CELLBOUNDARY, deprecatedTemplates, depth = CELL_LEVEL);

   // RFREQ limitation  
   @ "illdev: RFREQDEVTYPE must be covered by TEMPLATEID1";
   RFREQDEVTYPE not TEMPLATEID1;

}
drPushErrorStack(Error_illdev, xc(illdev));
#endif

#ifdef _drCADNAV
   #include <p12723_CADNAV_extr_dummydev.rs>
   #include <p12723_CADNAV_extr_dummymetal.rs>
#endif

#if defined(_drRCextract)
   #include <1273/p1273dx_Tcommonrce.rs>
#endif

#endif  // end _P1273DX_TCOMMON_RS_
