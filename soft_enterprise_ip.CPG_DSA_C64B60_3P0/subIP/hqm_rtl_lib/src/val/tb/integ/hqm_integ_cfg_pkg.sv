package hqm_integ_cfg_pkg;
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


`ifndef HQM_IP_TB_OVM
  `include_base("hqm_sla_env.sv")
  `include_base("hqm_fuse_ovrd_config_uvm.sv")
`else
  `include_base("hqm_sla_env.sv")
  `include_base("hqm_fuse_ovrd_config.sv")
`endif

 endpackage : hqm_integ_cfg_pkg  
