`ifdef NOTEST_IN_MODEL
  `include "ovm_macros.svh"
  `include "sla_macros.svh"

  import ovm_pkg::*;
  import sla_pkg::*;
  import ovm_ml::*;

// `include "yam.vh"
  `include "hqm_base_test.sv"
 // `include "cfg_packet.sv"
`endif

// The test itself:
`include "cfg_generic_test.svh"
//`include  "hqm_iosf_prim_pf_dump_seq1.sv"

`ifdef NOTEST_IN_MODEL
  module cfg_generic_test();
  endmodule : cfg_generic_test
`endif

