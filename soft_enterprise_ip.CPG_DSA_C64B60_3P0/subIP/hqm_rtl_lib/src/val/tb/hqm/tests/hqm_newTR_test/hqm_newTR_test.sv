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
`include "hqm_newTR_test.svh"

`ifdef NOTEST_IN_MODEL
  module hqm_newTR_test();
  endmodule : hqm_newTR_test 
`endif

