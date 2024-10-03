// =====================================================================================================
// FileName          : dfx_tap_dut_defines.svh
// Primary Contact   : Pankaj Sharma
// Secondary Contact : Pinchas Lange / Roee Saroosi
// Creation Date     : Tue Jan 1 2013
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// SOC TAP definitions
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_DUT_DEFINES_SVH
`define DFX_TAP_DUT_DEFINES_SVH

`include "dfx_tap_project_defines.svh"

typedef dfx_node_t[`MAX_TAP_INSTR_LENGTH - 1 : 0] tap_ir_t;

// All TAPs in their correct sequence.
//
// All TAP names must consist of an alphanumeric string followed by a non-numeric character and then a numeric string.
// The alphanumeric string must conform to the class name or type.  The numeric string at the end implements a numbering
// scheme where string "pqr" indicates that the TAP is the pqr-th TAP of that type.
//
typedef enum {
  CLTAP = 0, /* closest to chip TDI */
  STAP0,
  STAP1,
  STAP2,
  STAP3,
  STAP4,
  STAP5,
  STAP6,
  STAP7,
  STAP8,
  STAP9,
  STAP10,
  STAP11,
  STAP12,
  STAP13,
  STAP14,
  STAP15,
  STAP16,
  STAP17,
  STAP18,
  STAP19,
  STAP20,
  STAP21,
  STAP22,
  STAP23,
  STAP24,
  STAP25,
  STAP26,
  STAP27,
  STAP28,
  STAP29,
  NUM_TAPS
} dfx_tap_unit_e;


`include "dfx_tap_any.sv"
`include "dfx_tap_cltap_v1_0.sv"
`include "dfx_tap_stap0_v1_0.sv"
`include "dfx_tap_stap1_v1_0.sv"
`include "dfx_tap_stap2_v1_0.sv"
`include "dfx_tap_stap3_v1_0.sv"
`include "dfx_tap_stap4_v1_0.sv"
`include "dfx_tap_stap5_v1_0.sv"
`include "dfx_tap_stap6_v1_0.sv"
`include "dfx_tap_stap7_v1_0.sv"
`include "dfx_tap_stap8_v1_0.sv"
`include "dfx_tap_stap9_v1_0.sv"
`include "dfx_tap_stap10_v1_0.sv"
`include "dfx_tap_stap11_v1_0.sv"
`include "dfx_tap_stap12_v1_0.sv"
`include "dfx_tap_stap13_v1_0.sv"
`include "dfx_tap_stap14_v1_0.sv"
`include "dfx_tap_stap15_v1_0.sv"
`include "dfx_tap_stap16_v1_0.sv"
`include "dfx_tap_stap17_v1_0.sv"
`include "dfx_tap_stap18_v1_0.sv"
`include "dfx_tap_stap19_v1_0.sv"
`include "dfx_tap_stap20_v1_0.sv"
`include "dfx_tap_stap21_v1_0.sv"
`include "dfx_tap_stap22_v1_0.sv"
`include "dfx_tap_stap23_v1_0.sv"
`include "dfx_tap_stap24_v1_0.sv"
`include "dfx_tap_stap25_v1_0.sv"
`include "dfx_tap_stap26_v1_0.sv"
`include "dfx_tap_stap27_v1_0.sv"
`include "dfx_tap_stap28_v1_0.sv"
`include "dfx_tap_stap29_v1_0.sv"


`define dfx_tap_define_master_TAPs \
  begin \
    tap_tree[CLTAP].master_tap = CLTAP; /* no master */ \
    /* tap_tree[CLTAP].hierarchical = 1'b0; */ /* behaves like a linear TAP! */ \
    tap_tree[STAP0].master_tap = CLTAP; \
    tap_tree[STAP1].master_tap = CLTAP; \
    tap_tree[STAP1].hierarchical = 1'b1; \
    tap_tree[STAP2].master_tap = STAP1; \
    tap_tree[STAP2].hierarchical = 1'b1; \
    tap_tree[STAP3].master_tap = STAP2; \
    tap_tree[STAP4].master_tap = STAP2; \
    tap_tree[STAP4].hierarchical = 1'b1; \
    tap_tree[STAP5].master_tap = STAP4; \
    tap_tree[STAP6].master_tap = STAP4; \
    tap_tree[STAP7].master_tap = STAP2; \
    tap_tree[STAP8].master_tap = STAP1; \
    tap_tree[STAP8].hierarchical = 1'b1; \
    tap_tree[STAP9].master_tap = STAP8; \
    tap_tree[STAP10].master_tap = STAP8; \
    tap_tree[STAP11].master_tap = STAP8; \
    tap_tree[STAP12].master_tap = STAP8; \
    tap_tree[STAP13].master_tap = STAP8; \
    tap_tree[STAP13].hierarchical = 1'b1; \
    tap_tree[STAP14].master_tap = STAP13; \
    tap_tree[STAP14].hierarchical = 1'b1; \
    tap_tree[STAP15].master_tap = STAP14; \
    tap_tree[STAP16].master_tap = STAP14; \
    tap_tree[STAP17].master_tap = STAP14; \
    tap_tree[STAP18].master_tap = STAP14; \
    tap_tree[STAP19].master_tap = STAP13; \
    tap_tree[STAP20].master_tap = CLTAP; \
    tap_tree[STAP20].hierarchical = 1'b1; \
    tap_tree[STAP21].master_tap = STAP20; \
    tap_tree[STAP22].master_tap = STAP20; \
    tap_tree[STAP23].master_tap = STAP20; \
    tap_tree[STAP24].master_tap = STAP20; \
    tap_tree[STAP24].hierarchical = 1'b1; \
    tap_tree[STAP25].master_tap = STAP24; \
    tap_tree[STAP26].master_tap = STAP24; \
    tap_tree[STAP27].master_tap = CLTAP; \
    tap_tree[STAP28].master_tap = CLTAP; \
    tap_tree[STAP29].master_tap = CLTAP; \
    \
    /* Do NOT modify the following lines. */ \
    tap_tree[CLTAP].level = 0; /* start at the root */ \
    l_list.push_back(CLTAP); \
  end

`endif // `ifndef DFX_TAP_DUT_DEFINES_SVH

