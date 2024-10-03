`ifdef NOTEST_IN_MODEL
  `include "ovm_macros.svh"
  `include "sla_macros.svh"

  import ovm_pkg::*;
  import sla_pkg::*;
  import ovm_ml::*;

// `include "yam.vh"
  `include "hqm_base_test.sv"
 // `include "mem_packet.sv"
`endif

// The test itself:
`include "unsupport_cmd_sai_test.svh"
//`include  "hqm_iosf_prim_pf_dump_seq1.sv"

`ifdef NOTEST_IN_MODEL
  module unsupport_cmd_sai_test();
  endmodule : unsupport_cmd_sai_test
`endif

