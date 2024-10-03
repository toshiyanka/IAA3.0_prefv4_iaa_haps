// =====================================================================================================
// FileName          : dfx_test_island.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Thu Aug  5 14:28:32 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx test island
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TEST_ISLAND_SV
`define DFX_TEST_ISLAND_SV

// For an example of how the top level module can instantiate/use the dfx_test_island module, see the file dfx_tb.sv.
// One DFx test island should be instantiated for each port.

`ifdef DTEG_UVM_EN
   import uvm_pkg::*;
`endif
import ovm_pkg::*;
`ifdef DTEG_XVM_EN
   import xvm_pkg::*;
`endif
import dfx_tap_env_pkg::*;

`ifdef DTEG_UVM_EN
   `include "uvm_macros.svh"
`endif
`include "ovm_macros.svh"
`ifdef DTEG_XVM_EN
   `include "xvm_macros.svh"
`endif

module dfx_test_island(input int port_num, dfx_jtag_if jif);

  parameter TAP_NUM_PORTS = 2;

  dfx_tap_port_e port;
  dfx_vif_container #(virtual dfx_jtag_if) jtag_vif;

  initial begin
    port = dfx_tap_port_e'(port_num);
    jtag_vif = new();
    // `ovm_info("dfx_test_island", $psprintf("port number = %0d, port = %s", port_num, port.name()), OVM_HIGH)
    `ovm_info("dfx_test_island", $psprintf("port number = %0d, port = %s", port_num, port.name()), OVM_NONE)
    set_config_int("*tap_agent*", "TapNumPorts", TAP_NUM_PORTS); // this will be set multiple times, once for each port
    jtag_vif.set_v_if(jif);
    set_config_object("*tap_agent*", {"jtag_vif_", port.name()}, jtag_vif, 0);
    // `ovm_info("dfx_test_island", {"Defined jtag_vif_", port.name()}, OVM_HIGH)
    `ovm_info("dfx_test_island", {"Defined jtag_vif_", port.name()}, OVM_NONE)
  end

endmodule : dfx_test_island

`endif // `ifndef DFX_TEST_ISLAND_SV
