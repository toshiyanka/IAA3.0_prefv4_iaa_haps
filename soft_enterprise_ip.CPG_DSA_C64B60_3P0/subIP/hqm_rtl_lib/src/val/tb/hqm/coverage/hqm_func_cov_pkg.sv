`ifndef HQM_FUNC_COV_PKG__SV
`define HQM_FUNC_COV_PKG__SV

`define START_TEMPL(msg) \
ovm_report_info(get_full_name(), $psprintf("%0s -- Start", msg), OVM_DEBUG);

`define END_TEMPL(msg) \
ovm_report_info(get_full_name(), $psprintf("%0s -- End", msg), OVM_DEBUG);

package hqm_func_cov_pkg;
  `include "vip_layering_macros.svh"

  `import_base(ovm_pkg::*)
  `include_base("ovm_macros.svh")

  `import_base(sla_pkg::*)
  `include_base("sla_macros.svh")

    `include "hqm_resources_defines.svh"

    `import_base(hqm_integ_pkg::*)
    import IosfPkg::*;
   `import_base(hqm_cfg_pkg::*)
   `import_base(hcw_transaction_pkg::*)

    `include_mid("hqm_iosf_func_cov.sv")
    `include_mid("hqm_func_cov_collector.sv")
 
endpackage : hqm_func_cov_pkg

`endif //HQM_FUNC_COV_PKG__SV
