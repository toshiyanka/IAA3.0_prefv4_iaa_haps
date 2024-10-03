
`ifndef HQM_RESET_SEQUENCES_PKG__SV
`define HQM_RESET_SEQUENCES_PKG__SV

package hqm_reset_sequences_pkg;
   `include "vip_layering_macros.svh"

   `import_base(ovm_pkg::*)
   `include_base("ovm_macros.svh")

   `import_base(sla_pkg::*)
   `include_base("sla_macros.svh")

   import hqm_reset_pkg::*;


  import "DPI-C" context SLA_VPI_put_value =
    function void hqm_seq_put_value(input chandle handle, input logic [0:0] value);

  `include_typ("hqm_fuse_bypass_seq.sv")

  `include_mid("hqm_reset_unit_sequence.sv")
  //`include_typ("hqm_reset_deassert_sequence.sv")
  `include_mid("hqm_power_up_sequence.sv")
  `include_typ("hqm_power_retention_sequence.sv")
  `include_typ("hqm_power_down_sequence.sv")
  `include_mid("hqm_boot_sequence.sv")
  `include_typ("hqm_warm_reset_sequence.sv")
  //`include_typ("hqm_reset_sequence.sv")
  `include_typ("hqm_cold_reset_sequence.sv")
  `include_typ("hqm_reset_init_sequence.sv")
  `include_typ("hqm_dwr_sequence.sv")
  `include_typ("hqm_hw_reset_force_pwr_on_sequence.sv")
  `include_typ("hqm_hw_reset_force_pwr_off_sequence.sv")

endpackage

`endif

