// =====================================================================================================
// FileName          : dfx_tap_monitor.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Wed Jun  2 19:27:04 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx TAP monitor
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TAP_MONITOR_SV
`define DFX_TAP_MONITOR_SV

class dfx_tap_monitor extends ovm_monitor;

  dfx_tap_port_e port;

  `ovm_component_utils_begin(dfx_tap_monitor)
    `ovm_field_enum(dfx_tap_port_e, port, OVM_DEFAULT)
  `ovm_component_utils_end

  function new(string name = "dfx_tap_monitor", ovm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run();
    `ovm_info(get_type_name(), {"DFx TAP monitor is running on port ", port.name()}, OVM_NONE)
  endtask : run

endclass : dfx_tap_monitor

`endif // `ifndef DFX_TAP_MONITOR_SV
