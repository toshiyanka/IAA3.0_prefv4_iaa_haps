// =====================================================================================================
// FileName          : dfx_base_test.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     : Fri Jun 11 11:11:53 CDT 2010
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFx base test
//
// For use in standalone DFx testbench only!
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_BASE_TEST_SV
`define DFX_BASE_TEST_SV

class dfx_base_test extends ovm_test;

  `ovm_component_utils(dfx_base_test)

  dfx_env env;

  function new(string name = "dfx_base_test", ovm_component parent = null);
    super.new(name, parent);
  endfunction : new

  virtual function void build();
    super.build();

    set_config_int("*", "recording_detail", 1);

    env = dfx_env::type_id::create("env", this);

  endfunction : build

  virtual function void connect();
    super.connect();

    ovm_default_table_printer.knobs.name_width = 75;
    ovm_default_table_printer.knobs.value_width = 20;
    ovm_default_printer = ovm_default_table_printer;

  endfunction: connect

  task run();
    `ovm_info(get_type_name(), "Running DFX testbench ...", OVM_NONE)
  endtask : run

endclass : dfx_base_test

`endif // `ifndef DFX_BASE_TEST_SV
