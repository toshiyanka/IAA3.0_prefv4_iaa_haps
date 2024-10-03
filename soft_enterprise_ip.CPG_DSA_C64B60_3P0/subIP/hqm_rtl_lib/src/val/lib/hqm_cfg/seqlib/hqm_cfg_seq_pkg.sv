`ifndef HQM_CFG_SEQ_PKG__SV
`define HQM_CFG_SEQ_PKG__SV

package hqm_cfg_seq_pkg;
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

   import hqm_AW_pkg::*;           //--rtl
   import hqm_pkg::*;

   `import_mid(hqm_cfg_pkg::*)
   `import_mid(hcw_pkg::*)
   `import_mid(hcw_transaction_pkg::*)
   `import_mid(hcw_sequences_pkg::*)


`ifndef HQM_IP_TB_OVM
   `include_mid("hqm_cfg_base_seq_uvm.sv")
   `include_mid("hqm_cfg_seq_uvm.sv")

   `include_mid("hqm_cfg_file_mode_seq_uvm.sv")
   `include_mid("hqm_cfg_file_mode_seq_no_err_uvm.sv")
   `include_mid("hqm_cfg2_file_mode_seq_uvm.sv")
   `include_mid("hqm_cfg_eot_file_mode_seq_uvm.sv")
   `include_mid("hqm_cfg_eot_post_file_mode_seq_uvm.sv")
   `include_mid("hqm_cfg_user_data_file_mode_seq_uvm.sv")
   `include_mid("hqm_eot_rd_seq_uvm.sv")
   `include_mid("hqm_eot_status_seq_uvm.sv")
   `include_mid("hqm_hcw_eot_file_mode_seq_uvm.sv")
   `include_mid("hqm_hcw_cfg_seq_uvm.sv")
   `include_mid("hqm_eot_status_w_override_seq_uvm.sv")
   `include_mid("hqm_eot_check_seq_uvm.sv")
`else
   `include_mid("hqm_cfg_base_seq.sv")
   `include_mid("hqm_cfg_seq.sv")

   `include_mid("hqm_cfg_file_mode_seq.sv")
   `include_mid("hqm_cfg_file_mode_seq_no_err.sv")
   `include_mid("hqm_cfg2_file_mode_seq.sv")
   `include_mid("hqm_cfg_eot_file_mode_seq.sv")
   `include_mid("hqm_cfg_eot_post_file_mode_seq.sv")
   `include_mid("hqm_cfg_user_data_file_mode_seq.sv")
   `include_mid("hqm_eot_rd_seq.sv")
   `include_mid("hqm_eot_status_seq.sv")
   `include_mid("hqm_hcw_eot_file_mode_seq.sv")
   `include_mid("hqm_hcw_cfg_seq.sv")
   `include_mid("hqm_eot_status_w_override_seq.sv")
   `include_mid("hqm_eot_check_seq.sv")
`endif

endpackage

`endif
