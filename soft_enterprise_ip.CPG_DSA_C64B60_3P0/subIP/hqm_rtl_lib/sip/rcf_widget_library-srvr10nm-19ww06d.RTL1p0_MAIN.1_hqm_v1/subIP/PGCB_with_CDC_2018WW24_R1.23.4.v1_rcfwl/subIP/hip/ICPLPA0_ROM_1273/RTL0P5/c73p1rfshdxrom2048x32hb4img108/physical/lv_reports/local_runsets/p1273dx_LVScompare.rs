// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_LVScompare.rs.rca 1.68 Mon Sep 29 17:01:58 2014 kperrey Experimental $
//
// $Log: p1273dx_LVScompare.rs.rca $
// 
//  Revision: 1.68 Mon Sep 29 17:01:58 2014 kperrey
//  allow the short_equivalent_nodes directives to be disabled with _drNoShortEQNodes
// 
//  Revision: 1.67 Thu Sep 25 12:55:03 2014 kperrey
//  hsd 2754 ; _drICFDEVICES not limited to just dotSix
// 
//  Revision: 1.66 Wed Sep 24 11:33:37 2014 kperrey
//  check props for mfc2portII_m5 mfc2portII_m4 mfc2portII_m3; similar to other scaleable mfc
// 
//  Revision: 1.65 Sat Sep  6 12:35:25 2014 kperrey
//  removed the vx device references
// 
//  Revision: 1.62 Sat Aug 16 12:54:00 2014 kperrey
//  support the icf sov/scv/som/scm/aliasd devices; allow sov/scv devices to merge
// 
//  Revision: 1.61 Thu Aug 14 09:00:31 2014 kperrey
//  merge the dnw diodes if _drALLOW_DNW
// 
//  Revision: 1.60 Tue Aug 12 16:18:31 2014 kperrey
//  change action_on_error to EXPLODE if Compall Scarlet rcextract
// 
//  Revision: 1.59 Tue Aug 12 15:25:02 2014 kperrey
//  allow ddnwpw device to be also controlled by _drALLOW_DNW
// 
//  Revision: 1.58 Fri Aug  8 09:31:43 2014 kperrey
//  no longer support area or merging of sclmfc
// 
//  Revision: 1.57 Tue Aug  5 22:23:40 2014 kperrey
//  removed reference to scm/som/scv/sov devices and via*nores since they were not program approved enhancements as per chia-hong
// 
//  Revision: 1.56 Tue Aug  5 16:28:16 2014 kperrey
//  save point so I can remove the scm/som/scv/sov stuff
// 
//  Revision: 1.55 Thu Jul 31 22:56:32 2014 kperrey
//  hsd 2425 ; support for sov/sovx/scv/scvm via resistors ; if _drRFRV load a different user_functions_file p12723_LVSfunctionsRV.rs changes property handling of the rf devices
// 
//  Revision: 1.54 Thu Jul 17 20:31:39 2014 kperrey
//  hsd 2567 ; treat pulv like a p and nulv like a n during lvs
// 
//  Revision: 1.53 Thu Jul 17 11:52:42 2014 kperrey
//  add check_property directives for the scaleable mfc check w l MBOT MTOP
// 
//  Revision: 1.52 Mon Jul  7 15:46:11 2014 kperrey
//  hsd 2425; turn off all the property checking for the som somx scm scmx devices
// 
//  Revision: 1.51 Tue May 20 13:58:20 2014 kperrey
//  hsd 2392 ; change drNO to _drNO which is the actual define
// 
//  Revision: 1.50 Tue Apr 29 10:14:38 2014 kperrey
//  if _drRCextract dont need to filter gnacs or caps since they are not extracted in the first place
// 
//  Revision: 1.49 Tue Mar 18 17:10:44 2014 kperrey
//  add the check_props for the mimcap_scl for ICF
// 
//  Revision: 1.48 Tue Mar 18 10:26:26 2014 kperrey
//  only support a m9(d1) or m12(d6) stack
// 
//  Revision: 1.47 Tue Mar 11 22:35:35 2014 kperrey
//  change lvsmult to multxy
// 
//  Revision: 1.46 Tue Mar 11 17:26:00 2014 kperrey
//  handle calculation for lvsmult ; allow like rf devices to merge parallelly; rf devices need to check lvsmult prop
// 
//  Revision: 1.45 Mon Mar  3 19:06:28 2014 kperrey
//  do not allow nstk/pstk to merge parallelly and nstk/pstk equivalent nodes will not merges ; forces a 1:1 match between schematics and layout
// 
//  Revision: 1.44 Fri Feb 28 12:09:56 2014 kperrey
//  remove dont check property multx/multy
// 
//  Revision: 1.43 Tue Feb 25 08:27:39 2014 kperrey
//  hsd 2148 ; ymult/xmult needs to be multy/multx
// 
//  Revision: 1.42 Thu Feb 20 19:59:13 2014 kperrey
//  hsd 2130; add nstk pstk lvs directives
// 
//  Revision: 1.41 Wed Feb 19 23:26:42 2014 kperrey
//  update the rf devices to use drRFotp.stlen instead of drRFopt.ns add in checks for multx and multy
// 
//  Revision: 1.40 Thu Feb 13 19:23:26 2014 kperrey
//  hsd 2122 ; change property NS to STLEN
// 
//  Revision: 1.39 Wed Jan 29 16:38:04 2014 cpark3
//  added RC extract switch
// 
//  Revision: 1.38 Wed Jan 15 11:27:52 2014 kperrey
//  make ignore_equivs_with_devices_leveled_out by #if VERSION_GE(2013,6,2,0)
// 
//  Revision: 1.37 Wed Jan 15 10:02:15 2014 cpark3
//  reverted back to v1.35
// 
//  Revision: 1.36 Mon Jan  6 08:46:25 2014 cpark3
//  added RC extract switch around filter for the perc djnw device
// 
//  Revision: 1.35 Sun Jan  5 16:25:57 2014 kperrey
//  add check_property options for np/rf np/uv2rf np/tgrf np/tgulvrf
// 
//  Revision: 1.34 Fri Dec  6 13:50:53 2013 kperrey
//  hsd 1975 ; set ignore_equivs_with_devices_leveled_out = true
// 
//  Revision: 1.33 Wed Nov  6 09:09:09 2013 kperrey
//  hsd 1940 ; allow ddnwpw and ddnwpsub diodes to parallel merge in lvs
// 
//  Revision: 1.32 Wed Oct 30 08:35:05 2013 kperrey
//  hsd 1926 ; add support for mcr resistor
// 
//  Revision: 1.31 Thu Sep  5 14:22:16 2013 kperrey
//  hsd 1866 ; support ICF scaleable inductor ind2t_scl_*
// 
//  Revision: 1.30 Thu Aug  1 13:56:35 2013 kperrey
//  change push_down_pins to false, since findgatezl is modified to use new Synopsys function pull_down_to_interacting
// 
//  Revision: 1.29 Mon Jun 10 08:49:39 2013 kperrey
//  always filter the perc djnw device ; the filter for the ddnwpw should be PN instead of NP
// 
//  Revision: 1.28 Thu Jun  6 17:35:41 2013 kperrey
//  add option to also filter ddnwpw
// 
//  Revision: 1.27 Wed Jun  5 21:25:42 2013 kperrey
//  dont check props for ddnwpw ; extract but filter all ddnwpsub
// 
//  Revision: 1.26 Sun May 26 20:26:35 2013 kperrey
//  remove the push_down_pin change that was for starrc; found new design case that breaks this work around
// 
//  Revision: 1.25 Fri Apr 12 08:20:12 2013 kperrey
//  make push_down_pins false for starrc compatibility
// 
//  Revision: 1.24 Thu Mar 28 18:59:26 2013 kperrey
//  handle properties for resistor type 9/10/11/12 based upon dotProcess ; for dot6 turn off diode property checking for diodes with DEEPNWELL
// 
//  Revision: 1.23 Fri Mar 22 08:55:54 2013 kperrey
//  allow nal160/pal160 to merge_parallel/check w/l props/ short equiv nodes
// 
//  Revision: 1.22 Tue Feb 26 13:22:24 2013 kperrey
//  want users to explicitly mark all dummy gates
// 
//  Revision: 1.21 Fri Dec 28 12:00:07 2012 kperrey
//  added handling for NV3/PV3
// 
//  Revision: 1.20 Mon Nov 19 10:18:29 2012 kperrey
//  add in resistors that can exist in dot5 case
// 
//  Revision: 1.19 Thu Oct 18 15:59:30 2012 kperrey
//  added support for rrdlm0 (rdl resistor) for tsv
// 
//  Revision: 1.18 Fri Aug 10 11:28:48 2012 kperrey
//  support for 73.6 add m10/m11
// 
//  Revision: 1.17 Mon Jul 30 23:25:58 2012 kperrey
//  hsd 1309 ; change d8xgbnesdclamptgresistor_prim to d8xgbnesdclamptgres_prim in NMOS check_property
// 
//  Revision: 1.16 Fri May 18 13:24:37 2012 kperrey
//  change filter_options to layout_filter_options (limit filter to only layout) assume everyone using 2011 code
// 
//  Revision: 1.15 Fri May 18 13:14:00 2012 kperrey
//  change push_down_pins to true ; since action_on_error in 2011 and x73pllsbnmosbincp2/x73pllsbpjg_u_05x should help overlap gate/diff case and still be OK for bb
// 
//  Revision: 1.14 Mon May 14 21:50:01 2012 kperrey
//  need to ignore mpcap during _drRCextract
// 
//  Revision: 1.13 Fri May  4 10:41:11 2012 kperrey
//  changes specific to CADNAV/RCEXT and caps/gnacs
// 
//  Revision: 1.12 Tue Mar 13 16:37:33 2012 kperrey
//  added some Scarlet control to support a ICV_REVERT
// 
//  Revision: 1.11 Fri Jan  6 13:03:10 2012 kperrey
//  hsd 1084; use search_include_path for search_include_path
// 
//  Revision: 1.10 Tue Dec 20 14:18:28 2011 kperrey
//  pulled some LVScompare options out for user control (i.e. action_on_error) and include user_LVScompare_options
// 
//  Revision: 1.9 Tue Nov 22 13:37:50 2011 kperrey
//  undo previous change ; reactivate NMOS_2 and PMOS_2
// 
//  Revision: 1.8 Tue Nov 22 07:30:23 2011 kperrey
//  hsd 620965; till Synopsys enhance to sch/lay specific filter ; turn off ?MOS_2 filtering ; pins are seen as connections only when occur in both lay/sch
// 
//  Revision: 1.7 Fri Oct 21 10:58:10 2011 kperrey
//  add NV/PV0 (nuv0/puv0) devices and change nal/pal to nuva/puva
// 
//  Revision: 1.6 Tue Oct 18 10:04:11 2011 kperrey
//  fixed syntax device_name == device_names ; added missing double quotes prior to paluv
// 
//  Revision: 1.5 Mon Oct 17 14:03:19 2011 kperrey
//  only merge parallel like devices digital/analog/sram/thickgate; ensure all devices ar in the check_property digital/analog/sram/thickgate/gbnwell; only short equiv nodes of like devices digital/analog/sram/thickgate
// 
//  Revision: 1.4 Thu Sep  8 13:57:12 2011 kperrey
//  handle option changes for 2011.9 icv ; coded as #if version_LT(2011.9)
// 
//  Revision: 1.3 Wed Aug 31 17:20:14 2011 kperrey
//  add if (_drCaseSensitive == _drNO) to control if whether to be casesensitive or not - default is insensitive
// 
//  Revision: 1.2 Wed Aug  3 14:35:54 2011 kperrey
//  change #ifndef #def to be correct file name
// 
//  Revision: 1.1 Tue Jul 26 15:47:13 2011 kperrey
//  mvfile on Tue Jul 26 15:47:13 2011 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p12723_LVScompare.rs;1.18
// 
//  Revision: 1.18 Wed Feb  9 09:19:14 2011 kperrey
//  pulled match_condition and report_black_box_errors into their user option files which are included
// 
//  Revision: 1.17 Wed Feb  9 08:38:37 2011 kperrey
//  remove #if VERSION_* directives - ASSUME everyone is using 2009.12.SP1 or later ; picked up rest of missed VERSION_* directives
// 
//  Revision: 1.16 Wed Feb  9 08:26:31 2011 kperrey
//  remove #if VERSION_* directives - ASSUME everyone is using 2009.12.SP1 or later
// 
//  Revision: 1.15 Tue Jan  4 11:16:24 2011 kperrey
//  USE_ALL_EQUIV to generate_equiv command
// 
//  Revision: 1.14 Fri Dec 17 15:52:07 2010 kperrey
//  always save equiv_sum_files
// 
//  Revision: 1.13 Mon Dec 13 15:43:39 2010 kperrey
//  have only 1 trace/lvs flow - but still do soft connect (alt) opens - but netlist once (std) ; remove trcview if/else and make unique soft/netlist connectivity models
// 
//  Revision: 1.12 Tue Dec  7 14:43:13 2010 kperrey
//  add in n/paluv1/2 devices - similar to n/pal
// 
//  Revision: 1.11 Mon Nov  8 11:24:52 2010 kperrey
//  simplified to only have N/P z/l tolerances instead of each type of dev having its own
// 
//  Revision: 1.10 Mon Nov  8 11:08:58 2010 kperrey
//  add z/l tol for uv1/uv2 devices
// 
//  Revision: 1.9 Tue Oct 26 14:05:32 2010 kperrey
//  add conditionals for RC extract - filter all gnacs caps
// 
//  Revision: 1.8 Tue Oct 19 09:08:02 2010 kperrey
//  fixed logic and filter functions for when to ignore mnpcaps and gnacs
// 
//  Revision: 1.7 Fri Oct 15 15:22:10 2010 kperrey
//  Updated to sync with latest supported device types
// 
//  Revision: 1.6 Mon Sep 20 16:09:03 2010 kperrey
//  v0/mh/vh namechange vc/m0/v0
// 
//  Revision: 1.5 Fri Sep 17 15:50:29 2010 kperrey
//  fixed R to match extracted resistor names
// 
//  Revision: 1.4 Thu Aug 12 09:42:41 2010 kperrey
//  add control to filter gnacs/m?cap devices ; change cadnav filters for gnacs/caps
// 
//  Revision: 1.3 Thu Aug 12 07:28:52 2010 kperrey
//  filter np/pn diodes when _drDONTCMPDIODES
// 
//  Revision: 1.2 Thu Jul 22 14:08:00 2010 kperrey
//  handle p1272 to p12723 name reference
// 
//  Revision: 1.1 Thu Jul 22 13:11:02 2010 kperrey
//  mvfile on Thu Jul 22 13:11:02 2010 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p1272_LVScompare.rs;1.2
// 
//  Revision: 1.2 Thu Jun 24 23:11:32 2010 kperrey
//  added hvngatednac support
// 
// 

