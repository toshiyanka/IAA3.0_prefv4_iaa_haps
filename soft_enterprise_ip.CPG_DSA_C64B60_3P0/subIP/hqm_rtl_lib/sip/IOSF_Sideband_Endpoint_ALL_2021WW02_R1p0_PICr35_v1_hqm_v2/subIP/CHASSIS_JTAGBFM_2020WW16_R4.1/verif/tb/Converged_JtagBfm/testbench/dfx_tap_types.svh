// =====================================================================================================
// FileName          : dfx_tap_types.svh
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon May 24 14:11:50 CDT 2010
// Last Modified     : Wed Mar  9 20:48:54 CST 2011
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Common defines/types for DFx environment.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_TYPES_SVH
`define DFX_TAP_TYPES_SVH

typedef logic dfx_node_t; // 4-state
// typedef bit dfx_node_t; // 2-state

typedef dfx_node_t dfx_node_ary_t[];

// All possible ports.
/*
typedef enum {TAP_PORT_P0 = 0,
              TAP_PORT_P1,
              TAP_PORT_P2,
              TAP_PORT_P3,
              TAP_PORT_P4,
              TAP_PORT_P5,
              TAP_PORT_P6,
              TAP_PORT_P7,
              TAP_PORT_P8,
              TAP_PORT_P9} dfx_tap_port_e;
 */
typedef enum {TAP_PORT_P[100]} dfx_tap_port_e;

// These events are triggered on the negedge of TCK immediately following entry into the pertinent state.
// (More event arrays can be defined as needed.)
//
event DFX_TAP_TS_SHIFT_DR_Event[dfx_tap_port_e];
event DFX_TAP_TS_EXIT1_DR_Event[dfx_tap_port_e];

typedef struct {

   int shifts;
   int pause;

} shift_pause_s;

// TAP FSM state data struct
typedef struct {

   dfx_tapfsm_state_e cur_state;
   dfx_tapfsm_state_e next_state;
   bit tms_l[$];
   bit tdi_l[];
   bit tdo_l[$];
   // if tms_l/tdi_l contain just one element, cycles defines time to stay in the state
   int cycles;

} tap_fsm_state_s;

// TAP built IR/DR data
typedef struct {

   string tap_name;
   string ir_name;
   dfx_node_t ir_in_l[];
   dfx_node_t dr_in_l[];
   dfx_node_t tdo_dr_exp_l[];
   dfx_node_t tdo_dr_msk_l[];
   bit user_cmd;
   dfx_tap_state_e status;

} tap_nw_s;

// TAP FSM state data struct
typedef struct {
   int tap_op_id;
} tap_globals_s;

`endif // `ifndef DFX_TAP_TYPES_SVH
