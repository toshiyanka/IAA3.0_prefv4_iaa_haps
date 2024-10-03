// =====================================================================================================
// FileName          : dfx_tap_test_pkg.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Dec 10 12:39:42 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFX sequence library package
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_TEST_PKG_SV
`define DFX_TAP_TEST_PKG_SV

package dfx_tap_test_pkg;

  import ovm_pkg::*;
  import dfx_tap_env_pkg::*;
  import dfx_tap_seqlib_pkg::*;

  `include "ovm_macros.svh"

  `include "dfx_common_sequence.sv"

  `include "dfx_tap_idcode_sequence.sv"
  `include "dfx_tap_sip_api_sequence.sv"

endpackage : dfx_tap_test_pkg

`endif // `ifndef DFX_TAP_TEST_PKG_SV
