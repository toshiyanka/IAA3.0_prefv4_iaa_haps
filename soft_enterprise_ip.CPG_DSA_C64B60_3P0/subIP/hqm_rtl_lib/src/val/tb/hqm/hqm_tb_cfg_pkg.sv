package hqm_tb_cfg_pkg;

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

  import IosfPkg::*;                  //`import_mid(IosfPkg::*)   

`ifndef HQM_IP_TB_OVM
  `include_mid("hqm_tb_cfg_uvm.sv")
  `include_base("hqm_mem_map_cfg_uvm.sv")
`else
  `include_mid("hqm_tb_cfg.sv")
  `include_base("hqm_mem_map_cfg.sv")
`endif

endpackage
