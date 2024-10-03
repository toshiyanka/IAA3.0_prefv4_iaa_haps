// =====================================================================================================
// FileName          : dfx_tap_seqlib_pkg.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Mar  9 20:58:30 CST 2011
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

`ifndef DFX_TAP_SEQLIB_PKG_SV
`define DFX_TAP_SEQLIB_PKG_SV

package dfx_tap_seqlib_pkg;

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
  import dfx_tap_env_pkg::*;

  `include "dfx_base_sequence.sv"
  `include "dfx_tap_base_sequences.sv"
  `include "dfx_tap_disable_sequence.sv"
  `include "dfx_tap_enable_sequence.sv"
  `include "dfx_wtap_config_sequence.sv"
  `include "dfx_tap_remove_tap_sequence.sv"
  `include "dfx_tap_treset_sequence.sv"
  `include "dfx_tap_powergood_sequence.sv"

  // SIP JTAG BFM compatibility layer
  parameter SIZE_OF_IR_REG = 4096;
  parameter API_SIZE_OF_IR_REG = 4096;
  parameter TOTAL_DATA_REGISTER_WIDTH = 4096;
  parameter API_TOTAL_DATA_REGISTER_WIDTH = 4096;
  parameter WIDTH_OF_EACH_REGISTER = 10000;
  // parameter TDO_LEN = 4096;
  parameter TDO_LEN = WIDTH_OF_EACH_REGISTER; // largest size that could be compared
  `include "JtagBfmSequences.sv"
  `include "JtagBfmSoCTapNwSequences.sv"

endpackage : dfx_tap_seqlib_pkg

`endif // `ifndef DFX_TAP_SEQLIB_PKG_SV
