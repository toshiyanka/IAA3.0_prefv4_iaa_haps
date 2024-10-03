`ifndef HQM_CFG_PKG__SV
`define HQM_CFG_PKG__SV

package hqm_cfg_pkg;
  `include "vip_layering_macros.svh"

  `import_base(uvm_pkg::*)
  `include_base("uvm_macros.svh")
  `import_base(sla_pkg::*)
  `include_base("sla_macros.svh")

  `import_base(sla_pkg::*)
  `include_base("slu_macros.svh")

`ifdef XVM
  `import_base(ovm_pkg::*)
  `import_base(xvm_pkg::*)
  `include_base("ovm_macros.svh")
  `include_base("sla_macros.svh")
`endif


   `import_base(lvm_common_pkg::*)

   import hqm_AW_pkg::*;               //--rtl
   import hqm_core_pkg::*;
   import hqm_pkg::*;
   import hqm_system_pkg::*;
   import HqmAtsPkg::*;

  `import_mid(hcw_transaction_pkg::*)

  `include "SAI_include.vh"
  `include "sai_8bit_include.vh"

  `include_mid("hqm_cfg_types.sv")


`ifndef HQM_IP_TB_OVM
  `include_mid("hqm_command_parser_uvm.sv")
  `include_mid("hqm_cfg_register_ops_uvm.sv")
  `include_mid("hqm_cfg_uvm.sv")   
`else
  `include_mid("hqm_command_parser.sv")
  `include_mid("hqm_cfg_register_ops.sv")
  `include_mid("hqm_cfg.sv")   
`endif

endpackage

`endif
