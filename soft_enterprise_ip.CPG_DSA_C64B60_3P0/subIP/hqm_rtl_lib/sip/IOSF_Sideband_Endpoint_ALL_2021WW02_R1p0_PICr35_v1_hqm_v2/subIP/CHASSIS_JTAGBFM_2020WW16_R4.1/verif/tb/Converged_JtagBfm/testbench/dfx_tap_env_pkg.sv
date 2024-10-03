// =====================================================================================================
// FileName          : dfx_tap_env_pkg.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon Jun 21 17:57:10 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFX TAP package
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_ENV_PKG_SV
`define DFX_TAP_ENV_PKG_SV

package dfx_tap_env_pkg;

  `ifdef DTEG_UVM_EN
     import uvm_pkg::*;
  `endif
  import ovm_pkg::*;
  `ifdef DTEG_XVM_EN
     import xvm_pkg::*;
  `endif
  `ifdef DTEG_UVM_EN
     `include "uvm_macros.svh"
  `endif
  `include "ovm_macros.svh"
  `ifdef DTEG_XVM_EN
     `include "xvm_macros.svh"
  `endif

  static string dfx_tap_build_error_message = "Build TAP testbench with +define+_A_TAP_BFM_ or +define+_B_TAP_BFM_";

  `include "dfx_tap_common_defines.svh"
  `include "dfx_tap_types.svh"
  `include "dfx_tap_macros.svh" // not necessary at the moment

  `include "dfx_tap_util.sv"

  `include "dfx_tap_dut_defines.svh"

  `include "dfx_tap_network.sv"
  `include "dfx_tap_transaction.sv"
  `include "dfx_tap_monitor.sv"
  `include "dfx_tap_driver.sv"
  `include "dfx_tap_sequencer.sv"

  // SIP JTAG BFM compatibility:
  parameter PKT_SIZE_OF_IR_REG            = 4096;
`ifndef OVM_MAX_STREAMBITS
   parameter PKT_TOTAL_DATA_REGISTER_WIDTH = 4096;
   //parameter PKT_SIZE_OF_IR_REG            = 4096;
`else
   parameter PKT_TOTAL_DATA_REGISTER_WIDTH = `OVM_MAX_STREAMBITS;
   //parameter PKT_SIZE_OF_IR_REG            = `OVM_MAX_STREAMBITS;
`endif
  `include "JtagBfmTypes.svh"
  `include "JtagBfmTracker.sv"
  `include "JtagBfmInMonSbrPkt.sv"
  `include "JtagBfmInputMonitor.sv"
  `include "JtagBfmOutMonSbrPkt.sv"
  `include "JtagBfmOutputMonitor.sv"

  `include "dfx_tap_agent.sv"
  `include "dfx_tap_env.sv"

endpackage : dfx_tap_env_pkg

`endif // `ifndef DFX_TAP_ENV_PKG_SV
