// =====================================================================================================
// FileName          : dfx_base_sequence.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri Jun 11 11:11:53 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx base sequence/test
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_BASE_SEQUENCE_SV
`define DFX_BASE_SEQUENCE_SV

virtual class dfx_base_sequence extends ovm_sequence;

  dfx_tap_env my_tap_env;
  dfx_tap_agent my_tap_agent;

  function new(string name = "dfx_base_sequence");
    super.new(name);

    `ovm_info("dfx_base_sequence", "new() invoked", OVM_HIGH)
    /*
     * Need to figure out how to do this without Saola.  Or if it's even useful.
     *
     if (!$cast(my_tap_env, ...::get_comp_by_type("dfx_tap_env")))
       `ovm_fatal("dfx_base_sequence", "Could not find dfx_tap_env my_tap_env")
     if (!$cast(my_tap_agent, ...::get_comp_by_type("dfx_tap_agent")))
       `ovm_fatal("dfx_base_sequence", "Could not find dfx_tap_agent my_tap_agent")
     */
  endfunction : new

endclass : dfx_base_sequence

`endif // `ifndef DFX_BASE_SEQUENCE_SV
