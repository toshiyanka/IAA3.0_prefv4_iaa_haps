`ifndef PCIE_SEQLIB_PKG
`define PCIE_SEQLIB_PKG


package pcie_seqlib_pkg;
    `include "vip_layering_macros.svh"

    `import_base(ovm_pkg::*)
    `include_base("ovm_macros.svh")

    `import_base(sla_pkg::*)
    `include_base("sla_macros.svh")

    import IosfPkg::*;

  `ifdef HQM_INCLUDE_NON_PORTABLE_SEQ

   `import_mid(hqm_tb_cfg_pkg::*)
    import hqm_saola_pkg::*;
    import hqm_pkg::*;

    `import_base(hcw_transaction_pkg::*)
    `import_mid(hcw_pkg::*)
    `import_base(hqm_cfg_pkg::*)
    `import_base(hqm_cfg_seq_pkg::*)
    `import_base(hqm_integ_pkg::*)
    `import_mid(hqm_tb_cfg_sequences_pkg::*)


    `include_typ("hqm_sla_pcie_base_seq.sv")     // `include_mid
    `include_typ("hqm_sla_pcie_rand_bdf_seq.sv")
    `include_typ("hqm_msix_cfg_seq.sv")          // `include_mid

    `include_typ("pcie_prim_base_seq.sv")
    `include_typ("order_seq.sv")
    `include_typ("hqm_sla_pcie_bar_cfg_seq.sv") // `include_mid
    `include_typ("hqm_sla_pcie_tag_gen_seq.sv")
    `include_typ("hqm_sla_pcie_init_seq.sv")    // `include_mid
    `include_typ("hqm_sla_pcie_flr_sequence.sv")

   `include_typ("hqm_sla_pcie_cfg_seq.sv")
   `include_typ("hqm_sla_pcie_cfg_rd_before_wr_seq.sv")
   `include_typ("hqm_sla_pcie_mem_seq.sv")
   // -- Not required `include_typ("hqm_sla_pcie_hcw_enqueue_sequence.sv")
   // -- Not required `include_typ("hqm_sla_pcie_txn_enqueue_dequeue_sequence.sv")
   `include_typ("hqm_sla_pcie_unsupported_req_seq.sv")
   `include_typ("hqm_sla_pcie_reg_rst_val_chk_sequence.sv")
   `include_typ("hqm_sla_pcie_mem_zero_length_read_sequence.sv")
   `include_typ("hqm_sla_pcie_INTA_seq.sv")
   `include_typ("hqm_sla_pcie_MEM1_seq.sv")
   `include_typ("hqm_sla_pcie_eot_checks_sequence.sv")
   `include_typ("hqm_sla_pcie_eot_diag_reg_chk_seq.sv")
   `include_typ("hqm_sla_pcie_cfg_poison_seq.sv")
   `include_typ("hqm_sla_pcie_cfg_badparity_seq.sv")
   `include_typ("hqm_ue_cpl_seq.sv")
   `include_typ("hqm_sla_pcie_cpl_error_seq.sv")
   `include_typ("hqm_intermediate_rst_cpl_error_seq.sv")
   `include_typ("hqm_sla_pcie_mem_ur_seq.sv")
   `include_typ("hqm_sla_pcie_mem_mtlp_seq.sv")
   `include_typ("hqm_sla_pcie_mem_mtlp_4kb_cross_seq.sv")
   `include_typ("hqm_sla_pcie_mem_ptlp_seq.sv")
   `include_typ("hqm_pcie_aer_header_fp_behavior_masked_error.sv")
   `include_typ("hqm_sla_pcie_mem_error_seq.sv")
   `include_typ("hqm_sla_pcie_cfg_busnum_seq.sv")
   `include_typ("hqm_sla_pcie_cfg_error_seq.sv")
   `include_typ("hqm_sla_pcie_d3_err_chk_seq.sv")
   `include_typ("hqm_sla_pcie_error_pollution_seq.sv")
   `include_typ("mem_packet1.sv")
   `include_typ("hqm_pcie_flr_with_txns_seq.sv")
   `include_typ("hqm_tlp_rsvd_tgl_seq.sv")
   `include_typ("hqm_pasid_disabled_seq.sv")
   `include_typ("hqm_pasid_enabled_seq.sv")
   `include_typ("hqm_sla_pcie_cfg_header_check_seq.sv")
   `include_typ("hqm_addr_within_bar_chk_seq.sv")
   `include_typ("hqm_background_access_with_pasid_seq.sv")
   `include_typ("hqm_sla_pcie_err_report_dis_seq.sv")
   `include_typ("hqm_pcie_b2b_single_err_seq.sv")
   
   `include_typ("hqm_pcie_header_sweep_seq.sv")
   `include_typ("hqm_tlp_length_seq.sv")
   `include_typ("hqm_tlp_fbe_lbe_seq.sv")
   `include_typ("hqm_fuse_load_chk_seq.sv")
   `include_typ("hqm_pcie_unalloc_bar_access_seq.sv")
   `include_typ("hqm_cmd_seq.sv")
   `include_typ("hqm_pcie_bar_size_check_seq.sv")
   `include_typ("hqm_pasid_variation_seq.sv")
   //`include_typ("hqm_pcie_rsvd_type_wrap_seq.sv")

  `endif
endpackage: pcie_seqlib_pkg;
`endif
