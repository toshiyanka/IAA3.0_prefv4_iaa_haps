// Text_Tag % Vendor Intel % Product c73p4rfshdxrom % Techno P1273.1 % Tag_Spec 1.0 % ECCN US_3E002 % Signature b1c3d5e7dbbb56b1ff5eee8837b483f41d3fc87b % Version r1.0.0_m1.18 % _View_Id sv % Date_Time 20160216_100946 
//=============================================================================
//  Copyright (c) 2010 Intel Corporation, all rights reserved.
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY
//  COPYRIGHT LAWS AND IS CONSIDERED A TRADE SECRET BELONGING
//  TO THE INTEL CORPORATION.
//
//  Intel Confidential
//=============================================================================
//
// MOAD Begin
//     File/Block                             : soc_clocks.sv
//     Design Style [rls|rf|ssa_fuse|sdp|
//                   custom|hier|rls_hier]    : rls
//     Circuit Style [non_rfs|rfs|ssa|fuse|
//                    IO|ROM|none]            : none
//     Common_lib (for custom blocks only)    : none  
//     Library (must be same as module name)  : soc_clocks
//     Unit [unit id or shared]               : shared
//     Complex [North, South, CPU]            : North
//     Bizgroup [LCP|SEG|ULMD]                : ULMD
//
// Design Unit Owner :  ram.m.krishnamurthy@intel.com
// Primary Contact   :  ram.m.krishnamurthy@intel.com
// 
// MOAD End
//
//=============================================================================
//
// Description:
//   <Enter Description Here>
//
//=============================================================================
//
`ifndef SOC_CLOCKS_VS
`define SOC_CLOCKS_VS
  
// Needed because we use the LATCH macro below.
//
`include "soc_macros.sv"
`include "bxt_macro_tech_map.vh"

`include "soc_power_macros.sv"
`include "soc_dfx_macros.sv"
`include "soc_clock_macros.sv"



`endif // unmatched `endif



