// =====================================================================================================
// FileName          : dfx_tap_env.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Mar  9 20:42:14 CST 2011
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFX TAP environment
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_ENV_SV
`define DFX_TAP_ENV_SV

class dfx_tap_env extends ovm_env;

  dfx_tap_agent tap_agent;

  `ovm_component_utils(dfx_tap_env)

  function new(string name, ovm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build();
    super.build();

    tap_agent = dfx_tap_agent::type_id::create("tap_agent", this);
   endfunction : build

  function void connect();
    super.connect();
  endfunction : connect

endclass : dfx_tap_env

`endif // `ifndef DFX_TAP_ENV_SV
