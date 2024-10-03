`ifndef HCW_PKG__SV
`define HCW_PKG__SV

package hcw_pkg;

  `include "vip_layering_macros.svh"

  `import_base(uvm_pkg::*)
  `include_base("uvm_macros.svh")

  `import_base(sla_pkg::*)
  `include_base("slu_macros.svh")

`ifdef XVM
   import ovm_pkg::*;
   import xvm_pkg::*;
   `include "ovm_macros.svh"
   `include "sla_macros.svh"
`endif


   `import_base(hcw_transaction_pkg::*)
   `import_base(hqm_cfg_pkg::*)

`ifndef HQM_IP_TB_OVM
   `include_mid("intr_transaction_uvm.sv")
   `include_mid("hqm_tb_hcw_scoreboard_uvm.sv")
`else
   `include_mid("intr_transaction.sv")
   `include_mid("hqm_tb_hcw_scoreboard.sv")
`endif

endpackage

`endif
