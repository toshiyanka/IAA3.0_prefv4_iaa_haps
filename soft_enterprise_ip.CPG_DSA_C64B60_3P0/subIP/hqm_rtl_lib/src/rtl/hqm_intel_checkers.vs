//=====================================================================================================================
// Title            : hqm_intel_checkers.sv
//
// Copyright (c) 2013 Intel Corporation
// Intel Proprietary and Top Secret Information
//---------------------------------------------------------------------------------------------------------------------

`ifndef HQM_INTEL_CHECKERS_VS
`define HQM_INTEL_CHECKERS_VS

`ifndef INTEL_SVA_OFF

`ifdef HQM_SVA_LIB_SVA2009
`ifdef HQM_SVA_LIB_SVA2005
   $error("HQM_SVA_LIB_SVA2009 and HQM_SVA_LIB_SVA2005 are defined simultaneously.")
`endif
`endif


`ifndef HQM_SVA_LIB_SVA2009
`ifndef HQM_SVA_LIB_SVA2005
   `define HQM_SVA_LIB_SVA2009
`endif
`endif



// ### VER 18.2p1 ###

// The library is composed from 2 parts: 
//  * Library macros - This file
//  * Library package - hqm_intel_checkers_pkg.vs

// Control flags: 

// The library is configured by a set of define switches which can be added to the 
// RTL parser, either in simulation or emulation.
// These configuration flags should be controled through the project level, the library
// owner should review and decide on relevant mode.
//
// The define switches are as follows:
//
//  Flow based defines: 
//   These defines are determined per flow and not meant for user control.
//   
//   HQM_SVA_LIB_SVA2005 -  The library will use SystemVerilog assertion constructs 
//            	            that were defined in SystemVerilog 2005 LRM. This is meant
//                          for tools that do not support SystemVerilog 2009 LRM.
//                          Few properties are turned off and replaced with constant 1.  
//   HQM_SVA_LIB_SVA2009 -  (Default mode) The library will use SystemVerilog assertion
//                          constructs that were defined in SystemVerilog 2009 LRM 
//                          including LTL operators. All properties are working as 
//                          described in the manual.
//
//
//  Use-case defines:
//   These defines are optional and can be used in special cases defined by the user.
//
//   HQM_SVA_LIB_ENABLE_COVER_STDOUT - This options redirects the coverage $info messages to 
//                     stdout. The default mode, coverage $info messages are disabled
//                     for performance reasons. 
//   HQM_SVA_LIB_COVER_STDOUT_EXPR - This option enables runtime control of coverage $info 
//                     messages. Please read down for more info. 
//                     



`ifndef HQM_SVA_LIB_SVA2005
        `define HQM_SVA_LIB_FINAL final
`else  
        `define HQM_SVA_LIB_FINAL #0
`endif 



// === === ===  macro definitions for error reporting

`define HQM_SVA_ERR_MSG else $error
`define HQM_SVA_WARNING_MSG else $warning
`define HQM_SVA_FATAL_MSG else $fatal
`define HQM_SVA_INFO_MSG else $info

// The following mechanism is to allow the project to control printing the 'cover message'
// generated information to stdout. When using cover properties, the messages
// generated by the simulator/emulator may slow down the runtime significantly.
// It is used by some tools (JemHW) during compilation time without any impact on
// performance.
// The following mechanism enables several control modes:
//      1) Basic compile-time expression, such as 1'b0.  (Recommended)
//      2) Runtime global/local expression: users can implement/define dedicated 
//         signal/signals to cover message information. They may choose a global
//         signal to represent the whole design or several signals defined across 
//         the design hierarchies. These signals should be driven either during
//         simulation (CTE injection / do file / use $test$plusargs()/ ... ) or
//         in the design itself.
// 
`ifdef HQM_SVA_LIB_ENABLE_COVER_STDOUT
    `ifdef HQM_SVA_LIB_COVER_STDOUT_EXPR
        `define HQM_COVER_MSG if(`HQM_SVA_LIB_COVER_STDOUT_EXPR) $info 
    `else
        `define HQM_COVER_MSG $info
    `endif
`else
     `define HQM_COVER_MSG if(1'b0) $info
`endif

// === === === Implementation for the templates

`include "hqm_intel_checkers_core.vs"
`include "hqm_intel_checkers_ext.vs"

// --- --- --- --- --- --- --- --- --- --- ----

`endif // INTEL_SVA_OFF

`endif // HQM_INTEL_CHECKERS_VS

