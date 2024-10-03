// =====================================================================================================
// FileName          : dfx_tap_common_defines.svh
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri May 28 15:46:34 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Common TAP defines
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_COMMON_DEFINES_SVH
`define DFX_TAP_COMMON_DEFINES_SVH

// TAP states - normal, excluded, isolated.
//
typedef enum {
  TAP_STATE_NORMAL,
  TAP_STATE_EXCLUDED,
  TAP_STATE_ISOLATED,
  TAP_STATE_SPECIAL_NETWORK /* TAP_STATE_SHADOW */
} dfx_tap_state_e;

// This type is used to denote the TAP FSM state.
//
typedef enum {
  DFX_TAP_TS_TLR,
  DFX_TAP_TS_RTI,
  DFX_TAP_TS_SELECT_DR,
  DFX_TAP_TS_CAPTURE_DR,
  DFX_TAP_TS_SHIFT_DR,
  DFX_TAP_TS_EXIT1_DR,
  DFX_TAP_TS_PAUSE_DR,
  DFX_TAP_TS_EXIT2_DR,
  DFX_TAP_TS_UPDATE_DR,
  DFX_TAP_TS_SELECT_IR,
  DFX_TAP_TS_CAPTURE_IR,
  DFX_TAP_TS_SHIFT_IR,
  DFX_TAP_TS_EXIT1_IR,
  DFX_TAP_TS_PAUSE_IR,
  DFX_TAP_TS_EXIT2_IR,
  DFX_TAP_TS_UPDATE_IR,
  DFX_TAP_TS_UNKNOWN
} dfx_tapfsm_state_e;

// Scan packet formats in 2 pin mode for various non-shift and shift states:
//
//       ====================================================================
//       | Format | Non Shift-*R States        | Shift-*R States            |
//       |========|============================|============================|
//       |  MSCAN | {nTDI,TMS,PC0,RDY,PC1,TDO} | {nTDI,TMS,PC0,RDY,PC1,TDO} |
//       |--------|----------------------------|----------------------------|
//       | OSCAN0 | {nTDI,TMS,RDY,TDO}         | {nTDI,TMS,RDY,TDO}         |
//       |--------|----------------------------|----------------------------|
//       | OSCAN1 | {nTDI,TMS,TDO}             | {nTDI,TMS,TDO}             |
//       |--------|----------------------------|----------------------------|
//       | OSCAN2 | {TMS}                      | {nTDI,TMS,TDO}             |
//       |--------|----------------------------|----------------------------|
//       | OSCAN3 | {TMS}                      | {nTDI,TMS}                 |
//       |--------|----------------------------|----------------------------|
//       | OSCAN4 | {nTDI,TMS,RDY,TDO}         | {nTDI,RDY,TDO}             |
//       |--------|----------------------------|----------------------------|
//       | OSCAN5 | {nTDI,TMS,TDO}             | {nTDI,TDO}                 |
//       |--------|----------------------------|----------------------------|
//       | OSCAN6 | {TMS}                      | {nTDI,TMS,TDO} *CAP/EX2    |
//       |        |                            | {nTDI,TDO}     *SHIFT      |
//       |--------|----------------------------|----------------------------|
//       | OSCAN7 | {TMS}                      | {nTDI}                     |
//       ====================================================================
//
typedef enum {
  TAP_SCAN_NORMAL, // 4-pin
  // The remaining are 2-pin formats
  TAP_SCAN_MSCAN,
  TAP_SCAN_OSCAN0,
  TAP_SCAN_OSCAN1,
  TAP_SCAN_OSCAN2,
  TAP_SCAN_OSCAN3,
  TAP_SCAN_OSCAN4,
  TAP_SCAN_OSCAN5,
  TAP_SCAN_OSCAN6,
  TAP_SCAN_OSCAN7
} dfx_tap_scan_format_e;

`endif // `ifndef DFX_TAP_COMMON_DEFINES_SVH
