`ifdef NOTEST_IN_MODEL
  `include "ovm_macros.svh"
  `include "sla_macros.svh"

  import ovm_pkg::*;
  import sla_pkg::*;
  import ovm_ml::*;

  `include "hqm_base_test.sv"
`endif

// The test itself:
`include "cq_dead_wd_timer.svh"

`ifdef NOTEST_IN_MODEL
  module cq_dead_wd_timer();
  endmodule : cq_dead_wd_timer 
`endif

