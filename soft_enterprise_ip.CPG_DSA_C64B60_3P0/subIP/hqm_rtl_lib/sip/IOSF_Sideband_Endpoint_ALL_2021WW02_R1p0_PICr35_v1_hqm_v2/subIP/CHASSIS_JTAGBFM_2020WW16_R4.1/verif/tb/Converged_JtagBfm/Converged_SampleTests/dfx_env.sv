// =====================================================================================================
// FileName          : dfx_env.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Dec 31 13:43:08 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFX environment
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_ENV_SV
`define DFX_ENV_SV

import ovm_pkg::*;
`include "ovm_macros.svh"

import dfx_tap_env_pkg::*;
import dfx_tap_seqlib_pkg::*;
`include "dfx_tap_macros.svh"

class dfx_env extends ovm_env;

  bit enable_dfx = 1'b0;
  dfx_tap_env tap_env;

  `ovm_component_utils_begin(dfx_env)
    `ovm_field_int(enable_dfx, OVM_DEFAULT)
  `ovm_component_utils_end

  function new(string name = "dfx_env", ovm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build();
    super.build();

`ifdef _A_TAP_BFM_
    `_a_tap_bfm_
`endif // `ifdef _A_TAP_BFM_

`ifdef _B_TAP_BFM_
    `_b_tap_bfm_
`endif // `ifdef _B_TAP_BFM_

    if (enable_dfx) begin
      set_config_int("*tap_agent*", "CLTAP", 1);
      set_config_int("*tap_agent*", "STAP0", 1);
      set_config_int("*tap_agent*", "STAP1", 1);
      set_config_int("*tap_agent*", "STAP2", 1);
      set_config_int("*tap_agent*", "STAP3", 1);
      set_config_int("*tap_agent*", "STAP4", 1);
      set_config_int("*tap_agent*", "STAP5", 1);
      set_config_int("*tap_agent*", "STAP6", 1);
      set_config_int("*tap_agent*", "STAP7", 1);
      set_config_int("*tap_agent*", "STAP8", 1);
      set_config_int("*tap_agent*", "STAP9", 1);
      set_config_int("*tap_agent*", "STAP10", 1);
      set_config_int("*tap_agent*", "STAP11", 1);
      set_config_int("*tap_agent*", "STAP12", 1);
      set_config_int("*tap_agent*", "STAP13", 1);
      set_config_int("*tap_agent*", "STAP14", 1);
      set_config_int("*tap_agent*", "STAP15", 1);
      set_config_int("*tap_agent*", "STAP16", 1);
      set_config_int("*tap_agent*", "STAP17", 1);
      set_config_int("*tap_agent*", "STAP18", 1);
      set_config_int("*tap_agent*", "STAP19", 1);
      set_config_int("*tap_agent*", "STAP20", 1);
      set_config_int("*tap_agent*", "STAP21", 1);
      set_config_int("*tap_agent*", "STAP22", 1);
      set_config_int("*tap_agent*", "STAP23", 1);
      set_config_int("*tap_agent*", "STAP24", 1);
      set_config_int("*tap_agent*", "STAP25", 1);
      set_config_int("*tap_agent*", "STAP26", 1);
      set_config_int("*tap_agent*", "STAP27", 1);
      set_config_int("*tap_agent*", "STAP28", 1);
      set_config_int("*tap_agent*", "STAP29", 1);

      tap_env = dfx_tap_env::type_id::create("tap_env", this);
    end

   endfunction : build

  function void connect();
    super.connect();
  endfunction : connect

endclass : dfx_env

`endif // `ifndef DFX_ENV_SV
