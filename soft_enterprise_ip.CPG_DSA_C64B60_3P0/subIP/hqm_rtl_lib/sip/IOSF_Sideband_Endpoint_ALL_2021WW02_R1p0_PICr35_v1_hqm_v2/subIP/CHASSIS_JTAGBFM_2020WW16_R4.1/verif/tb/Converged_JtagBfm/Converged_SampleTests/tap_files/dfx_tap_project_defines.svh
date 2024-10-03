// =====================================================================================================
// FileName          : dfx_tap_project_defines.svh
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Dec 31 16:31:51 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// TAP defines
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_PROJECT_DEFINES_SVH
`define DFX_TAP_PROJECT_DEFINES_SVH

// The bits in an instruction vector (type defined below) are scanned into the TAP/JTAG port in this
// order:
//
//   [0] [1] [2] ...
//
`define MAX_TAP_INSTR_LENGTH 32
`define TAP_BYPASS_INSTR 32'hffffffff // common BYPASS instruction for all TAPs

`endif // `ifndef DFX_TAP_PROJECT_DEFINES_SVH
