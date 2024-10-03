// =====================================================================================================
// FileName          : dfx_jtag_if.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon May 24 15:25:39 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// JTAG interface.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_JTAG_IF_SV
`define DFX_JTAG_IF_SV

// import dfx_tap_env_pkg::dfx_node_t;

// JTAG (pin-level) interface.
//
interface dfx_jtag_if(input logic tck_in);

  logic tck, trst, tms, tdi, tdo;
  logic tck_enable; // putting this inside the interface allows us to control it easily from the testbench
  logic tck_high; // needed to hold TCK high for cJTAG

  logic powergood_rst_b; // SIP functionality
    
  event FSM_Event; // emitted after driver updates its internal TAP FSM state
  event SHIFT_DR_Event, EXIT1_DR_Event, UPDATE_DR_Done_Event, UPDATE_IR_Done_Event;
  event pos_tck;
  dfx_tap_env_pkg::dfx_tapfsm_state_e cts; // current TAP state

  // To stop TCK from running, set tck_enable to 0.  This will set TCK to 0.
  // To hold TCK high (for cJTAG), set tck_enable to 1 and tck_high to 1.
  //
  // assign tck = (tck_in | tck_high) & tck_enable;
  // Allow for Z on TCK input in case JTAG pins are muxed with functional pins.
  assign tck = tck_enable === 1'bz ? tck_enable : (tck_in | tck_high) & tck_enable;

  // Clocking blocks are unnecessary.

  // Clocking blocks are for testbench.  The clocking blocks use the "gated" TCK.
  //
  // Clocking block for signals read at negative TCK edge - these signals need to be sampled at the
  // next positive TCK edge.
  clocking p_sigs @(posedge tck);
    // input tdo;
  endclocking : p_sigs
  //
  // Clocking block for signals written at positive TCK edge - these signals need to be driven at
  // the previous negative TCK edge.
  clocking n_sigs @(negedge tck);
    // output tms, tdi;
  endclocking : n_sigs

  // The following "ungated" clocking block can be used for timing/delay/waiting purposes.
  // Because of the way the TAP driver drives the data, use only "p_sigs_ungated" for waiting a
  // certain number of TCK cycles.
  clocking p_sigs_ungated @(posedge tck_in);
  endclocking : p_sigs_ungated
  //
  clocking n_sigs_ungated @(negedge tck_in);
  endclocking : n_sigs_ungated


  modport TEST(clocking p_sigs,
               input tdo,
               clocking n_sigs,
               // output tms,
               inout tms, // for cJTAG
               output tdi,
               clocking p_sigs_ungated,
               clocking n_sigs_ungated,
               output trst,
               // inout trst,
               // ref trst,
               input tck_in, tck,
               output tck_enable, tck_high,
               ref FSM_Event,
               ref SHIFT_DR_Event, EXIT1_DR_Event, UPDATE_DR_Done_Event, UPDATE_IR_Done_Event, pos_tck,
               inout cts,
	       inout powergood_rst_b);

  modport  ENV(input tck_in,
               input tck, tdi, tdo, trst, tms,
               input cts,
               ref FSM_Event,
               ref UPDATE_DR_Done_Event, UPDATE_IR_Done_Event,
	       input powergood_rst_b);

  // Unused
  modport DUT(input tck, trst, tdi,
              // input tms,
              inout tms,
              output tdo);

  // Unused
  modport MONITOR(input tck, trst, tms, tdi, tdo,
                  input tck_enable, tck_high);

  // initial
  //   trst = 1'b1; // force TAP out of test reset

  // initial
  //   tms = 1'b1; // force TAP to TLR state

  // initial
  //   tck_enable = 0;

  initial
    tck_high = 1'b0;

  always @(posedge tck) -> pos_tck;

endinterface : dfx_jtag_if

`endif // `ifndef DFX_JTAG_IF_SV
