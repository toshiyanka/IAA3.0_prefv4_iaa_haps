`ifndef HCW_TRANSACTION_PKG__SV
`define HCW_TRANSACTION_PKG__SV

package hcw_transaction_pkg;

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

   import hqm_pkg::*;                //--src/rtl/hqm_pkg.sv

`ifndef HQM_IP_TB_OVM
   `include_mid("hcw_types.sv")
   `include_mid("hcw_transinfo_uvm.sv")
   `include_mid("hcw_transaction_uvm.sv")
   `include_mid("hqm_pp_cq_status_uvm.sv")
   `include_mid("hqm_cq_gen_check_uvm.sv")
   `include_mid("HqmBusEnums.svh")
   `include_mid("HqmBusTxn_uvm.svh")
`else
   `include_mid("hcw_types.sv")
   `include_mid("hcw_transinfo.sv")
   `include_mid("hcw_transaction.sv")
   `include_mid("hqm_pp_cq_status.sv")
   `include_mid("hqm_cq_gen_check.sv")
   `include_mid("HqmBusEnums.svh")
   `include_mid("HqmBusTxn.svh")
`endif

  `ifdef IP_MID_TE
   typedef slu_enum_utils #(hcw_qtype) hcw_qtype_enum_utils;
  `endif

endpackage

`endif
