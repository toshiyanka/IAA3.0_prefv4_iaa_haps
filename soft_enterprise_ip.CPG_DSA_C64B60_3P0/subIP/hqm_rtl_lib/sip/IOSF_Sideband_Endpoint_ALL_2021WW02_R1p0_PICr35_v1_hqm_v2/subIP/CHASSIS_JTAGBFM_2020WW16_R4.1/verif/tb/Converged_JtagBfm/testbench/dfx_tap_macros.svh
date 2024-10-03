// =====================================================================================================
// FileName          : dfx_tap_macros.svh
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Dec  3 14:18:30 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// TAP macros
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_MACROS_SVH
`define DFX_TAP_MACROS_SVH

`define _a_tap_bfm_ \
    `ovm_info(get_type_name(), "Overriding classes for _A_TAP_BFM_", OVM_NONE) \
    set_type_override_by_type(dfx_tap_multiple_taps_transaction::get_type(), dfx_tap_multiple_taps_transaction_a::get_type()); \
    set_type_override_by_type(dfx_tap_multiple_taps_sequence::get_type(), dfx_tap_multiple_taps_sequence_a::get_type()); \
    set_type_override_by_type(dfx_tap_driver::get_type(), dfx_tap_driver_a::get_type()); \

`define _b_tap_bfm_ \
    `ovm_info(get_type_name(), "Overriding classes for _B_TAP_BFM_", OVM_NONE) \
    set_type_override_by_type(dfx_tap_multiple_taps_transaction::get_type(), dfx_tap_multiple_taps_transaction_b::get_type()); \
    set_type_override_by_type(dfx_tap_multiple_taps_sequence::get_type(), dfx_tap_multiple_taps_sequence_b::get_type()); \
    set_type_override_by_type(dfx_tap_driver::get_type(), dfx_tap_driver_b::get_type());

`endif // `ifndef DFX_TAP_MACROS_SVH
