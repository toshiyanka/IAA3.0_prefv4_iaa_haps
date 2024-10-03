// $Header: /ds/data/2647/server_vault/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/1273/p1273dx_Tdevxtr.rs.rca 1.57 Thu Sep 25 12:56:36 2014 kperrey Experimental $

// $Log: p1273dx_Tdevxtr.rs.rca $
// 
//  Revision: 1.57 Thu Sep 25 12:56:36 2014 kperrey
//  hsd 2754 ; add the handling for _drICFDEVICES
// 
//  Revision: 1.56 Wed Sep 17 09:54:18 2014 kperrey
//  hsd 2743 ; add rm0m1 as possible schematic equiv for a rm0
// 
//  Revision: 1.55 Sat Aug 16 12:52:43 2014 kperrey
//  include 1273/p1273dx_Tdevxtr_mvsw.rs to support the icf sov/scv/som/scm/aliasd devices
// 
//  Revision: 1.54 Fri Aug  8 09:33:35 2014 kperrey
//  moved duplicated code device function to common file p12723_Tdevxtrfun.rs
// 
//  Revision: 1.53 Tue Aug  5 22:23:39 2014 kperrey
//  removed reference to scm/som/scv/sov devices and via*nores since they were not program approved enhancements as per chia-hong
// 
//  Revision: 1.52 Thu Jul 31 22:48:57 2014 kperrey
//  hsd 2425 ; support for sov/sovx/scv/scvm via resistors ; updated rfreqCalcPropsStacked to handle RFRV mode change in how the rf devices are extracted and netlisted ; merging of props
// 
//  Revision: 1.51 Thu Jul 17 20:29:55 2014 kperrey
//  hsd 2567 ; create the nulv pulv devices
// 
//  Revision: 1.50 Thu Jul 17 11:32:32 2014 kperrey
//  include p1273dx_Tdevxtr_sclmfc.rs for scaleable mfc support and add sclMFCCalcProps function
// 
//  Revision: 1.49 Mon Jul  7 21:04:44 2014 kperrey
//  hsd 2425; add the scm schematic device to all metal res ; create new scmx som somx resistor devices
// 
//  Revision: 1.48 Fri Jun 20 12:25:06 2014 kperrey
//  if _drRFRV then add add prop PRE to rfreqCalcPropsStacked and rfreqCalcPropsParallel
// 
//  Revision: 1.47 Wed Apr 23 15:06:06 2014 kperrey
//  add rtm1m9c4 rtcnfm0 rgcnfm0 rpfm0 schematic support Hasanur
// 
//  Revision: 1.46 Mon Mar 31 16:21:03 2014 kperrey
//  from srimathi ; _drNoRCdevPropExt controls dual_hierarchy_extraction
// 
//  Revision: 1.45 Tue Mar 18 10:21:14 2014 kperrey
//  only support a m9(d1) or m12(d6) stack
// 
//  Revision: 1.44 Wed Mar 12 22:16:24 2014 kperrey
//  change [np]mos_rf_rcefun [np]mos_rf[par,stk]_rcefun as for parallel or stacked extraction of rf ; the processing layers are always required for the rf devices; basic _drRCextract functionality
// 
//  Revision: 1.43 Tue Mar 11 22:35:18 2014 kperrey
//  no need to write lvsmult to net file
// 
//  Revision: 1.42 Tue Mar 11 17:22:55 2014 kperrey
//  RF device support ; remove multx/multy layer reference force to 1 for layout; add new prop to RF devices lvsmult (which will be how multx/multy are actually checked)
// 
//  Revision: 1.41 Mon Mar  3 13:55:51 2014 kperrey
//  hsd 2165 ; remove poly_nores_nogate referance now just all poly_nores
// 
//  Revision: 1.40 Mon Feb 24 14:18:49 2014 kperrey
//  hsd 2146 - change xmult -> multx and ymult -> multy ; fix the includes for the *rcefun files  added rcext/ to the include so will automatically look in the rcext subdir
// 
//  Revision: 1.39 Thu Feb 20 19:58:37 2014 kperrey
//  hsd 2130; add nstk pstk devices into the extraction
// 
//  Revision: 1.38 Thu Feb 20 14:14:07 2014 kperrey
//  rfreqCalcPropsParallel and rfreqCalcPropsStacked ; set and use arraySz = multxCnt * multyCnt ; and for stacked devices the avgWidth needs to be divided by devIDCnt
// 
//  Revision: 1.37 Thu Feb 20 10:55:04 2014 kperrey
//  modified rfreqCalcPropsStacked to handle fingers and generate arraySz stlen nf instead of just doing it on the fly in save props
// 
//  Revision: 1.36 Thu Feb 20 08:14:52 2014 kperrey
//  hsd 2128 ; update the rf device functions to handle the calculations for support multy multx and change in device derivation; update the gate layer for the RF devices for new derivations ; change recognition layer for rf devices and update the processing_layer_hash for the rf devices
// 
//  Revision: 1.35 Thu Feb 13 19:23:26 2014 kperrey
//  hsd 2122 ; change property NS to STLEN
// 
//  Revision: 1.34 Wed Jan 29 16:18:44 2014 cpark3
//  updated for RC extraction relating to rf
// 
//  Revision: 1.33 Wed Jan 15 11:31:20 2014 kperrey
//  give all most devices simulation_model_name same as device name (as per Synopsys) ; make the rf devices use x_card = true
// 
//  Revision: 1.32 Sun Jan  5 16:24:41 2014 kperrey
//  add new functions rfreqCalcPropsStacked rfreqCalcPropsParallel support for parallel or stacked np/rf np/uv2rf np/tgrf np/tgulvrf
// 
//  Revision: 1.31 Wed Oct 30 08:37:00 2013 kperrey
//  hsd 1926; add device for mcr resistor
// 
//  Revision: 1.30 Mon Jun 10 09:33:23 2013 kperrey
//  add perc djnw diode support
// 
//  Revision: 1.29 Fri Mar 29 15:13:19 2013 kperrey
//  update to handle m12 resistors
// 
//  Revision: 1.28 Fri Mar 22 08:53:48 2013 kperrey
//  add nal160/pal160 device
// 
//  Revision: 1.27 Fri Jan 11 08:28:58 2013 kperrey
//  fix sch dev name for dot5 rm10m9m11 -> rm10m9tm1
// 
//  Revision: 1.26 Fri Jan  4 15:08:10 2013 kperrey
//  in sch2sch mode skip the present resistor defs and include new devsch2sch resistors ; change model to d8xmbgdiode_prim from a80bgdiode_prim when sch2sch
// 
//  Revision: 1.25 Fri Jan  4 14:18:40 2013 kperrey
//  removed an experimental rmtj resistor device
// 
//  Revision: 1.24 Fri Dec 28 12:00:07 2012 kperrey
//  added handling for NV3/PV3
// 
//  Revision: 1.23 Mon Nov 19 10:17:59 2012 kperrey
//  add in resistors that can exist in dot5 case
// 
//  Revision: 1.22 Mon Nov 12 19:17:10 2012 kperrey
//  hsd 1433 ; add 2;49/50 poly;frameSize3/4
// 
//  Revision: 1.21 Thu Oct 18 15:59:30 2012 kperrey
//  added support for rrdlm0 (rdl resistor) for tsv
// 
//  Revision: 1.20 Fri Aug 10 11:28:48 2012 kperrey
//  support for 73.6 add m10/m11
// 
//  Revision: 1.19 Mon Jul 30 23:30:03 2012 kperrey
//  hsd 1309 ; change d8xgbnesdclamptgresistor_prim to d8xgbnesdclamptgres_prim
// 
//  Revision: 1.18 Mon May 14 21:52:32 2012 kperrey
//  need to ignore mpcap/mncap during _drRCextract
// 
//  Revision: 1.17 Mon May 14 09:44:34 2012 kperrey
//  no need for ndev_bulk since __drsubstrate was redefined in *_Tcommonrce.rs
// 
//  Revision: 1.16 Wed May  2 20:20:35 2012 kperrey
//  as per richa control device layer for ntgulv bulk pin
// 
//  Revision: 1.15 Thu Apr 26 15:53:44 2012 kperrey
//  pulled properties into include file mosInclProps or gbnwellInclProps ; added defined(_drRCextractDdb) as needed
// 
//  Revision: 1.14 Wed Apr 25 08:29:15 2012 kperrey
//  added rm9m8tm1 rm8m7m9 schematic resistor equivs
// 
//  Revision: 1.13 Mon Apr  9 15:09:50 2012 kperrey
//  add hooks for rcextract/scarlet
// 
//  Revision: 1.12 Wed Mar 28 13:14:34 2012 kperrey
//  hsd 1182; add equate for rm1fm2 to rm1m0m2 (sch)
// 
//  Revision: 1.11 Mon Feb 27 14:41:55 2012 kperrey
//  hsd 621351; add support for d8xmbgdiode_prim
// 
//  Revision: 1.10 Wed Jan 18 09:14:13 2012 kperrey
//  maybe a change to how F2011.09 code handled substrate which was never really derived; now use buildsub to build __drsubrstate and globally replace substrate with __drsubstrate
// 
//  Revision: 1.9 Wed Jan 18 09:09:52 2012 kperrey
//  1272/p1272dx_Tcommon.rs
// 
//  Revision: 1.8 Thu Dec 29 09:30:54 2011 kperrey
//  hsd 1071 ; revert back to original A/B pin names for resistors
// 
//  Revision: 1.7 Thu Dec 29 09:13:23 2011 kperrey
//  change case of pin names when referenced (UC)
// 
//  Revision: 1.6 Wed Dec 28 13:08:13 2011 kperrey
//  hsd 1071; change resistor term names from A/B to io1/io2
// 
//  Revision: 1.5 Fri Oct 21 10:58:10 2011 kperrey
//  add NV/PV0 (nuv0/puv0) devices and change nal/pal to nuva/puva
// 
//  Revision: 1.4 Wed Oct 12 11:02:37 2011 kperrey
//  HSD 993; change area unit to PICO from MICRO for diode/bjt
// 
//  Revision: 1.3 Sat Oct  8 15:48:31 2011 kperrey
//  hsd 991; add support for d8xmesdclampres d8xsesdclamptgres ; assume prim name will ultimately follow naming convention d8 something
// 
//  Revision: 1.2 Thu Sep  8 13:59:14 2011 kperrey
//  remove mfcCalcAP and unused code
// 
//  Revision: 1.1 Wed Jul 13 22:39:30 2011 kperrey
//  mvfile on Wed Jul 13 22:39:30 2011 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/P1273DX_TDEVXTR.rs;1.20
// 
//  Revision: 1.20 Sun Jun 26 09:37:37 2011 oakin
//  added new 1273 devices.
// 
//  Revision: 1.19 Wed Apr  6 22:35:56 2011 kperrey
//  updates from scarlet from Koustav
// 
//  Revision: 1.18 Tue Mar 22 16:25:34 2011 kperrey
//  added rtcnfm1 diffcon_res - but will probably be blackboxed anyway
// 
//  Revision: 1.17 Mon Mar 14 09:06:28 2011 kperrey
//  add remove_dangling_ports=NONE for 2010.12.0.0 since no longer command line option
// 
//  Revision: 1.16 Tue Jan 11 12:26:58 2011 kperrey
//  change c8xlbgdiodehvm1_prim schematic to c8xbgdiode_prim model - as per avner
// 
//  Revision: 1.15 Fri Dec 17 13:02:08 2010 kperrey
//  change prim name c8xlesdclampres_prim -> c8xgbnesdclampresistor_prim as per Bruce
// 
//  Revision: 1.14 Mon Dec 13 15:43:39 2010 kperrey
//  have only 1 trace/lvs flow - but still do soft connect (alt) opens - but netlist once (std) ; remove trcview if/else and make unique soft/netlist connectivity models
// 
//  Revision: 1.13 Tue Dec  7 14:37:21 2010 kperrey
//  added devices n/paluv1/2 , used pal as template
// 
//  Revision: 1.12 Mon Nov 29 09:42:47 2010 kperrey
//  updates from Bhattacharya, Koustav for _drRCextract and dev_layer for BULK for n devices
// 
//  Revision: 1.11 Tue Oct 26 14:36:01 2010 kperrey
//  add conditionals for RC extract ; dual_hierarchy device matrix; additional device properties ; different device function and support layers ; write spice
// 
//  Revision: 1.10 Fri Oct 15 15:05:49 2010 kperrey
//  updated b8/c8 names to latest spec from S Zickel
// 
//  Revision: 1.9 Tue Oct 12 09:28:03 2010 kperrey
//  updated to reflect new/renamed devices and layers ; remove DR_ENABLE_ALTLE since altle no longer exists
// 
//  Revision: 1.8 Mon Sep 20 16:09:03 2010 kperrey
//  v0/mh/vh namechange vc/m0/v0
// 
//  Revision: 1.7 Thu Aug 26 21:44:47 2010 kperrey
//  add full-time support thru M11
// 
//  Revision: 1.6 Thu Aug 12 09:43:15 2010 kperrey
//  change how diodes are ignores for LVS - will always extract when standard
// 
//  Revision: 1.5 Wed Aug 11 14:15:20 2010 kperrey
//  change rbgnwell cells to expected 1272 c8 lib name
// 
//  Revision: 1.4 Fri Aug  6 14:10:57 2010 kperrey
//  make diode extraction also dependent upon PDS_DONTCMPDIODES being undefined - for when sn is sch based
// 
//  Revision: 1.3 Wed Aug  4 23:23:03 2010 kperrey
//  added support for djn_esd and djp_esd
// 
//  Revision: 1.2 Thu Jul 29 10:07:57 2010 kperrey
//  change reference layer for nlluvt/plluvt to altleidll since always drawn when gate formed instead of uvt layer ; fixed typo in puvt reference needs to be p not n
// 
//  Revision: 1.1 Thu Jul 22 14:03:32 2010 kperrey
//  mvfile on Thu Jul 22 14:03:32 2010 by user kperrey.
//  Originated from sync://ptdls041.ra.intel.com:2647/Projects/drwork/x12dev_drwork/rst/x12dev_drwork_rst/PXL/p1272_Tdevxtr.rs;1.4
// 
//  Revision: 1.4 Thu Jul 22 14:03:20 2010 kperrey
//  update 1272/12723 name change ; removed tcn res ; add rm0fm1 res
// 
//  Revision: 1.3 Thu Jun 24 23:19:10 2010 kperrey
//  add 1271 and b8x devices
// 
//  Revision: 1.2 Wed Jun 23 20:38:36 2010 kperrey
//  remove inductor/cap mfc cap devices since all bb
// 
//  Revision: 1.1 Tue May 25 15:04:40 2010 kperrey
//  from p1270
// 
//
//  converted from p1270_Tdevxtr.rs

