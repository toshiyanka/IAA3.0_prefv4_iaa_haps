//======================================================================================================================
//
// devtlb_pkg.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//======================================================================================================================

`ifndef HQM_DEVTLB_PKG_VERIF_VH
`define HQM_DEVTLB_PKG_VERIF_VH

// Set package name if it is not already set
`ifndef HQM_DEVTLB_PACKAGE_VERIF_NAME
`define HQM_DEVTLB_PACKAGE_VERIF_NAME          devtlb_pkg_verif
`endif

package `HQM_DEVTLB_PACKAGE_VERIF_NAME; 

`ifndef SVA_LIB_CORE

`include "hqm_devtlb_intel_checkers_ext.sv"

`endif

   `include "hqm_devtlb_globals_int.vh"        // Common Parameters that are not used by parent hierarchies
   `include "hqm_devtlb_params.vh"

   `include "hqm_devtlb_globals_ext.vh"        // Common Parameters that may be used by parent hierarchies

   //`include "devtlb_params.vh"

   `include "hqm_devtlb_types.vh"              // Structure, Enum, Union Definitions
   `include "hqm_devtlb_functions.vh"          // Function Definitions

endpackage

`endif // DEVTLB_PKG_VERIF_VH
