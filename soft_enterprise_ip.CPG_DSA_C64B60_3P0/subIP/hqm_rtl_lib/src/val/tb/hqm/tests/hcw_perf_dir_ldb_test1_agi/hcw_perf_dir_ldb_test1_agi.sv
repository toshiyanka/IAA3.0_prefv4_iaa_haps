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
`include "hcw_perf_dir_ldb_test1_agi.svh"

`ifdef NOTEST_IN_MODEL
  module hcw_perf_dir_ldb_test1_agi();
  endmodule : hcw_perf_dir_ldb_test1_agi 
`endif

