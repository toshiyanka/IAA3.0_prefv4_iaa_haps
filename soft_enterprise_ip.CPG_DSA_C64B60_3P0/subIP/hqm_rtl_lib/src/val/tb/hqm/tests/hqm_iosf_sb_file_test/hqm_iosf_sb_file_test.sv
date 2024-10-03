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
`include "hqm_iosf_sb_file_test.svh"

`ifdef NOTEST_IN_MODEL
  module hqm_iosf_sb_file_test();
  endmodule : hqm_iosf_sb_file_test 
`endif