#ifndef _P1273DX_TDEVXTR_RS_
#define _P1273DX_TDEVXTR_RS_

#if defined(_drRFRV)
   #define rfMergeParallel false
#else
   #define rfMergeParallel true
#endif

trace_devMtrx = init_device_matrix(
   txt_trace_netlist_connect
   #if( defined(_drRCextract) && !defined(_drNoRCdevPropExt) && defined(_drRCextractAnnotate) )
      , dual_hierarchy_extraction = true
   #endif
);

// devices 

// nstk/pstk
nmos(
   matrix = trace_devMtrx,
   device_name = "nstk",
   simulation_model_name = "nstk",
   drain = nsd, 
   gate = mos_ngate_stk, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nstk",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nstk", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "pstk",
   simulation_model_name = "pstk",
   drain = psd,
   gate = mos_pgate_stk,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "pstk",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "pstk", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// nuva/puva
nmos(
   matrix = trace_devMtrx,
   device_name = "nuva",
   simulation_model_name = "nuva",
   drain = nsd, 
   gate = mos_ngate_a, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuva",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuva", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "puva",
   simulation_model_name = "puva",
   drain = psd,
   gate = mos_pgate_a,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puva",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puva", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/paluv1
nmos(
   matrix = trace_devMtrx,
   device_name = "naluv1",
   simulation_model_name = "naluv1",
   drain = nsd, 
   gate = mos_ngate_av1, 
   source = nsd, 
   optional_pins = { {
         device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "naluv1",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "naluv1", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "paluv1",
   simulation_model_name = "paluv1",
   drain = psd,
   gate = mos_pgate_av1,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "paluv1",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "paluv1", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/paluv2
nmos(
   matrix = trace_devMtrx,
   device_name = "naluv2",
   simulation_model_name = "naluv2",
   drain = nsd, 
   gate = mos_ngate_av2, 
   source = nsd, 
   optional_pins = { {
         device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "naluv2",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "naluv2", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "paluv2",
   simulation_model_name = "paluv2",
   drain = psd,
   gate = mos_pgate_av2,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "paluv2",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "paluv2", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/paluv3
nmos(
   matrix = trace_devMtrx,
   device_name = "naluv3",
   simulation_model_name = "naluv3",
   drain = nsd, 
   gate = mos_ngate_av3, 
   source = nsd, 
   optional_pins = { {
         device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "naluv3",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "naluv3", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "paluv3",
   simulation_model_name = "paluv3",
   drain = psd,
   gate = mos_pgate_av3,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "paluv3",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "paluv3", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


// n/pallnp
nmos(
   matrix = trace_devMtrx,
   device_name = "nallp",
   simulation_model_name = "nallp",
   drain = nsd, 
   gate = mos_ngate_alp, 
   source = nsd, 
   optional_pins = { {
         device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nallp",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nallp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "pallp",
   simulation_model_name = "pallp",
   drain = psd,
   gate = mos_pgate_alp,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "pallp",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "pallp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/puv0
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv0",
   simulation_model_name = "nuv0",
   drain = nsd, 
   gate = mos_ngate_v0, 
   source = nsd, 
   optional_pins = { {
         device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuv0",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv0", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "puv0",
   simulation_model_name = "puv0",
   drain = psd,
   gate = mos_pgate_v0,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puv0",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv0", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/puv1
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv1",
   simulation_model_name = "nuv1",
   drain = nsd, 
   gate = mos_ngate_v1, 
   source = nsd, 
   optional_pins = { {
         device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuv1",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv1", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "puv1",
   simulation_model_name = "puv1",
   drain = psd,
   gate = mos_pgate_v1,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puv1",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv1", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/puv2
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv2",
   simulation_model_name = "nuv2",
   drain = nsd, 
   gate = mos_ngate_v2, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuv2",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv2", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "puv2",
   simulation_model_name = "puv2",
   drain = psd,
   gate = mos_pgate_v2,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puv2",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv2", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/puv3
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv3",
   simulation_model_name = "nuv3",
   drain = nsd, 
   gate = mos_ngate_v3, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuv3",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv3", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "puv3",
   simulation_model_name = "puv3",
   drain = psd,
   gate = mos_pgate_v3,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puv3",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv3", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/pulv
nmos(
   matrix = trace_devMtrx,
   device_name = "nulv",
   simulation_model_name = "nulv",
   drain = nsd, 
   gate = mos_ngate_ulv1, 
   source = nsd, 
   optional_pins = { {
         device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nulv",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nulv", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "pulv",
   simulation_model_name = "pulv",
   drain = psd,
   gate = mos_pgate_ulv1,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "pulv",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "pulv", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


// n/puv1lp
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv1lp",
   simulation_model_name = "nuv1lp",
   drain = nsd, 
   gate = mos_ngate_v1lp, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuv1lp",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv1lp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "puv1lp",
   simulation_model_name = "puv1lp",
   drain = psd,
   gate = mos_pgate_v1lp,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puv1lp",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv1lp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/puv2lp
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv2lp",
   simulation_model_name = "nuv2lp",
   drain = nsd, 
   gate = mos_ngate_v2lp, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuv2lp",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv2lp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "puv2lp",
   simulation_model_name = "puv2lp",
   drain = psd,
   gate = mos_pgate_v2lp,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puv2lp",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv2lp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// nuvt/puvt
nmos(
   matrix = trace_devMtrx,
   device_name = "nuvt",
   simulation_model_name = "nuvt",
   drain = nsd,
   gate = mos_ngate_uvt, 
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = n_altvtid, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nuvt",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
#if _drENABLE_UVT == _drYES
      {device_name = "nuvt", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
#else // drENABLE_UVT == _drNO
      {device_name = "_drnuvt", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
#endif
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "puvt",
   simulation_model_name = "puvt",
   drain = psd,
   gate = mos_pgate_uvt,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = p_altvtid, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "puvt",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
#if _drENABLE_UVT == _drYES
      {device_name = "puvt", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
#else // _drENABLE_UVT == _drNO
      {device_name = "_drpuvt", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
#endif
   },
   source_drain_config = {NORMAL} //optional
);

// nsrhvt/nsrpg
nmos(
   matrix = trace_devMtrx,
   device_name = "nsrhvt",
   simulation_model_name = "nsrhvt",
   drain = nsd, 
   gate = mos_ngate_shvt,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nsrhvt",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nsrhvt", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "nsrpg",
   simulation_model_name = "nsrpg",
   drain = nsd, 
   gate = mos_ngate_spg,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nsrpg",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nsrpg", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// nsr/psr
nmos(
   matrix = trace_devMtrx,
   device_name = "nsr",
   simulation_model_name = "nsr",
   drain = nsd,
   gate = mos_ngate_s,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nsr",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nsr", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "psr",
   simulation_model_name = "psr",
   drain = psd,
   gate = mos_pgate_s,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "psr",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "psr", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/psrlp
nmos(
   matrix = trace_devMtrx,
   device_name = "nsrlp",
   simulation_model_name = "nsrlp",
  drain = nsd,
   gate = mos_ngate_slp,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nsrlp",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nsrlp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "psrlp",
   simulation_model_name = "psrlp",
   drain = psd,
   gate = mos_pgate_slp,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "psrlp",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "psrlp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/pxlllp
nmos(
   matrix = trace_devMtrx,
   device_name = "nxlllp",
   simulation_model_name = "nxlllp",
   drain = nsd,
   gate = mos_ngate_x,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nxlllp",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nxlllp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "pxlllp",
   simulation_model_name = "pxlllp",
   drain = psd,
   gate = mos_pgate_x,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "pxlllp",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "pxlllp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/plllp
nmos(
   matrix = trace_devMtrx,
   device_name = "nlllp",
   simulation_model_name = "nlllp",
   drain = nsd,
   gate = mos_ngate_lllp,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nlllp",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nlllp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "plllp",
   simulation_model_name = "plllp",
   drain = psd,
   gate = mos_pgate_lllp,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "plllp",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "plllp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);
// // ndrxlllp
// nmos(
//    matrix = trace_devMtrx,
//    device_name = "ndrxlllp",
//    simulation_model_name = "ndrxlllp",
//    drain = nsd,
//    gate = mos_ngate_xedr,
//    source = nsd,
//    optional_pins = { {
//       device_layer = __drsubstrate,
//       pin_name = "BULK",
//       pin_type = BULK,
//       pin_compared = true
//    }},
//    reference_layer = POLY, //optional
//    #ifndef _drRCextract  
//       property_function = mosCalcLW,
//    #else
//       #ifdef _drRCextractAnnotate
//          property_function = mosCalcASProximity,
//          proximity_layers = {{active,-1}, {POLY,0.18}, {ngateZL,0.18}, {all_sd,0.36}},
//       #else
//          recognition_layer = active,
//          processing_layers = { POLY, ngateZL, all_sd },
//          property_function = mosCalcAS,
//       #endif
//       unique_identifier = "ndrxlllp",
//    #endif 
//    properties = {
//       #include <mosInclProps>
//    }, //optional
//    schematic_devices = {
//       {device_name = "ndrxlllp", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
//    },
//    source_drain_config = {NORMAL} //optional
// );

// n/ptg
nmos(
   matrix = trace_devMtrx,
   device_name = "ntg",
   simulation_model_name = "ntg",
   drain = nsd, 
   gate = mos_ngate_tg, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "ntg",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ntg", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "ptg",
   simulation_model_name = "ptg",
   drain = psd,
   gate = mos_pgate_tg,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "ptg",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ptg", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// nal160/pal160
nmos(
   matrix = trace_devMtrx,
   device_name = "nal160",
   simulation_model_name = "nal160",
   drain = nsd, 
   gate = mos_ngate_tg160, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "nal160",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nal160", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


pmos(
   matrix = trace_devMtrx,
   device_name = "pal160",
   simulation_model_name = "pal160",
   drain = psd,
   gate = mos_pgate_tg160,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "pal160",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "pal160", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// n/ptgmv
// nmos(
//    matrix = trace_devMtrx,
//    device_name = "ntgmv",
//    simulation_model_name = "ntgmv",
//    drain = nsd, 
//    gate = mos_ngate_tgmv, 
//    source = nsd, 
//    optional_pins = { {
//       device_layer = __drsubstrate,
//       pin_name = "BULK",
//       pin_type = BULK,
//       pin_compared = true
//    }},
//    reference_layer = POLY, //optional
//    #ifndef _drRCextract  
//       property_function = mosCalcLW,
//    #else
//       #ifdef _drRCextractAnnotate
//          property_function = mosCalcASProximity,
//          proximity_layers = {{active,-1}, {POLY,0.18}, {ngateZL,0.18}, {all_sd,0.36}},
//       #else
//          recognition_layer = active,
//          processing_layers = { POLY, ngateZL, all_sd },
//          property_function = mosCalcAS,
//       #endif
//       unique_identifier = "ntgmv",
//    #endif 
//    properties = {
//      #include <mosInclProps>
//    }, //optional
//    schematic_devices = {
//       {device_name = "ntgmv", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
//    },
//    source_drain_config = {NORMAL} //optional
// );


// pmos(
//    matrix = trace_devMtrx,
//    device_name = "ptgmv",
//    simulation_model_name = "ptgmv",
//    drain = psd,
//    gate = mos_pgate_tgmv,
//    source = psd,
//    optional_pins = { {
//       device_layer = nwell_nores,
//       pin_name = "BULK",
//       pin_type = BULK,
//       pin_compared = true
//    }},
//    reference_layer = POLY, //optional
//    #ifndef _drRCextract
//       property_function = mosCalcLW,
//    #else
//       #ifdef _drRCextractAnnotate
//          property_function = mosCalcASProximity,
//          proximity_layers = {{active,-1}, {POLY,0.18}, {pgateZL,0.18}, {all_sd,0.36}},
//       #else
//          recognition_layer = active,
//          processing_layers = { POLY, pgateZL, all_sd },
//          property_function = mosCalcAS,
//       #endif
//       unique_identifier = "ptgmv",
//    #endif
//    properties = {
//       #include <mosInclProps>
//    }, //optional
//    schematic_devices = {
//       {device_name = "ptgmv", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
//    },
//    source_drain_config = {NORMAL} //optional
// );
// 

// n/ptgulv
nmos(
   matrix = trace_devMtrx,
   device_name = "ntgulv",
   simulation_model_name = "ntgulv",
   drain = nsd,
   gate = mos_ngate_tgulv,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "ntgulv",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ntgulv", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "ptgulv",
   simulation_model_name = "ptgulv",
   drain = psd,
   gate = mos_pgate_tgulv,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "ptgulv",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ptgulv", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);



// n/p 
nmos(
   matrix = trace_devMtrx,
   device_name = "n",
   simulation_model_name = "n",
   drain = nsd, 
   gate = mos_ngate, 
   source = nsd, 
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract  
      property_function = mosCalcLW,
   #else
      #include <rcext/nmos_rcefun>
      unique_identifier = "n",
   #endif 
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
#if _drENABLE_UVT == _drYES
      {device_name = "n", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
#else  // _drENABLE_UVT == _drNO 
      {device_name = "n", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}},
      {device_name = "nuvt", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}},
#endif
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "p",
   simulation_model_name = "p",
   drain = psd,
   gate = mos_pgate,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifndef _drRCextract
      property_function = mosCalcLW,
   #else
      #include <rcext/pmos_rcefun>
      unique_identifier = "p",
   #endif
   properties = {
     #include <mosInclProps>
   }, //optional
   schematic_devices = {
#if _drENABLE_UVT == _drYES
      {device_name = "p", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
#else  // _drENABLE_UVT == _drNO
      {device_name = "p", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}},
      {device_name = "puvt", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}},
#endif
   },
   source_drain_config = {NORMAL} //optional
);

// RF PARALLEL
// n/puv2rf
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv2rf",
   simulation_model_name = "nuv2rf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_par_v2,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = { 
      "base" => {NDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/nmos_rfpar_rcefun>
      unique_identifier = "nuv2rf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv2rf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "puv2rf",
   simulation_model_name = "puv2rf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_par_v2,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {PDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/pmos_rfpar_rcefun>
      unique_identifier = "puv2rf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv2rf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// n/prf
nmos(
   matrix = trace_devMtrx,
   device_name = "nrf",
   simulation_model_name = "nrf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_par,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {NDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/nmos_rfpar_rcefun>
      unique_identifier = "nrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "prf",
   simulation_model_name = "prf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_par,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {PDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/pmos_rfpar_rcefun>
      unique_identifier = "prf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "prf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// n/ptgulvrf

nmos(
   matrix = trace_devMtrx,
   device_name = "ntgulvrf",
   simulation_model_name = "ntgulvrf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_par_tgulv,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {NDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/nmos_rfpar_rcefun>
      unique_identifier = "ntgulvrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ntgulvrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "ptgulvrf",
   simulation_model_name = "ptgulvrf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_par_tgulv,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {PDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/pmos_rfpar_rcefun>
      unique_identifier = "ptgulvrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ptgulvrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// n/ptgrf
nmos(
   matrix = trace_devMtrx,
   device_name = "ntgrf",
   simulation_model_name = "ntgrf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_par_tg,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {NDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/nmos_rfpar_rcefun>
      unique_identifier = "ntgrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ntgrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "ptgrf",
   simulation_model_name = "ptgrf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_par_tg,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {PDIFF}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsParallel,
   #else
      #include <rcext/pmos_rfpar_rcefun>
      unique_identifier = "ptgrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ptgrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// RF STACKED
// n/puv2rf
nmos(
   matrix = trace_devMtrx,
   device_name = "nuv2rf",
   simulation_model_name = "nuv2rf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_stk_v2,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {NDIFF},
      "gateStack" => {all_nrfreq_stk_prop},
      "devID" => {rfreq_ngate_stk_v2} 
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/nmos_rfstk_rcefun>
      unique_identifier = "nuv2rf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nuv2rf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "puv2rf",
   simulation_model_name = "puv2rf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_stk_v2,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {PDIFF},
      "gateStack" => {all_prfreq_stk_prop},
      "devID" => {rfreq_pgate_stk_v2}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/pmos_rfstk_rcefun>
      unique_identifier = "puv2rf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "puv2rf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// n/prf
nmos(
   matrix = trace_devMtrx,
   device_name = "nrf",
   simulation_model_name = "nrf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_stk,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE, 
   processing_layer_hash = {
      "base" => {NDIFF},
      "gateStack" => {all_nrfreq_stk_prop},
      "devID" => {rfreq_ngate_stk}
    },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/nmos_rfstk_rcefun>
      unique_identifier = "nrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "nrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "prf",
   simulation_model_name = "prf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_stk,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {PDIFF},
      "gateStack" => {all_prfreq_stk_prop},
      "devID" => {rfreq_pgate_stk}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/pmos_rfstk_rcefun>
      unique_identifier = "prf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "prf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// n/ptgulvrf
nmos(
   matrix = trace_devMtrx,
   device_name = "ntgulvrf",
   simulation_model_name = "ntgulvrf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_stk_tgulv,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE, 
   processing_layer_hash = {
      "base" => {NDIFF},
      "gateStack" => {all_nrfreq_stk_prop},
      "devID" => {rfreq_ngate_stk_tgulv}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/nmos_rfstk_rcefun>
      unique_identifier = "ntgulvrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ntgulvrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "ptgulvrf",
   simulation_model_name = "ptgulvrf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_stk_tgulv,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {PDIFF},
      "gateStack" => {all_prfreq_stk_prop},
      "devID" => {rfreq_pgate_stk_tgulv}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/pmos_rfstk_rcefun>
      unique_identifier = "ptgulvrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ptgulvrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// n/ptgrf
nmos(
   matrix = trace_devMtrx,
   device_name = "ntgrf",
   simulation_model_name = "ntgrf",
   x_card = true,
   drain = nsd,
   gate = rfreq_ngate_stk_tg,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
      "base" => {NDIFF},
      "gateStack" => {all_nrfreq_stk_prop},
      "devID" => {rfreq_ngate_stk_tg}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/nmos_rfstk_rcefun>
      unique_identifier = "ntgrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ntgrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "ptgrf",
   simulation_model_name = "ptgrf",
   x_card = true,
   drain = psd,
   gate = rfreq_pgate_stk_tg,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   recognition_layer = RFREQDEVTYPE,
   processing_layer_hash = {
       "base" => {PDIFF},
       "gateStack" => {all_prfreq_stk_prop},
       "devID" => {rfreq_pgate_stk_tg}
   },
   #ifndef _drRCextract  
      property_function = rfreqCalcPropsStacked,
   #else
      #include <rcext/pmos_rfstk_rcefun>
      unique_identifier = "ptgrf",
   #endif 
   properties = {
	   #include <mosrfInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "ptgrf", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   merge_parallel = rfMergeParallel,
   source_drain_config = {NORMAL} //optional
);

// karl

/* vdmos device extraction */
nmos(
   matrix = trace_devMtrx,
   device_name = "m",
   simulation_model_name = "m",
   drain = vddrain,
   gate = vdgate,
   source = vdsource,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   property_function = mosCalcLW,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, //optional
   schematic_devices = {
      {device_name = "m", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);


/* vsdmos device extraction */
nmos(
   matrix = trace_devMtrx,
   device_name = "vs",
   simulation_model_name = "vs",
   drain = vsdsrc,
   gate = vsdgate,
   source = vsdsrc,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   property_function = mosCalcLW,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, //optional
   schematic_devices = {
      {device_name = "vs", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

/* gated nac devices extraction */
//  skip device creation for gatednac since these should all be filtered 
#if !defined(_drCADNAV) && !defined(_drRCextract)
nmos(
   matrix = trace_devMtrx,
   device_name = "ngatednac",
   drain = nsd,
   gate = gnac_ngate,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   property_function = mosCalcLW,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, //optional
   schematic_devices = {
      {device_name = "ngatednac", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "hvngatednac",
   drain = nsd,
   gate = hvgnac_ngate,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   property_function = mosCalcLW,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, //optional
   schematic_devices = {
      {device_name = "hvngatednac", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

#endif // !defined(_drCADNAV) && !defined(_drRCextract)

// diodes 
// extract diodes if not alternate && _drDONTCMPDIODES is undefined
np (
   matrix = trace_devMtrx,
   device_name = "djn",
   device_body = nac_cathode,
   anode = nac_anode,
   cathode = nac_cathode,
   properties = {
     {name = "pj", type = DOUBLE, scale = MICRO},
     {name = "area", type = DOUBLE, scale = PICO}
   },
   merge_parallel = false, //optional
   bulk_relationship = INTERACT, //optional
   schematic_devices = {{device_name = "djn", anode = "ANODE", cathode = "CATHODE" }},
   extract_shorted_device = true, //optional
   processing_mode = HIERARCHICAL //optional
);

pn (
   matrix = trace_devMtrx,
   device_name = "djp",
   device_body = anode_nbjt,
   anode = anode_nbjt,
   cathode = cathode,
   properties = {
     {name = "pj", type = DOUBLE, scale = MICRO},
     {name = "area", type = DOUBLE, scale = PICO}
   },
   merge_parallel = false, //optional
   bulk_relationship = INTERACT, //optional
   schematic_devices = {{device_name = "djp", anode = "ANODE", cathode = "CATHODE" }},
   extract_shorted_device = true, //optional
   processing_mode = HIERARCHICAL //optional
);

// new esd diodes
np (
   matrix = trace_devMtrx,
   device_name = "djn_esd",
   device_body = nac_cathode_esd,
   anode = nac_anode,
   cathode = nac_cathode_esd,
   properties = {
     {name = "pj", type = DOUBLE, scale = MICRO},
     {name = "area", type = DOUBLE, scale = PICO}
   },
   merge_parallel = false, //optional
   bulk_relationship = INTERACT, //optional
   schematic_devices = {
     {device_name = "djn_esd", anode = "ANODE", cathode = "CATHODE" }
   },
   extract_shorted_device = true, //optional
   processing_mode = HIERARCHICAL //optional
);

pn (
   matrix = trace_devMtrx,
   device_name = "djp_esd",
   device_body = anode_nbjt_esd,
   anode = anode_nbjt_esd,
   cathode = cathode,
   properties = {
     {name = "pj", type = DOUBLE, scale = MICRO},
     {name = "area", type = DOUBLE, scale = PICO}
   },
   merge_parallel = false, //optional
   bulk_relationship = INTERACT, //optional
   schematic_devices = {
     {device_name = "djp_esd", anode = "ANODE", cathode = "CATHODE" }
   },
   extract_shorted_device = true, //optional
   processing_mode = HIERARCHICAL //optional
);

// perc djnw diode

#ifndef _drRCextract
np (
   matrix = trace_devMtrx,
   device_name = "djnw",
   device_body = djnw_cathode,
   anode = djnw_anode,
   cathode = djnw_cathode,
   processing_layer_hash = { "deepnwell" => {NWELL} },
   property_function = npDNWCalcAP,
   properties = {
      {name = "pj", type = DOUBLE, scale = MICRO},
      {name = "area", type = DOUBLE, scale = PICO}
   },
   merge_parallel = false, //optional
   bulk_relationship = INTERACT, //optional
   schematic_devices = {{device_name = "djnw", anode = "ANODE", cathode = "CATHODE" }},
   extract_shorted_device = true, //optional
   reference_layer = NWELL, //optional
   processing_mode = HIERARCHICAL //optional
);
#endif

// pnp diodes
pnp (
matrix = trace_devMtrx,
#if _drTRCVIEW == _drsch2sch
   device_name = "d8xmbgdiode_prim",
#else
   device_name = "bjtdiode",
#endif
   collector = bjt_coll,
   base = bjt_base,
   emitter = bjt_emit,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   recognition_layer = us_bjt_cell, //optional
   properties = {
//      {name = "ep", type = DOUBLE, scale = MICRO},
//      {name = "ea", type = DOUBLE, scale = MICRO},
//      {name = "bp", type = DOUBLE, scale = MICRO},
//      {name = "ba", type = DOUBLE, scale = MICRO},
      {name = "conf", type = STRING, scale = NONE}
//      {name = "p1", type = DOUBLE, scale = MICRO}
   }, //optional
   property_function = bgdiodeCalcProps, //optional
   merge_parallel = false, //optional
   bulk_relationship = ENCLOSE , //optional
   schematic_devices = {
#if _drTRCVIEW == _drlay2lay
      {device_name = "bjtdiode", collector = "COLL", base = "BASE", emitter = "EMIT", optional_pins = {"BULK"}}
#else
      {device_name = "a80bgdiode_prim", collector = "COLL", base = "BASE", emitter = "EMIT", optional_pins = {"BULK"}},
      {device_name = "d8xmbgdiode_prim", collector = "COLL", base = "BASE", emitter = "EMIT", optional_pins = {"BULK"}},
      {device_name = "c8xbgdiode_prim", collector = "COLL", base = "BASE", emitter = "EMIT", optional_pins = {"BULK"}}
#endif
   }, //optional
   body_position = EMITTER //optional
);


// I dont think these are used any more
pnp (
matrix = trace_devMtrx,
   device_name = "ddrbjtdiode",
   collector = bjt_coll_2,
   base = bjt_base_2,
   emitter = bjt_emit_2,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   recognition_layer = us_bjt_cell_2, //optional
   properties = {
      {name = "area", type = DOUBLE, scale = PICO},
      {name = "perimeter", type = DOUBLE, scale = MICRO}
   }, //optional
   merge_parallel = false, //optional
   bulk_relationship = ENCLOSE , //optional
   schematic_devices = {
#if _drTRCVIEW == _drlay2lay
      {device_name = "ddrbjtdiode", collector = "COLL", base = "BASE", emitter = "EMIT", optional_pins = {"BULK"}}
#else
      {device_name = "a80ddrdiode2_prim", collector = "COLL", base = "BASE", emitter = "EMIT", optional_pins = {"BULK"}}
#endif
   }, //optional
   body_position = EMITTER //optional
);

pnp (
matrix = trace_devMtrx,
   device_name = "ddr1bjtdiode",
   collector = bjt_coll_1,
   base = bjt_base_1,
   emitter = bjt_emit_1,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   recognition_layer = us_bjt_cell_1, //optional
   properties = {
      {name = "area", type = DOUBLE, scale = PICO},
      {name = "perimeter", type = DOUBLE, scale = MICRO}
   }, //optional
   merge_parallel = false , //optional
   bulk_relationship = ENCLOSE , //optional
   schematic_devices = {
      {device_name = "a80ddrdiode2_prim", collector = "COLL", base = "BASE", emitter = "EMIT", optional_pins = {"BULK"}}
   }, //optional
   body_position = EMITTER //optional
);


/* gate-blocked 4-terminal nwell resistor extraction */
nmos(
   matrix = trace_devMtrx,
   device_name = "c8xlrgbnevm2k1p4_prim",
   simulation_model_name = "c8xlrgbnevm2k1p4_prim",
   drain = npickup,
   gate = esdng_c8xlrgbnevm2k1p4_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "c8xrgbnk1p4_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "c8xlrgbnevm2k1p1_prim",
   simulation_model_name = "c8xlrgbnevm2k1p1_prim",
   drain = npickup,
   gate = esdng_c8xlrgbnevm2k1p1_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "esdng_c8xrgbnk1p1_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "c8xlrgbnevm2k7p5_prim",
   simulation_model_name = "c8xlrgbnevm2k7p5_prim",
   drain = npickup,
   gate = esdng_c8xlrgbnevm2k7p5_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "c8xrgbnk7p5_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "c8xlrgbnevm2k3p5_prim",
   simulation_model_name = "c8xlrgbnevm2k3p5_prim",
   drain = npickup,
   gate = esdng_c8xlrgbnevm2k3p5_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "c8xrgbnk3p5_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "c8xlrgbnevm2k0p4_prim",
   simulation_model_name = "c8xlrgbnevm2k0p4_prim",
   drain = npickup,
   gate = esdng_c8xlrgbnevm2k0p4_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "c8xrgbnk0p4_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "c8xgbnesdclampresistor_prim",
   simulation_model_name = "c8xgbnesdclampresistor_prim",
   drain = npickup,
   gate = esdng_c8xlesdclampres_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "c8xgbnesdclampresistor_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "d8xgbnesdclampresistor_prim",
   simulation_model_name = "d8xgbnesdclampresistor_prim",
   drain = npickup,
   gate = esdng_d8xlesdclampres_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "d8xgbnesdclampresistor_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

nmos(
   matrix = trace_devMtrx,
   device_name = "d8xgbnesdclamptgres_prim",
   simulation_model_name = "d8xgbnesdclamptgres_prim",
   drain = npickup,
   gate = esdng_d8xlesdclamptgres_prim,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   #ifdef _drRCextract  
         #include <rcext/gbnwell_rcefun>
   #endif
   properties = {
     #include <gbnwellInclProps>
   }, //optional
   schematic_devices = {
      {device_name = "d8xgbnesdclamptgres_prim", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

/**gbnwell**/
nmos(
   matrix = trace_devMtrx,
   device_name = "gbnwell",
   simulation_model_name = "gbnwell",
   drain = npickup,
   gate = esd_ngate,
   source = npickup,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, //optional
   schematic_devices = {
      {device_name = "gbnwell", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

// define resistor devices 
// tcn gcn resistors 
genRes2TermProps:function (void) returning void {
    resWidth = (res_width_term_a() + res_width_term_b()) / 2.0 ;
    resLength =  (res_area()) / resWidth ;
    dev_save_double_properties({{"w", resWidth}});
    dev_save_double_properties({{"l", resLength}});
};

#if (_drTRCVIEW != _drsch2sch)
resistor (
   matrix = trace_devMtrx,
   device_name = "rgcnfm1", // carmel is different
   device_body = polycon_res_cl,
   terminal_a = polycon_nores,
   terminal_b = polycon_nores,
   reference_layer = POLYCONRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rgcnfm1", terminal_a = "A", terminal_b = "B"},
      {device_name = "rgcnfm0", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rtcnfm1", // carmel is different
   device_body = diffcon_res_cl,
   terminal_a = diffcon_nores,
   terminal_b = diffcon_nores,
   reference_layer = DIFFCONRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rtcnfm1", terminal_a = "A", terminal_b = "B"},
      {device_name = "rtcnfm0", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// poly metal resistors
resistor (
   matrix = trace_devMtrx,
   device_name = "rp",
   device_body = poly_res_cl,
   terminal_a = poly_nores,
   terminal_b = poly_nores,
   reference_layer = PRES_ID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rp", terminal_a = "A", terminal_b = "B"},
      {device_name = "rpfm0", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "resdw",
   device_body = nwellesd_res_cl,
   terminal_a = nwellesd_nores,
   terminal_b = nwellesd_nores,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {{device_name = "resdw", terminal_a = "A", terminal_b = "B"}},
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rnwell",
   device_body = nwell_res_cl,
   terminal_a = nwell_nores,
   terminal_b = nwell_nores,
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {{device_name = "rnwell", terminal_a = "A", terminal_b = "B"}},
   resistor_value = 1.0 //optional
);

// M0 
// rm0
resistor (
   matrix = trace_devMtrx,
   device_name = "rm0fm1", 
   device_body = metal0res_cl,
   terminal_a = metal0nores,
   terminal_b = metal0nores,
   reference_layer = MET0RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm0m1", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm0fm1", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm0", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M1 
// rm1
resistor (
   matrix = trace_devMtrx,
   device_name = "rm1fm2",
   device_body = metal1res_cl,
   terminal_a = metal1nores,
   terminal_b = metal1nores,
   reference_layer = MET1RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm1fm2", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm1m0m2", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm1", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M2 
// rm2
resistor (
   matrix = trace_devMtrx,
   device_name = "rm2m1m3",
   device_body = metal2res_cl,
   terminal_a = metal2nores,
   terminal_b = metal2nores,
   reference_layer = MET2RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm2m1m3", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm2m1", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm2", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M3 
// rm3
resistor (
   matrix = trace_devMtrx,
   device_name = "rm3m2m4",
   device_body = metal3res_cl,
   terminal_a = metal3nores,
   terminal_b = metal3nores,
   reference_layer = MET3RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm3m2m4", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm3m2", terminal_a = "A", terminal_b = "B"},   // needed by x10
      {device_name = "rm3", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M4 
// rm4
resistor (
   matrix = trace_devMtrx,
   device_name = "rm4m3m5",
   device_body = metal4res_cl,
   terminal_a = metal4nores,
   terminal_b = metal4nores,
   reference_layer = MET4RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm4m3m5", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm4m3", terminal_a = "A", terminal_b = "B"}, // for x10
      {device_name = "rm4", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M5 
// rm5
resistor (
   matrix = trace_devMtrx,
   device_name = "rm5m4m6",
   device_body = metal5res_cl,
   terminal_a = metal5nores,
   terminal_b = metal5nores,
   reference_layer = MET5RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm5m4m6", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm5m4", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm5", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M6 
// rm6
resistor (
   matrix = trace_devMtrx,
   device_name = "rm6m5",
   device_body = metal6res_cl,
   terminal_a = metal6nores,
   terminal_b = metal6nores,
   reference_layer = MET6RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm6m5m7", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm6m5", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm6", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M7 
// rm7
resistor (
   matrix = trace_devMtrx,
   device_name = "rm7m6",
   device_body = metal7res_cl,
   terminal_a = metal7nores,
   terminal_b = metal7nores,
   reference_layer = MET7RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
       {device_name = "rm7m6m8", terminal_a = "A", terminal_b = "B"},
       {device_name = "rm7m6", terminal_a = "A", terminal_b = "B"},
       {device_name = "rm7", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

// M8 
// rm8
resistor (
   matrix = trace_devMtrx,
   device_name = "rm8m7",
   device_body = metal8res_cl,
   terminal_a = metal8nores,
   terminal_b = metal8nores,
   reference_layer = MET8RESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rm8m7m9", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm8m7", terminal_a = "A", terminal_b = "B"},
      {device_name = "rm8m7u", terminal_a = "A", terminal_b = "B"}, // used by x10
      {device_name = "rm8", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);


// #if defined( _drPROCESS == 5)
//    resistor (
//       matrix = trace_devMtrx,
//      device_name = "rm9m8",
//      device_body = metal9res_cl,
//      terminal_a = metal9nores,
//      terminal_b = metal9nores,
//      reference_layer = MET9RESID, //optional
//      properties = {
//        {name = "w", type = DOUBLE, scale = MICRO},
//        {name = "l", type = DOUBLE, scale = MICRO}
//      }, 
//      property_function = genRes2TermProps, //optional
//      merge_parallel = false, //optional
//      schematic_devices = {
//         {device_name = "rm9m8m10", terminal_a = "A", terminal_b = "B"},
//         {device_name = "rm9m8", terminal_a = "A", terminal_b = "B"},
//         {device_name = "rm9", terminal_a = "A", terminal_b = "B"}
//         },
//      resistor_value = 1.0 //optional
//   );
//
//   resistor (
//      matrix = trace_devMtrx,
//      device_name = "rm10m9",
//      device_body = metal10res_cl,
//      terminal_a = metal10nores,
//      terminal_b = metal10nores,
//      reference_layer = MET10RESID, //optional
//      properties = {
//        {name = "w", type = DOUBLE, scale = MICRO},
//        {name = "l", type = DOUBLE, scale = MICRO}
//      }, 
//      property_function = genRes2TermProps, //optional
//      merge_parallel = false, //optional
//      schematic_devices = {
//         {device_name = "rm10m9tm1", terminal_a = "A", terminal_b = "B"},
//         {device_name = "rm10m9", terminal_a = "A", terminal_b = "B"},
//         {device_name = "rm10", terminal_a = "A", terminal_b = "B"}
//         },
//      resistor_value = 1.0 //optional
//   );
//
//   resistor (
//      matrix = trace_devMtrx,
//      device_name = "rtm1m10",
//      device_body = tm1res_cl,
//      terminal_a = tm1nores,
//      terminal_b = tm1nores,
//      reference_layer = TM1RESID, //optional
//      properties = {
//        {name = "w", type = DOUBLE, scale = MICRO},
//        {name = "l", type = DOUBLE, scale = MICRO}
//      }, 
//      property_function = genRes2TermProps, //optional
//      merge_parallel = false, //optional
//      schematic_devices = {
//         {device_name = "rtm1m10", terminal_a = "A", terminal_b = "B"},
//         {device_name = "rtm1", terminal_a = "A", terminal_b = "B"}
//      },
//      resistor_value = 1.0 //optional
//   );

#if _drPROCESS == 6
   // M9 
   // rm9
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8m10", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm9m8", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm9", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   // M10 
   // rm10
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm10m9",
      device_body = metal10res_cl,
      terminal_a = metal10nores,
      terminal_b = metal10nores,
      reference_layer = MET10RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm10m9m11", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm10m9", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm10", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   // M11 
   // rm11
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm11m10",
      device_body = metal11res_cl,
      terminal_a = metal11nores,
      terminal_b = metal11nores,
      reference_layer = MET11RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm11m10m12", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm11m10", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm11", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   // M12 
   // rm12
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm12m11",
      device_body = metal12res_cl,
      terminal_a = metal12nores,
      terminal_b = metal12nores,
      reference_layer = MET12RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm12m11tm1", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm12m11", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm12", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   // TM1 
   // rtm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1m12",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1m12", terminal_a = "A", terminal_b = "B"},
         {device_name = "rtm1m12c4", terminal_a = "A", terminal_b = "B"},
         {device_name = "rtm1", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );

#else  // dot1
   // M9 
   // rm9
   resistor (
      matrix = trace_devMtrx,
      device_name = "rm9m8",
      device_body = metal9res_cl,
      terminal_a = metal9nores,
      terminal_b = metal9nores,
      reference_layer = MET9RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rm9m8tm1", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm9m8", terminal_a = "A", terminal_b = "B"},
         {device_name = "rm9", terminal_a = "A", terminal_b = "B"}
         },
      resistor_value = 1.0 //optional
   );

   // TM1 
   // rtm1
   resistor (
      matrix = trace_devMtrx,
      device_name = "rtm1m9",
      device_body = tm1res_cl,
      terminal_a = tm1nores,
      terminal_b = tm1nores,
      reference_layer = TM1RESID, //optional
      properties = {
        {name = "w", type = DOUBLE, scale = MICRO},
        {name = "l", type = DOUBLE, scale = MICRO}
      }, 
      property_function = genRes2TermProps, //optional
      merge_parallel = false, //optional
      schematic_devices = {
         {device_name = "rtm1m9", terminal_a = "A", terminal_b = "B"},
         {device_name = "rtm1m9c4", terminal_a = "A", terminal_b = "B"},
         {device_name = "rtm1", terminal_a = "A", terminal_b = "B"}
      },
      resistor_value = 1.0 //optional
   );

#endif

resistor (
   matrix = trace_devMtrx,
   device_name = "rrdlm0",
   device_body = rdlres_cl,
   terminal_a = rdlnores,
   terminal_b = rdlnores,
   reference_layer = RDLRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rrdlm0", terminal_a = "A", terminal_b = "B"},
      {device_name = "rrdl", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);

resistor (
   matrix = trace_devMtrx,
   device_name = "rmcrm4m6",
   device_body = mcrres_cl,
   terminal_a = mcrnores,
   terminal_b = mcrnores,
   reference_layer = MCRRESID, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, 
   property_function = genRes2TermProps, //optional
   merge_parallel = false, //optional
   schematic_devices = {
      {device_name = "rmcrm4m6", terminal_a = "A", terminal_b = "B"},
      {device_name = "rmcrm4", terminal_a = "A", terminal_b = "B"},
      {device_name = "rmcr", terminal_a = "A", terminal_b = "B"}
   },
   resistor_value = 1.0 //optional
);


// resistor (
//   matrix = trace_devMtrx,
//   device_name = "rmtj",
//   device_body = MTJ,
//   terminal_a = metal1nores,
//   terminal_b = VIA2,
//   reference_layer = MTJ, //optional
//   properties = {
//     {name = "w", type = DOUBLE, scale = MICRO},
//     {name = "l", type = DOUBLE, scale = MICRO}
//   }, 
//   property_function = genRes2TermProps, //optional
//   merge_parallel = false, //optional
//   schematic_devices = {
//      {device_name = "rmtjm1m3", terminal_a = "A", terminal_b = "B"},
//      {device_name = "rmtjm1", terminal_a = "A", terminal_b = "B"},
//      {device_name = "rmtj", terminal_a = "A", terminal_b = "B"}
//   },
//   resistor_value = 1.0 //optional
//);
#endif

/* define capacitors */

// since all gates are now rectangular these can be 
// extracted thru normal nmos/pmos commands */
// skip if cadnav since all these should be filtered
#if (!defined(_drCADNAV) && !defined(_drRCextract))
nmos(
   matrix = trace_devMtrx,
   device_name = "mncap",
   drain = nsd,
   gate = cap_ngate,
   source = nsd,
   optional_pins = { {
      device_layer = __drsubstrate,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, //optional
   schematic_devices = {
      {device_name = "mncap", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);

pmos(
   matrix = trace_devMtrx,
   device_name = "mpcap",
   drain = psd,
   gate = cap_pgate,
   source = psd,
   optional_pins = { {
      device_layer = nwell_nores,
      pin_name = "BULK",
      pin_type = BULK,
      pin_compared = true
   }},
   reference_layer = POLY, //optional
   properties = {
     {name = "w", type = DOUBLE, scale = MICRO},
     {name = "l", type = DOUBLE, scale = MICRO}
   }, //optional
   schematic_devices = {
      {device_name = "mpcap", drain = "DRN", gate = "GATE", source = "SRC", optional_pins = {"BULK"}}
   },
   source_drain_config = {NORMAL} //optional
);
#endif


// include the device extraction for the scaleable mfc
#include <1273/p1273dx_Tdevxtr_sclmfc.rs>

// include the device extraction for the met via res 
#include <1273/p1273dx_Tdevxtr_mvsw.rs>

#if (defined(_drICFDEVICES))
// ****************** ICF INDUCTOR **************
inductor(
        matrix = trace_devMtrx,
        device_name = "ind2t_scl",
        device_body = ind_tm1_id,
        terminal_a = ind_tm1_term,
        terminal_b = ind_tm1_term,
        processing_layer_hash = {
                         "ind_tm1_sp_w" => { ind_tm1_sp_w },
                         "ind_tm1_coin_edge" => { ind_tm1_coin_edge },
                         "ind_tm1_nTurns" => { ind_tm1_nTurns },
                         "ind_tm1_inner_x" => { ind_tm1_inner_x },
                         "ind_tm1_inner_y" => { ind_tm1_inner_y }
        },
        properties = {
                        {name = "nrturns", type = DOUBLE, scale=NONE},
                        {name = "coilwx", type = DOUBLE, scale=MICRO},
                        {name = "coilspcx", type = DOUBLE, scale=MICRO},
                        {name = "innerwx", type = DOUBLE, scale=MICRO},
                        {name = "innerwy", type = DOUBLE, scale=MICRO},
                        {name = "toplayer", type = STRING}
        },
        property_function = indctTM1ICFFunc,
        schematic_devices = {{ device_name = "ind2t_scl",
                        terminal_a = "n",
                        terminal_b = "p"
        }}
);

#if (_drPROCESS == 6)
inductor(
        matrix = trace_devMtrx,
        device_name = "ind2t_scl",
        device_body = ind_m12_id,
        terminal_a = ind_m12_term,
        terminal_b = ind_m12_term,
        processing_layer_hash = {
                         "ind_m12_sp_w" => { ind_m12_sp_w },
                         "ind_m12_coin_edge" => { ind_m12_coin_edge },
                         "ind_m12_nTurns" => { ind_m12_nTurns },
                         "ind_m12_inner_x" => { ind_m12_inner_x },
                         "ind_m12_inner_y" => { ind_m12_inner_y }
        },
        properties = {
                        {name = "nrturns", type = DOUBLE, scale=NONE},
                        {name = "coilwx", type = DOUBLE, scale=MICRO},
                        {name = "coilspcx", type = DOUBLE, scale=MICRO},
                        {name = "innerwx", type = DOUBLE, scale=MICRO},
                        {name = "innerwy", type = DOUBLE, scale=MICRO},
                        {name = "toplayer", type = STRING}
        },
        property_function = indctM12ICFFunc,
        schematic_devices = {{ device_name = "ind2t_scl",
                        terminal_a = "n",
                        terminal_b = "p"
        }}
);
#endif

// *************** END ICF INDUCTOR ****************

// ****************** ICF MIM CAP  **************
/****************** Start of scl mim cap ***************/
capacitor (
        matrix = trace_devMtrx,
        device_name = "mimcap_scl",
        device_body = mim_scl_body,
        terminal_a = mim_scl_top_plate,
        terminal_b = mim_scl_bottem_plate,
        processing_layer_hash = {
            "mim_scl_body_p" => { mim_scl_body_p },
            "stacked_mim" => { stacked_mim },
            "mim_scl_body_and_L1" => { mim_scl_body_and_L1 },
            "mim_scl_body_and_L3" => { mim_scl_body_and_L3 },
            "mim_scl_body_and_L1_touch_edge_poly_devtermID4" => {mim_scl_body_and_L1_touch_edge_poly_devtermID4},
            "mim_scl_body_and_L3_touch_edge_poly_devtermID4" => {mim_scl_body_and_L3_touch_edge_poly_devtermID4},
            "mim_scl_top_plate_LH" => {mim_scl_top_plate_LH},
            "mim_scl_top_plate_LH_01" => {mim_scl_top_plate_LH_01},
            "CE2DRAWN" => {CE2DRAWN},
            "mim_scl_top_plate_for_Z" => {mim_scl_top_plate_for_Z},
            "SCL_MIM_ID2_metal" => {SCL_MIM_ID2_metal },
            "poly_devtermID1_LH" => {poly_devtermID1_LH},
            "poly_devtermID1_LH_coin_edge_ID2" => {poly_devtermID1_LH_coin_edge_ID2},

        },
        properties = {
                        {name = "L1", type = DOUBLE, scale = MICRO},
                        {name = "L2", type = DOUBLE, scale = MICRO},
                        {name = "L3", type = DOUBLE, scale = MICRO},
                        {name = "W",  type = DOUBLE, scale = MICRO},
                        {name = "LH", type = DOUBLE, scale = MICRO},
                        {name = "WH", type = DOUBLE, scale = MICRO},
                        {name = "NH", type = DOUBLE, scale = NONE}

        },

property_function = scl_mimL1Func,
schematic_devices = {{ device_name = "mimcap_scl", terminal_a = "p", terminal_b = "n"}
        }

);
/****************** End of scl mim cap ***************/
/****************** Start of stacked mim cap ***************/
capacitor (
        matrix = trace_devMtrx,
        device_name = "mimcap_stk_scl",
        device_body = mim_scl_body_stacked,
        terminal_a = mim_scl_bottem_plate,
        terminal_b = mim_scl_bottem_plate,
        processing_layer_hash = {
            "stacked_mim" => { stacked_mim } ,
            "mim_scl_body_p" => { mim_scl_body_p },
            "mim_scl_body_and_L1" => { mim_scl_body_and_L1 },
            "mim_scl_body_and_L3" => { mim_scl_body_and_L3 },
            "mim_scl_body_and_L1_touch_edge_poly_devtermID4" => {mim_scl_body_and_L1_touch_edge_poly_devtermID4},
            "mim_scl_body_and_L3_touch_edge_poly_devtermID4" => {mim_scl_body_and_L3_touch_edge_poly_devtermID4},
            "mim_scl_top_plate_LH" => {mim_scl_top_plate_LH},
            "mim_scl_top_plate_LH_01" => {mim_scl_top_plate_LH_01},
            "CE2DRAWN" => {CE2DRAWN},
            "mim_scl_top_plate_for_Z" => {mim_scl_top_plate_for_Z},
            "SCL_MIM_ID2_metal" => {SCL_MIM_ID2_metal },
            "poly_devtermID1_LH" => {poly_devtermID1_LH},
            "poly_devtermID1_LH_coin_edge_ID2" => {poly_devtermID1_LH_coin_edge_ID2},

        },
        properties = {
                        {name = "L1", type = DOUBLE, scale = MICRO},
                        {name = "L2", type = DOUBLE, scale = MICRO},
                        {name = "L3", type = DOUBLE, scale = MICRO},
                        {name = "W",  type = DOUBLE, scale = MICRO},
                        {name = "LH", type = DOUBLE, scale = MICRO},
                        {name = "WH", type = DOUBLE, scale = MICRO},
                        {name = "NH", type = DOUBLE, scale = NONE}

        },

property_function = scl_mimL1Func,
schematic_devices = {{ device_name = "mimcap_stk_scl", terminal_a = "p", terminal_b = "n"}
        }

);

/****************** End of stacked mim cap ***************/

#endif

#if _drTRCVIEW == _drsch2sch
   #include "1273/p1273dx_Tdevsch2sch.rs"
#endif
 
stdTrace_devDb = extract_devices (
   matrix = trace_devMtrx
   #if VERSION_GE(2010,12,0,0)
      ,remove_dangling_ports = NONE
   #endif
);

std_netlist = netlist(
   device_db = stdTrace_devDb,
   include_empty_cells = WITH_PORTS, //optional
   precision = 4 //optional
);

#ifdef _drRCextract
   // syu7:: ddb support
   layout_spice_file = flowTopCell + ".spice";
   layout_spice_netlist = spice_netlist_file ( file = layout_spice_file);
   write_spice (
     device_db = stdTrace_devDb,
     output_file = layout_spice_netlist,
     model_name_format = COMMENT,
     include_empty_cells = ALL
	 #ifdef _drRCextractDdbSpice
	    ,
		include_placement_data = true
	 #endif
   );
#endif

#endif

