+lint=all
+error+99999
-error=all
-error=SV-IRT
-error=noTLVRZ
-error=noZERO
-error=noUI
-error=noVNGS
-error=noUFTMD
-error=noLCA_FEATURES_ENABLED

// Illegal assignment to enum variable
-error=ENUMASSIGN

// Incompatible complex type
-error=ICTA-SI

// Smaller enum label size
-error=SV-SELS

// Illegal high conn for port connect
-error=IPC

// Duplicate port in module instantiation
-error=DPIMI

// Return statement in non-void function must specify an expression.
-error=REO

// Identifier previously declared
-error=IPDW

// Index into non-array variable
-error=INAV

// Field value not used in struct expression
-error=FVNU

// Zero or negative multiconcat multiplier
-error=ZONMCM

// Identifier previously declared in ANSI port declaration
-error=IPDASP

// Attempt to override undefined parameter
-error=AOUP

// Force on ref port not supported
-error=FRCREF

// Incompatible structure/array literal
-error=ISALS

// Argument names do not match
-error=SV-ANDNMD

// String value passed to integral arg
-error=SV-SVPIA

// Fixed in patched OVM in tbtools
-error=noCVMBI

// Illegal scoped reference found
-error=ISRF

// Assignment in conditional expression
-error=AICE

-error=noNS

// Disable SVA errors
-error=noSVA-NSVU
-error=noSVA-UA
-error=noSVA-AEM
-error=noSVA-ICP
-error=noSVA-CAT
-error=noSVA-PAB
-error=noSVA-NSEF
-error=noSVA-CE
-error=noSVA-ADORM
-error=noSVA-DIU
-error=noSVA-IUC
-error=noSVA-STPAB
// Suppress OVM/Saola errors
-suppress=VCDE
-suppress=SV-LCM-PPWI
-suppress=ZERO
-suppress=UI
-suppress=NS
-suppress=SVA-NSVU
-suppress=SVA-UA
-suppress=SVA-AEM
-suppress=SVA-ICP
-suppress=SVA-CAT
-suppress=SVA-PAB
-suppress=SVA-NSEF
-suppress=SVA-CE
-suppress=SVA-ADORM
-suppress=SVA-DIU
-suppress=SVA-IUC
-suppress=SVA-STPAB

// Unknown in multiconcat multiplier
-error=WUIMCM

// Select index out of bounds
-error=SIOB

// Out of bound access for queues and for dynamic arrays
-error=AOOBAW

// Array Access with Intermediate Index
-error=AAII

// Non-parameterized virtual interface is being used for parameterized interface (added by KNHSOC)
-error=OSVF-NPVIUFPI

// Code execution before super.new
-error=SV-CEBS

// String value passed to integral arg
-error=SV-SVPIA

//Task calls are not supported
-error=CONG-TCNS

//Concatenations with unsized constants
-error=CWUC

//Different enum types in equality
-error=DTIE

//Empty case statement
-error=ECS

//Explicit typecast required for streams for assertion context
-error=ETRFSFAC

//Select index out of bounds
-error=SIOB

//Built-in method call on unpacked array
-error=SV-ARRMTH

//'extern' method not implemented
-error=SV-EMNI

//Illegal class handle usage
//-error=SV-ICHU :/p/hdk/rtl/ip_releases/shdk74/ccu_vc/ccu-vc-2014WW02r140110.onecfg.vcs2014.1.ace/ccu_vc_WW02/verif/lib/sip_vintf_manager/src/sip_vintf_proxy.svh, 124

//Integral value passed to string arg
//-error=SV-IVPSA /p/hdk/rtl/ip_releases/shdk74/iosf_pri/ip-iosf-primary-bfm-2017WW14r170405_v3/ph4/monitor/IosfMonitor.sv, 561

//Non-void Function Used In Void Context
//-error=SV-NFIVC

//Task enabled inside a function
//-error=TEIF /p/hdk/rtl/cad/x86-64_linux26/dt/uncore_bfm/UNCORE_7_26_0/kti/sysverilog/bfm_ovm/bfm_ovc/kti_pkt_ifc.sv, 39

//Too many parameter overrides
-error=TMPO

//Unknown in multiconcat multiplier
-error=WUIMCM

// /nfs/site/disks/sdg74_gkw_0077/projcfg/integrate_bundle1859/srvr_vc_contour-srvr10nm_clones/projcfg-srvr_vc_contour-srvr10nm-18-vc02-0/verif/content/tools/portability/tests/iosf_pri_portability_drivable_logical_agents_empty_pass_through_test/iosf_pri_portability_drivable_logical_agents_empty_pass_through_test.svh, 74
//  Invalid initialization of instance constant: 'drivable_logical_sockets'
//  cannot be initialized more than once in constructor. There is a potential
//  re-initialization at
//  statement : this.drivable_logical_sockets = {};
//  Previous at:
//  /p/hdk/rtl/proj_tools/iosf_pri_protocol/iosf_pri_protocol-srvr10nm-18ww02a/iosf_pri_protocol/src/interface/iosf_pri_stim_dut_view.svh,1269
//  Source info: this.drivable_logical_sockets =
//  discovered_drivable_logical_sockets;
-error=IIIC

-error=noSV-PIU,noSVA-FINUA,noIWU,noTFIPC-L