// converted p1270_LVScompare.rs

#if  _drLVS==_dryes

#ifndef _P1273DX_LVSCOMPARE_RS_
#define _P1273DX_LVSCOMPARE_RS_
   
   drCompareSetting = init_compare_matrix();
   
   match (
      state = drCompareSetting,
      detect_permutable_ports = false,
      match_condition = {
         #include <user_LVSmatch_options>
      },
      match_by_net_name = true,
      report_black_box_errors = {
         #include <user_LVSbbox_options>
      },
      // this seems like something new - could be used to make lvs report
      // more like cvscmp - but NONE seems to match existing 1268 LVS the best
      no_explode_condition = PROPERTY_ERRORS_ONLY

   );

   // handle the multxy
   recalculate_property (
      state = drCompareSetting,
      device_type = NMOS,
      device_names = {
         // digital
         "nrf", "nuv2rf", 
         // thickgate
         "ntgrf", "ntgulvrf"
	  },
      property_function  =  "recalc_rfmos"
   );
   merge_parallel ( drCompareSetting,
      device_type = NMOS,
      device_names = {
         // digital
         "nrf", "nuv2rf", 
         // thickgate
         "ntgrf", "ntgulvrf"
      },
	  property_functions = parallel_rf_merge,
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}, 
	                        {property = "w", tolerance = [-1,1]}}
   );
   recalculate_property (
      state = drCompareSetting,
      device_type = PMOS,
      device_names = {
         // digital
         "prf", "puv2rf", 
         // thickgate
         "ptgrf", "ptgulvrf"
	  },
      property_function  =  "recalc_rfmos"
   );
   merge_parallel ( drCompareSetting,
      device_type = PMOS,
      device_names = {
         // digital
         "prf", "puv2rf", 
         // thickgate
         "ptgrf", "ptgulvrf"
      },
	  property_functions = parallel_rf_merge,
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}, 
	                        {property = "w", tolerance = [-1,1]}}
   );

   // how to merge parallel p devices
   // don't merge if l difference > +/- 1% 
   // only digital merge
   merge_parallel ( drCompareSetting,
      device_type = PMOS,
      device_names = {
         "p", "puv0", "puv1", "puv2", "puv3", "pulv", "puv1lp", "puv2lp", "puvt", "plllp", "pxlllp"
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );
  
   // only analog merge
   merge_parallel ( drCompareSetting,
      device_type = PMOS,
      device_names = {
         "puva", "paluv1", "paluv2", "paluv3", "pallp"
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );
   
   // only sram merge
   merge_parallel ( drCompareSetting,
      device_type = PMOS,
      device_names = {
         "psr", "psrlp" 
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );
   
   // only thickgate merge
   merge_parallel ( drCompareSetting,
      device_type = PMOS,
      device_names = {
         "ptg", "ptgulv", "pal160" 
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );
   
   // how to merge parallel n devices
   // don't merge if l difference > +/- 1% 
   // only digital merge
   merge_parallel ( drCompareSetting,
      device_type = NMOS,
      device_names = {
         "n", "nuv0", "nuv1", "nuv2", "nuv3", "nulv", "nuv1lp", "nuv2lp", "nuvt", "nlllp", "nxlllp"
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );
   
   // only analog merge
   merge_parallel ( drCompareSetting,
      device_type = NMOS,
      device_names = {
         "nuva", "naluv1", "naluv2", "naluv3", "nallp"
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );
   
   // only sram merge
   merge_parallel ( drCompareSetting,
      device_type = NMOS,
      device_names = {
         "nsr", "nsrlp", "nsrhvt", "nsrpg"
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );
   
   // only thickgate merge
   merge_parallel ( drCompareSetting,
      device_type = NMOS,
      device_names = {
         "ntg", "ntgulv", "nal160"
      },
      property_functions={{"birds_beak_w"}},
      exclude_tolerances = {{property = "l", tolerance = [-1,1]}}
   );

   #if (_drPROCESS == 6   || _drALLOW_DNW)
      // merge parallel PN ddnwpw
      merge_parallel ( drCompareSetting,
         device_type = PN,
         device_names = { "ddnwpw" }
      );
	  
      // merge parallel NP ddnwpsub
      merge_parallel ( drCompareSetting,
         device_type = NP,
         device_names = { "ddnwpsub" }
      );
   #endif
			
   // dont merge parallel pnp/np/pn 
   //merge_parallel ( drCompareSetting,
   //   device_type = PNP
   //);
   
   //merge_parallel ( drCompareSetting,
   //   device_type = PN
   //);
   
   //merge_parallel ( drCompareSetting,
   //   device_type = NP
   //);
   
   // why merge series p - makes no sense
   // merge_series ( drCompareSetting,
   //   device_type = PMOS,
   //   device_names = { "p", "pll", "pah", "pal", "psr", "puvt", "plluvt" },
   //   multiple_paths = true
   //);
      
   // merge parallel via switches 
   #if _drPROCESSNAME == 1273
      merge_parallel ( drCompareSetting,
         device_type = RESISTOR,
         device_names = { 
            "scv0", "sov0", // "scvx0", "sovx0",
            "scv1", "sov1", // "scvx1", "sovx1",
            "scv2", "sov2", // "scvx2", "sovx2",
            "scv3", "sov3", // "scvx3", "sovx3",
            "scv4", "sov4", // "scvx4", "sovx4",
            "scv5", "sov5", // "scvx5", "sovx5",
            "scv6", "sov6", // "scvx6", "sovx6",
            "scv7", "sov7", // "scvx7", "sovx7",
            "scv8", "sov8", // "scvx8", "sovx8", 
            "scv9", "sov9" //, "scvx9", "sovx9"
            #if _drPROCESS == 6
               ,
               "scv10", "sov10", // "scvx10", "sovx10",
               "scv11", "sov11", // "scvx11", "sovx11",
               "scv12", "sov12" // , "scvx12", "sovx12"
            #endif
	     }
      );
   #endif

   check_property ( drCompareSetting, 
      device_type = PMOS, 
      device_names = {
         // digital
         "p", "puv0", "puv1", "puv2", "puv3", "pulv", "puv1lp", "puv2lp", "puvt", "plllp", "pxlllp", 
         // analog
         "puva", "paluv1", "paluv2", "paluv3", "pallp",
         // sram
         "psr", "psrlp", 
         // thickgate
         "ptg", "ptgulv", "pal160",
         // stacked
		 "pstk"
      },
      property_tolerances = { {"w", drPopt.ztol}, {"l", drPopt.ltol} }
   );

   check_property ( drCompareSetting, 
      device_type = PMOS, 
      device_names = {
         // digital
         "prf", "puv2rf", 
         // thickgate
         "ptgrf", "ptgulvrf"
      },
      property_tolerances = { {"w", drRFopt.ztol}, {"l", drRFopt.ltol}, 
	                          {"NF", drRFopt.nf}, {"STLEN", drRFopt.stlen},
	                          {"multxy", drRFopt.multxy}
							  }
   );
   
// mpcap not extracted in CADNAV flow  
#if (!defined(_drCADNAV) && !defined(_drRCextract))
   check_property ( drCompareSetting, 
      device_type = PMOS, 
      device_names = {"mpcap"}, 
      property_tolerances = { {"w", drMPCAPopt.ztol}, {"l", drMPCAPopt.ltol} }
   );
#endif  // ! _drCADNAV
   
   check_property ( drCompareSetting, 
      device_type = NMOS, 
      device_names = {
         // digital
         "n", "nuv0", "nuv1", "nuv2", "nuv3", "nulv", "nuv1lp", "nuv2lp", "nuvt", "nlllp", "nxlllp",
         // analog
         "nuva", "naluv1", "naluv2", "naluv3", "nallp",
         // sram
         "nsr", "nsrlp", "nsrhvt", "nsrpg",
         // thickgate
         "ntg", "ntgulv", "nal160",
         // gbnwell devices
         "c8xlrgbnevm2k1p4_prim", "c8xlrgbnevm2k1p1_prim", "c8xlrgbnevm2k7p5_prim", 
         "c8xlrgbnevm2k3p5_prim", "c8xlrgbnevm2k0p4_prim", "c8xgbnesdclampresistor_prim",
         "d8xgbnesdclampresistor_prim", "d8xgbnesdclamptgres_prim", "gbnwell",
         // special devices
         "m", "vs",
         // stacked devices
		 "nstk"
      }, 
      property_tolerances = { {"w", drNopt.ztol}, {"l", drNopt.ltol} }
   );

   check_property ( drCompareSetting, 
      device_type = NMOS, 
      device_names = {
         // digital
         "nrf", "nuv2rf", 
         // thickgate
         "ntgrf", "ntgulvrf"
      },
      property_tolerances = { {"w", drRFopt.ztol}, {"l", drRFopt.ltol}, 
	                          {"NF", drRFopt.nf}, {"STLEN", drRFopt.stlen},
	                          {"multxy", drRFopt.multxy}
							  }
   );

// ngatednac / mncap not extracted in CADNAV flow  or Scarlet
#if (!defined(_drCADNAV) && !defined(_drRCextract))
   check_property ( drCompareSetting, 
      device_type = NMOS, 
      device_names = {"ngatednac"}, 
      property_tolerances = { {"w", drNGATEDNACopt.ztol}, {"l", drNGATEDNACopt.ltol} }
   );
   
   check_property ( drCompareSetting, 
      device_type = NMOS, 
      device_names = {"hvngatednac"}, 
      property_tolerances = { {"w", drNGATEDNACopt.ztol}, {"l", drNGATEDNACopt.ltol} }
   );
 
   check_property ( drCompareSetting, 
      device_type = NMOS, 
      device_names = {"mncap"}, 
      property_tolerances = { {"w", drMNCAPopt.ztol}, {"l", drMNCAPopt.ltol} }
   );
#endif  // ! _drCADNAV && ! _drRCextract
   
   check_property ( drCompareSetting, RESISTOR,
      device_names = {
        "rp",
        "rm0fm1",  
        "rm1fm2",  //carmel is different
        "rm2m1m3", //carmel is different
        "rm3m2m4",
        "rm4m3m5",
        "rm5m4m6",
        "rmcrm4m6",
        "rm6m5",
        "rm7m6",
        "rm8m7",
        "rm9m8",
//        #if _drPROCESS == 5
//            "rm10m9",
//            "rtm1m10",
        #if _drPROCESS == 6
            "rm10m9",
            "rm11m10",
            "rm12m11",
            "rtm1m12",
        #else
            "rtm1m9",
        #endif
        "rrdlm0"
      }, 
      property_tolerances = { {"w", [-1, 1]} }
   );
   
   check_property_off ( drCompareSetting, RESISTOR,
      device_names = {
        "som0", "somx0", "scm0", "scmx0", "aliasd",
        "som1", "somx1", "scm1", "scmx1",
        "som2", "somx2", "scm2", "scmx2",
        "som3", "somx3", "scm3", "scmx3",
        "som4", "somx4", "scm4", "scmx4",
        "som5", "somx5", "scm5", "scmx5",
        "som6", "somx6", "scm6", "scmx6",
        "som7", "somx7", "scm7", "scmx7",
        "som8", "somx8", "scm8", "scmx8",
        "som9", "somx9", "scm9", "scmx9",
        "sov0", "scv0", //"sovx0", "scvx0",  
        "sov1", "scv1", //"sovx1", "scvx1",
        "sov2", "scv2", //"sovx2", "scvx2",
        "sov3", "scv3", //"sovx3", "scvx3",
        "sov4", "scv4", //"sovx4", "scvx4",
        "sov5", "scv5", //"sovx5", "scvx5",
        "sov6", "scv6", //"sovx6", "scvx6",
        "sov7", "scv7", //"sovx7", "scvx7",
        "sov8", "scv8", //"sovx8", "scvx8",
        "sov9", "scv9", //"sovx9", "scvx9",
        #if _drPROCESS == 6
            "som10", "somx10", "scm10", "scmx10",
            "som11", "somx11", "scm11", "scmx11",
            "som12", "somx12", "scm12", "scmx12",
            "sov10", "scv10", //"sovx10", "scvx10",
            "sov11", "scv11", //"sovx11", "scvx11",
            "sov12", "scv12", //"sovx12", "scvx12",
        #endif
        "somtm1", "somxtm1", "scmtm1", "scmxtm1"
      } 
   );

   check_property ( drCompareSetting, RESISTOR,
       property_tolerances = { {"w", [-1, 1]},{"l", [-1, 1]} }
   );
   
   recalculate_property (
      state = drCompareSetting,
      device_type = CAPACITOR,
      device_names = {
         "mfc5porttm1", "mfc5portm12", "mfc5portm11", "mfc5portm10", 
         "mfc5portm9", "mfc5portm8", "mfc5portm7", "mfc5portm6", 
         "mfc5portm5", "mfc5portm4", "mfc5portm3", "mfc5portm2", "mfc5portm1",
         "mfc4porttm1", "mfc4portm12", "mfc4portm11", "mfc4portm10", 
         "mfc4portm9", "mfc4portm8", "mfc4portm7", "mfc4portm6", 
         "mfc4portm5", "mfc4portm4", "mfc4portm3", "mfc4portm2", "mfc4portm1",
         "mfc3porttm1", "mfc3portm12", "mfc3portm11", "mfc3portm10", 
         "mfc3portm9", "mfc3portm8", "mfc3portm7", "mfc3portm6", 
         "mfc3portm5", "mfc3portm4", "mfc3portm3", "mfc3portm2", "mfc3portm1",
         "mfc2porttm1", "mfc2portm12", "mfc2portm11", "mfc2portm10", 
         "mfc2portm9", "mfc2portm8", "mfc2portm7", "mfc2portm6", 
         "mfc2portm5", "mfc2portm4", "mfc2portm3", "mfc2portm2", "mfc2portm1",
         "mfc2portII_m5", "mfc2portII_m4", "mfc2portII_m3"
	  },
      property_function  =  "recalc_sclmfc"
   );
//   merge_parallel ( drCompareSetting,
//      device_type = CAPACITOR,
//      device_names = { 
//         "mfc5porttm1", "mfc5portm12", "mfc5portm11", "mfc5portm10", 
//         "mfc5portm9", "mfc5portm8", "mfc5portm7", "mfc5portm6", 
//         "mfc5portm5", "mfc5portm4", "mfc5portm3", "mfc5portm2", "mfc5portm1",
//         "mfc4porttm1", "mfc4portm12", "mfc4portm11", "mfc4portm10", 
//         "mfc4portm9", "mfc4portm8", "mfc4portm7", "mfc4portm6", 
//         "mfc4portm5", "mfc4portm4", "mfc4portm3", "mfc4portm2", "mfc4portm1",
//         "mfc3porttm1", "mfc3portm12", "mfc3portm11", "mfc3portm10", 
//         "mfc3portm9", "mfc3portm8", "mfc3portm7", "mfc3portm6", 
//         "mfc3portm5", "mfc3portm4", "mfc3portm3", "mfc3portm2", "mfc3portm1",
//         "mfc2porttm1", "mfc2portm12", "mfc2portm11", "mfc2portm10", 
//         "mfc2portm9", "mfc2portm8", "mfc2portm7", "mfc2portm6", 
//         "mfc2portm5", "mfc2portm4", "mfc2portm3", "mfc2portm2", "mfc2portm1"
//	   },
//	  property_functions = parallel_sclmfc_merge,
//      exclude_tolerances = {{property = "l", tolerance = [-1,1]}, 
//	                        {property = "w", tolerance = [-1,1]},
//	                        {property = "area", tolerance = [-1,1]}
//							}
//   );


   check_property ( drCompareSetting, CAPACITOR,
      device_names = {
         "mfc5porttm1", "mfc5portm12", "mfc5portm11", "mfc5portm10", 
         "mfc5portm9", "mfc5portm8", "mfc5portm7", "mfc5portm6", 
         "mfc5portm5", "mfc5portm4", "mfc5portm3", "mfc5portm2", "mfc5portm1",
         "mfc4porttm1", "mfc4portm12", "mfc4portm11", "mfc4portm10", 
         "mfc4portm9", "mfc4portm8", "mfc4portm7", "mfc4portm6", 
         "mfc4portm5", "mfc4portm4", "mfc4portm3", "mfc4portm2", "mfc4portm1",
         "mfc3porttm1", "mfc3portm12", "mfc3portm11", "mfc3portm10", 
         "mfc3portm9", "mfc3portm8", "mfc3portm7", "mfc3portm6", 
         "mfc3portm5", "mfc3portm4", "mfc3portm3", "mfc3portm2", "mfc3portm1",
         "mfc2porttm1", "mfc2portm12", "mfc2portm11", "mfc2portm10", 
         "mfc2portm9", "mfc2portm8", "mfc2portm7", "mfc2portm6", 
         "mfc2portm5", "mfc2portm4", "mfc2portm3", "mfc2portm2", "mfc2portm1",
         "mfc2portII_m5", "mfc2portII_m4", "mfc2portII_m3"
	  },
       property_tolerances = { {"w", [-0.001, 0.001]},{"l", [-0.001, 0.001]}, // {"area", [-0.001, 0.001]},
          {"MBOT", [-0.001, 0.001]},{"MTOP", [-0.001, 0.001]} 
	   }
   );
   
   check_property ( drCompareSetting, PN,
       property_tolerances = { {"pj", [-1, 1]}, {"area", [-1, 1]} }
   );
   
   check_property ( drCompareSetting, NP,
      property_tolerances = { {"pj", [-1, 1]}, {"area", [-1, 1]} }
   );

   #if (_drPROCESS == 6 || _drALLOW_DNW )
      #if (defined(_drFILTER_DDNWPW) && (_drFILTER_DDNWPW == _drYES))
         filter ( drCompareSetting,
            device_type = PN,
            device_names = { "ddnwpw" },
            filter_options = { PN_0 }
         );
	  #else
         // do not check properties for ddnwpw but check only connectivity
         check_property_off ( drCompareSetting, PN,
             device_names = { "ddnwpw" }
         );
      #endif

//     will extract ddnwpsub but will always filter it       
//      check_property_off ( drCompareSetting, NP,
//         device_names = { "ddnwpsub" }
//      );

      filter ( drCompareSetting,
         device_type = NP,
         device_names = { "ddnwpsub" },
         filter_options = { NP_0 }
      );
   #endif   

#ifndef _drRCextract
   filter ( drCompareSetting,
      device_type = NP,
      device_names = { "djnw" },
      filter_options = { NP_0 }
   );
#endif

   // check_property ( drCompareSetting, PNP,
   //   property_functions = { {"perimeter", [-1, 1]}, {"area", [-1, 1]} }
   // );
   
   #if (defined(_drICFDEVICES) )
      // icf_inductor
      check_property ( drCompareSetting,
        device_type = INDUCTOR,
        device_names = {"ind2t_scl"},
        property_tolerances = { {"nrturns", [-1, 1]}, {"coilwx", [-1, 1]}, {"coilspcx", [-1, 1]}, {"innerwx", [-1, 1]}, {"innerwy", [-1, 1]}, {"toplayer", [-1, 1]} }
      );
      // icf_mimcap
      check_property ( drCompareSetting,
         device_type = CAPACITOR,
         device_names = {"mimcap_scl"},
         property_tolerances = { {"W", [-1, 1]}, {"L1", [-1, 1]}, {"L2", [-1, 1]}, {"L3", [-1, 1]}, {"WH", [-1, 1]}, {"LH", [-1, 1]} , {"NH", [-0, 0]}}
      );
      check_property ( drCompareSetting,
         device_type = CAPACITOR,
         device_names = {"mimcap_stk_scl"},
         property_tolerances = { {"W", [-1, 1]}, {"L1", [-1, 1]}, {"L2", [-1, 1]}, {"L3", [-1, 1]}, {"WH", [-1, 1]}, {"LH", [-1, 1]} , {"NH", [-0, 0]}}
      );
   #endif

   check_property ( drCompareSetting, INDUCTOR,
      property_tolerances = { {"l", [-1, 1]}, {"w", [-1, 1]} }
   );
   
  // want all dummygates to explicitly use polydummyid 
//  filter ( drCompareSetting,
//     device_type = PMOS,
//     layout_filter_options = { PMOS_2 }
//  );
  
//  filter ( drCompareSetting,
//     device_type = NMOS,
//     layout_filter_options = { NMOS_2 }
//  );
  
// ignore diodes if _drDONTCMPDIODES is defined
//    needed when diodes were extracted but not wanted to be compared
#ifdef _drDONTCMPDIODES
   filter ( drCompareSetting,
      device_type = PN,
      layout_filter_options = { PN_0 }
   );

   filter ( drCompareSetting,
      device_type = NP,
      layout_filter_options = { NP_0 }
   );

#endif   

#if (defined(_drDONTCMPCAPS) && !defined(_drRCextract))
   // mncap and mpcap not extracted in CADNAV flow  
   filter ( drCompareSetting,
      device_type = NMOS,
      device_names = {"mncap"},
      layout_filter_options = { NMOS_0 }
   );
   
   filter ( drCompareSetting,
      device_type = PMOS,
      device_names = {"mpcap"},
      layout_filter_options = { PMOS_0 }
   );
#elif !defined(_drCADNAV) && !defined(_drRCextract)
   filter ( drCompareSetting,
      device_type = NMOS,
      device_names = {"mncap"},
      layout_filter_options = { NMOS_2, NMOS_9 },
      filter_function = "filter_nmos_11mod"
   );
   
   filter ( drCompareSetting,
      device_type = PMOS,
      device_names = {"mpcap"},
      layout_filter_options = { PMOS_2, PMOS_9 },
      filter_function = "filter_pmos_11mod"
   );
#endif // defined(_drDONTCMPCAPS) 

#if (defined(_drDONTCMPGNACS) && !defined(_drRCextract))
   // ngatednac and hvgatednac not extracted in CADNAV flow  
   filter ( drCompareSetting,
      device_type = NMOS,
      device_names = {"ngatednac"},
      layout_filter_options = { NMOS_0 }
   );
#elif  !defined(_drCADNAV) && !defined(_drRCextract) 

   filter ( drCompareSetting,
      device_type = NMOS,
      device_names = {"ngatednac"},
      filter_function = "filter_gnac"
   );

   // hvgnacs always filtered correct by contstruction and only from allowed templates   
   filter ( drCompareSetting,
      device_type = NMOS,
      device_names = {"hvngatednac"},
      layout_filter_options = { NMOS_0 }
   );
#endif  // defined(_drDONTCMPGNACS) 

#if (!defined(_drNoShortEQNodes))
   /* logic n devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = NMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"n", "nuv0", "nuv1", "nuv2", "nuv3", "nulv", "nuv1lp", "nuv2lp", "nuvt", "nlllp", "nxlllp"},  
      width_ratio_tolerance =  {_drNmosWidthRatioTolerance, RELATIVE}
   );

   /* sram n devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = NMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"nsr", "nsrlp", "nsrhvt", "nsrpg"},  
      width_ratio_tolerance =  {_drNmosWidthRatioTolerance, RELATIVE}
   );
   
   /* analog n devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = NMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"nuva", "naluv1", "naluv2", "naluv3", "nallp"},  
      width_ratio_tolerance =  {_drNmosWidthRatioTolerance, RELATIVE}
   );
   
   /* thickgate n devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = NMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"ntg", "ntgulv", "nal160" },  
      width_ratio_tolerance =  {_drNmosWidthRatioTolerance, RELATIVE}
   );
   
   /* logic p devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = PMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"p", "puv0", "puv1", "puv2", "puv3", "pulv", "puv1lp", "puv2lp", "puvt", "plllp", "pxlllp"},  
      width_ratio_tolerance =  {_drPmosWidthRatioTolerance, RELATIVE}
   );

   /* sram p devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = PMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"psr", "psrlp"},  
      width_ratio_tolerance =  {_drPmosWidthRatioTolerance, RELATIVE}
   );

   /* analog p devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = PMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"puva", "paluv1", "paluv2", "paluv3", "pallp"},  
      width_ratio_tolerance =  {_drPmosWidthRatioTolerance, RELATIVE}
   );

   /* thickgate p devices */ 
   short_equivalent_nodes ( drCompareSetting,
      device_type = PMOS,
      short_nodes = SAME_DEVICE_NAME_ONLY ,
      device_names = {"ptg", "ptgulv", "pal160"},  
      width_ratio_tolerance =  {_drPmosWidthRatioTolerance, RELATIVE}
   );
#endif // end (!defined(_drNoShortEQNodes))
 
   compare (

      state = drCompareSetting,
      schematic = schematic_lvs_db,
      layout = std_netlist,

      #if VERSION_LT(2011, 9, 1, 0)  || defined(ICV_REVERT_TO_2010_12_SP2)
         user_functions_file = $ISSRUNSETS + "/PXL/p12723_LVSfunctions.rs",
      #else
         #if defined(_drRFRV) 
            user_functions_file = search_include_path("p12723_LVSfunctionsRV.rs"),
         #else
            user_functions_file = search_include_path("p12723_LVSfunctions.rs"),
         #endif
      #endif

      #ifdef _drDeleteSchem
         #include "delete.schematic"
      #endif
      #ifdef _drDeleteLay
         #include "delete.layout"
      #endif

      schematic_top_cell = flowTopCell,
      layout_top_cell = flowTopCell,

      // push down pins in the hierarchy 
      // needed to prevent pin mods to bb 
      // from Shaffer and Jason 11/24/09 - should not have detrimental effects 
      // 
      // The only time I PDP to true is when you have multiple power and grounds that are not 
      // physically connected within the cell but the connection comes from hier up in the hierarchy.  
      // Without PDP the cell level separate PG will be reported as open and the cell exploded.  PDP 
      // will push the connection down into the cell and make one pin out of multiple. KR 
      // this may change again - true helps in mixed mode
	  // back to false needed by starrc ; changed findgatezl to pull_down_to poly nrzl  
      // had to remove findgatezl to pull_down_to due to design where it did not work
      //   starrc may now have LVS issues solution will be to explode cells where
      //   push_down_pins is needed will look like a lvs open
      // Synopsys provided new function pull_down_to_interacting ; so trying this again
	  push_down_pins = false,

      push_down_devices = false,
      memory_array_compare = false,

      #include <user_LVScompare_options>
   );
      
   
#endif  // ifndef _P1273DX_LVSCOMPARE_RS_ 
   
#endif  // if _drLVS==_dryes 
