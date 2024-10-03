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
`include "hcw_pf_vf_test.svh"

`ifdef NOTEST_IN_MODEL
  module hcw_pf_vf_test();
  endmodule : hcw_pf_vf_test 
`endif

