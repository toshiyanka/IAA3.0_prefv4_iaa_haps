//=====================================================================================================================
// Title            : hqm_intel_checkers_pkg.sv
//
// Creation Date    : Q1-2016
//
// Copyright (c) 2013 Intel Corporation
// Intel Proprietary and Top Secret Information
//---------------------------------------------------------------------------------------------------------------------
// Description:
//
//   This is the package that wraps SVA_LIB predefined properties, sequences, let statements.
//   Users are expected to import the package in module scope where SVA_LIB macros are being
//   used.
//
//   This package includes 2-value assertions, i.e if an input to the assertion
//   has an x/z value the assertion FAILS regardless of assertion semantics.
//   Example: 
// 	When importing this package `HQM_ASSERTC_AT_MOST_BITS_HIGH(myAssert, 000x, 2, ...) will FAIL
//

package hqm_intel_checkers_pkg;

localparam HQM_SVA_LIB_IGNORE_XZ = 0;

`ifndef INTEL_SVA_OFF
 `include "hqm_intel_checkers_core_imp.vs"
 `include "hqm_intel_checkers_ext_imp.vs"
`endif

endpackage : hqm_intel_checkers_pkg
