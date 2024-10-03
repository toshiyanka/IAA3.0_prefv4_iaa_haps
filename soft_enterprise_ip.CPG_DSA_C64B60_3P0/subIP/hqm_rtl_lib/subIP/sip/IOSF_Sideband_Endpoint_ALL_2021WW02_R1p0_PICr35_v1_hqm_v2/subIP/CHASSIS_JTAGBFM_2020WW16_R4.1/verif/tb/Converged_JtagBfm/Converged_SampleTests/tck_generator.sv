// =====================================================================================================
// FileName          : tck_generator.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Mon May 24 14:50:34 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// Module to generate TCK (clock) signal. The TCK half period is either specified as a plusarg (this
// method takes precedence) or is generated randomly, and used to generate a TCK with 50% duty
// cycle.  The TCK half period is specified/generated as an integer which denotes the number of time
// units.
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef TCK_GENERATOR_SV
`define TCK_GENERATOR_SV

`define DFX_MIN_TCK_FACTOR              3 // 3 * system clock; determined by design constraints
`define DFX_MAX_TCK_FACTOR              7 // 7 * system clock; arbitrary - determines maximum TAP execution speed

// `ifndef TB_TOP
// `define TB_TOP system_tb
// `endif

import ovm_pkg::*;
`include "ovm_macros.svh"
import dfx_tap_env_pkg::*;

// Randomization class for the TCK generator.
//
class tck_generator_randomization;
  rand int halfTCKPeriod;

  // Note!!! The XMR to the system clock will need to change if/when the system clock is generated
  // by a different module.
  constraint c_halfTCKPeriod {
    // halfTCKPeriod >= `DFX_MIN_TCK_FACTOR * `TOP.sysclk_gen.clkRnd.halfClkPeriod;
    halfTCKPeriod >= `DFX_MIN_TCK_FACTOR * 4;
    // halfTCKPeriod <= `DFX_MAX_TCK_FACTOR * `TOP.sysclk_gen.clkRnd.halfClkPeriod;
    halfTCKPeriod <= `DFX_MAX_TCK_FACTOR * 8;
  }
endclass : tck_generator_randomization

// module tck_generator(input dfx_tap_port_e port, output dfx_node_t tckout);
module tck_generator(input int port_i, output dfx_node_t tckout);
  tck_generator_randomization TCKRnd;
  string s;
  dfx_tap_port_e port;

  initial begin
    #0;
    TCKRnd = new();

    port = dfx_tap_port_e'(port_i);

    // If a TCK period was provided as a plusarg, use it.
    if ($test$plusargs({"halfTCKPeriod_", port.name()})) begin
      TCKRnd.c_halfTCKPeriod.constraint_mode(0);
      TCKRnd.halfTCKPeriod.rand_mode(0);

      $value$plusargs({"halfTCKPeriod_", port.name(), "=%d"}, TCKRnd.halfTCKPeriod);
    end

    for (int i = 0; i < port; i++)
      assert(TCKRnd.randomize()); // introduce different "randomness" into each TCK generator

    dfx_randomize_tck_period: assert(TCKRnd.randomize()) begin
      // $display("tck_generator: TCK Period for TAP port %s = %0d", port.name(), TCKRnd.halfTCKPeriod * 2);
      $sformat(s, "TCK Period for TAP port %s = %0d", port.name(), TCKRnd.halfTCKPeriod * 2);
      `ovm_info("tck_generator", s, OVM_HIGH)
    end
    else begin
      // TCKRnd.halfTCKPeriod = `DFX_MAX_TCK_FACTOR * `TOP.sysclk_gen.clkRnd.halfClkPeriod; // a pathological case
      TCKRnd.halfTCKPeriod = `DFX_MAX_TCK_FACTOR * 8;
      // $display("tck_generator::TCK Period for TAP port %s couldn't be randomized, setting to: %0d", port.name(), TCKRnd.halfTCKPeriod * 2);
      $sformat(s, "TCK Period for TAP port %s couldn't be randomized, setting to: %0d", port.name(), TCKRnd.halfTCKPeriod * 2);
      `ovm_info("tck_generator", s, OVM_HIGH)
    end

    tckout = 1'b0; // initial clock value

    // Generate TCK, always 50% duty cycle.
    forever begin
      #(TCKRnd.halfTCKPeriod) tckout = !tckout;
    end
  end
endmodule : tck_generator

`endif // `ifndef TCK_GENERATOR_SV
