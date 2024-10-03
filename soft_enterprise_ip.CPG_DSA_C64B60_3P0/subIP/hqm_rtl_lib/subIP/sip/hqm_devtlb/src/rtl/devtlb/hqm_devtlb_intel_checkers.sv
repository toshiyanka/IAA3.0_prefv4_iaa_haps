//=====================================================================================================================
//
// DEVTLB_intel_checkers.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Unknown (inherited)
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_INTEL_CHECKERS_VS
`define HQM_DEVTLB_INTEL_CHECKERS_VS


/*
### VER 5.3_test ###

There are two files representing the library templates:

intel_checkers_core.sv: Core Library templates.
intel_checkers_ext.sv: Project specific Library extensions.

Blocking the extensions part is done by defining the compiler directive:
 SVA_LIB_CORE.

*/

//HSW trick
`define HQM_DEVTLB_SVA_LIB_SVA2005

// `ifndef DEVTLB_SVA_LIB_SVA2005
//    `define DEVTLB_FINAL #0
// `else
//    `define DEVTLB_FINAL final
// `endif
   `define HQM_DEVTLB_FINAL #0

// `ifndef DEVTLB_SVA_LIB_SVA2005
//    `define DEVTLB_default_clk $inferred_clock
//    `define DEVTLB_SYS_CLK $global_clock
// `else
//    `ifdef IOMMU_SIMONLY
//       `define DEVTLB_default_clk null
//    `else
//       `define DEVTLB_default_clk $default_clk
//    `endif
// `endif
      `define HQM_DEVTLB_default_clk null

`ifdef PROTO
`define HQM_DEVTLB_default_clk 1'b0
`endif


// === === ===  macro definitions for error reporting

`define HQM_DEVTLB_MSG $sformatf
`ifndef DEVTLB_ERROR_MSG_OFF
  `define HQM_DEVTLB_ERR_MSG else $error
`else
  `define HQM_DEVTLB_ERR_MSG
`endif
`define HQM_DEVTLB_ERR `HQM_DEVTLB_ERR_MSG()
`define HQM_DEVTLB_ERR_MSG_VARG else $error
`define HQM_DEVTLB_WARNING_MSG else $warning
`define HQM_DEVTLB_WARN `HQM_DEVTLB_WARNING_MSG()
`define HQM_DEVTLB_FATAL_MSG else $fatal
`define HQM_DEVTLB_FATAL `HQM_DEVTLB_FATAL_MSG(2,"")
`define HQM_DEVTLB_INFO_MSG else $info
`ifndef DEVTLB_INFO_MSG_OFF
  `define HQM_DEVTLB_COVER_MSG $info
`else
  `define HQM_DEVTLB_COVER_MSG if(0) $info
`endif
`define HQM_DEVTLB_ERR_GLITCH_MSG(text, glitch_ns) $info("assertion is up"); \
  else $error("%s Not sensitive to glitch less than %d ns", (text), (glitch_ns))


// === === === Implementation for the templates

`include "hqm_devtlb_intel_checkers_core.sv"

// --- --- --- --- --- --- --- --- --- --- ----


`endif // DEVTLB_INTEL_CHECKERS_VS

