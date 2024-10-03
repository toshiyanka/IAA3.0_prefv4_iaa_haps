`ifdef NOTEST_IN_MODEL
  `include "ovm_macros.svh"
  `include "sla_macros.svh"

  import ovm_pkg::*;
  import sla_pkg::*;
  import ovm_ml::*;

// `include "yam.vh"
  `include "hqm_base_test.sv"
`endif

// The test itself:
`include "hqm_system_error_burst_test/hqm_system_error_burst_test.svh"

`ifdef NOTEST_IN_MODEL
  module hqm_system_error_burst_test();
  endmodule : hqm_system_error_burst_test 
`endif

