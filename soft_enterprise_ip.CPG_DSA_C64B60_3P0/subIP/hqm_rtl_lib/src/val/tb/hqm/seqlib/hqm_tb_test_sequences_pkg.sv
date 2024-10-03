//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//------------------------------------------------------------------------------
// File   : hqm_tb_cfg_sequences_pkg.sv
// Author : Mike Betker
//
// Description :
//
// Package contains all sequence files. New sequences will be added here.
//------------------------------------------------------------------------------



`ifndef HQM_TB_TEST_SEQUENCES_PKG
`define HQM_TB_TEST_SEQUENCES_PKG
package hqm_tb_test_sequences_pkg;
   `include "vip_layering_macros.svh"

   `import_base(ovm_pkg::*)
   `include_base("ovm_macros.svh")

   `import_base(sla_pkg::*)
   `include_base("sla_macros.svh")

   
  `import_mid(hcw_pkg::*)
  `import_base(hqm_integ_pkg::*)
  `import_base(hqm_integ_seq_pkg::*)

  import hqm_saola_pkg::*;

  `import_base(hqm_cfg_pkg::*)
  `import_base(hqm_cfg_seq_pkg::*)
  `import_base(hqm_tb_cfg_sequences_pkg::*)
  `import_base(hqm_tb_sequences_pkg::*)

   `import_mid(pcie_seqlib_pkg::*)
   `import_base(hqm_reset_sequences_pkg::*)

  import hqm_tap_rtdr_common_val_seq_pkg::*;
  import IosfPkg::*;
  `import_base(hcw_transaction_pkg::*)

`ifdef HQM_INCLUDE_NON_PORTABLE_SEQ
  `include_typ("hqm_tb_hcw_eot_file_mode_seq.sv")
  `include_typ("hqm_background_cfg_seq.sv")
  `include_typ("hqm_random_data_phase_seq.sv")
  `include_typ("hqm_post_config_phase_seq.sv")
  `include_typ("hqm_pre_flush_phase_seq.sv")

  `include_typ("hqm_pwr_base_seq.sv")
  `include_typ("hcw_txn_pwrgate_device_seq.sv")
  `include_typ("hqm_pwr_check_cfg_pm_status_for_D0_seq.sv")
  `include_typ("hqm_pwr_D0_to_D3hot_to_D0_seq.sv")
  `include_typ("hqm_pwr_D0_to_D3hot_check_nsr_seq.sv")
  `include_typ("hqm_pwr_D0_transitions_seq.sv")
  `include_typ("hqm_pwr_warm_reset_in_Dstate_seq.sv")
  `include_typ("hqm_pwr_smoke_seq.sv")
  `include_typ("hqm_pwr_lcp_shift_check_seq.sv")
  `include_typ("hqm_pwr_long_seq.sv")
  `include_typ("hqm_pwr_prochot_user_data_seq.sv")
  `include_typ("hqm_pwr_fuse_test_seq.sv")
  `include_typ("hqm_pwr_fuse_pull_test_seq.sv")
  `include_typ("hcw_perf_dir_ldb_test1_hcw_wrp_seq.sv")
  `include_typ("hqm_pwr_hold_vret_seq.sv")
  `include_typ("hcw_perf_dir_ldb_pkgc_vret_seq.sv")
  `include_typ("hcw_sciov_test_hcw_seq.sv")
  `include_typ("hqm_mra_connect_chk_seq.sv")
  `include_typ("hqm_pwr_mra_trim_in_D3hot_seq.sv")
  `include_typ("hqm_pwr_pmcsr_disable_test_seq.sv")
  `include_typ("hqm_pwr_pmcsr_disable_flr_D3hot_seq.sv")
  `include_typ("hqm_pwr_iosf_transactions_in_D3hot_seq.sv")
  `include_typ("hqm_pwr_override_pm_cfg_control_seq.sv")
  `include_typ("hqm_pwr_pwrgate_req_in_D3hot_seq.sv")
  `include_typ("hqm_hw_reset_force_pwr_seq.sv")
  `include_typ("hqm_hw_reset_force_pwr_seq2.sv")
  `include_typ("hqm_pwr_extra_data_phase_seq.sv")
  `include_typ("hqm_pcie_flush_phase_seq.sv")
  `include_typ("hqm_sla_pcie_flr_sequence.sv")
  `include_typ("hqm_sla_pcie_eot_sequence.sv")
  `include_typ("hqm_prim_n_sb_error_seq.sv")
  `include_typ("hqm_mra_connect_chk_seq.sv")
 
  `include_typ("hqm_iosf_base_seq.sv")
  `include_typ("hqm_iosf_smoke_seq.sv")
  `include_typ("hqm_iosf_credit_check_with_pf_flr_seq.sv")
  `include_typ("hqm_iosf_reg_access_in_side_rst_seq.sv")
  `include_typ("hqm_iosf_extra_data_phase_seq.sv")
  `include_typ("hqm_iosf_sb_cfgwr_rd_seq.sv")
  `include_typ("hqm_iosf_cplD_seq.sv")
  `include_typ("hqm_iosf_cpl_seq.sv")
  `include_typ("hqm_iosf_sb_cpl_seq.sv")
  `include_typ("hqm_iosf_sb_cplD_seq.sv")
  `include_typ("hqm_iosf_sb_unsupport_memwr_seq.sv")
  `include_typ("back2back_unsupport_cplD_seq.sv")
  `include_typ("back2back_cfgrd_badCmdparity_seq.sv")
  `include_typ("back2back_cfgwr_badCmdparity_seq.sv")
  `include_typ("back2back_memrd_badDataparity_seq.sv")
  `include_typ("back2back_memrd_badCmdParity_seq.sv")
  `include_typ("hqm_prim_parity_err_inj_parity_ctl_reg_chk.sv")
  `include_typ("back2back_posted_badcmdparity_seq.sv")
  `include_typ("hqm_iosf_sb_interleaving_flit_seq.sv")
  `include_typ("hqm_iosf_random_ecrc_seq.sv")
  `include_typ("hqm_iosf_sb_test_seq.sv")
  `include_typ("hqm_iosf_sb_mem_access_wo_bar_cfg_seq.sv")
  `include_typ("hqm_iosf_sb_intermediate_reset_prep_between_np_seq.sv")
  `include_typ("hqm_iosf_sb_credit_exhaust_seq.sv")
  `include_typ("hqm_iosf_sb_b2b_cfg_wr_with_bd_read_seq.sv")
  `include_typ("back2back_cfgrd_seq.sv")
  `include_typ("back2back_cfgwr_seq.sv")
  `include_typ("back2back_sb_cfgwr_seq.sv")
  `include_typ("back2back_sb_cfgrd_seq.sv")
  `include_typ("hqm_iosf_sb_memrd_seq.sv")
  `include_typ("back2back_sb_memwr_seq.sv")
  `include_typ("back2back_sb_memrd_seq.sv")
  `include_typ("cfg_genric_seq.sv")
  `include_typ("cfg_genric_parallel_seq.sv")
  `include_typ("mem_generic_seq.sv")
  `include_typ("mem_generic_seq1.sv")
  `include_typ("back2back_memrd_seq1.sv")
  `include_typ("back2back_memrd_seq.sv")
  `include_typ("back2back_posted_seq.sv")
  `include_typ("back2back_posted_seq1.sv")
  `include_typ("back2back_posted_seq2.sv")
  `include_typ("back2back_posted_wrd_seq.sv")
  `include_typ("np_np_seq.sv")
  `include_typ("p_np_seq1.sv")
  `include_typ("p_np_seq.sv")
  `include_typ("hqm_iosf_sb_memwr_np_poison_seq.sv")
  `include_typ("hqm_iosf_sb_poison_cfgrd_seq.sv")
  `include_typ("hqm_iosf_sb_poison_cfgwr_seq.sv")
  `include_typ("hqm_iosf_sb_poison_memwr_seq.sv")
  `include_typ("hqm_iosf_sb_poison_memrd_seq.sv")
  `include_typ("hqm_iosf_sb_unsupported_memrd_seq.sv")
  `include_typ("hqm_iosf_sb_cfgwr_mlf_seq.sv")
  `include_typ("hqm_iosf_sb_unsupported_memwr_np_seq.sv")    
  `include_typ("hqm_iosf_sb_memwr_np_mlf_seq.sv")
  `include_typ("hqm_iosf_sb_memwr_mlf_seq.sv")
  `include_typ("hqm_iosf_sb_memwr_np_seq.sv")
  `include_typ("hqm_iosf_sb_zero_sbe_seq.sv")
  `include_typ("hqm_iosf_sb_memrd_fid_seq.sv")
  `include_typ("hqm_iosf_sb_cfgrd_fid_seq.sv")
  `include_typ("hqm_iosf_sb_cfgwr_fid_seq.sv")
  `include_typ("hqm_iosf_fbe_memwr_seq.sv")
  `include_typ("back2back_fbe_memwr_seq.sv")
  `include_typ("hqm_iosf_fbe_cfgwr_seq.sv")
  `include_typ("hqm_iosf_fbe_cfgrd_seq.sv")
  `include_typ("back2back_cfgwr_fbe_seq.sv")
  `include_typ("back2back_cfgrd_fbe_seq.sv")
  `include_typ("hqm_iosf_fbe_memory_rd_seq.sv")
  `include_typ("back2back_memrd_fbe_seq.sv") 
  `include_typ("hqm_iosf_sb_fbe_memwr_seq.sv")
  `include_typ("hqm_iosf_sb_sbe_memwr_seq.sv") 
  `include_typ("hqm_iosf_sb_fbe_memrd_seq.sv")
  `include_typ("hqm_iosf_sb_sbe_memrd_seq.sv")
  `include_typ("hqm_iosf_sb_fbe_cfgwr_seq.sv")
  `include_typ("hqm_iosf_sb_sbe_cfgwr_seq.sv")
  `include_typ("hqm_iosf_sb_fbe_cfgrd_seq.sv")
  `include_typ("hqm_iosf_sb_sbe_cfgrd_seq.sv")
  `include_typ("back2back_sb_fbe_cfgwr_seq.sv")
  `include_typ("hqm_iosf_sb_fbe_memwr_np_seq.sv")
  `include_typ("hqm_iosf_sb_sbe_memwr_np_seq.sv")
  `include_typ("back2back_fbe_vf_memwr_seq.sv")
  `include_typ("back2back_cfgrd_badDataparity_seq.sv")
  `include_typ("back2back_cfgwr_badDataparity_seq.sv")
  `include_typ("back2back_cfgwr_badtxn_seq.sv")
  `include_typ("back2back_posted_badDataparity_seq.sv")
  `include_typ("back2back_posted_badDataparity_seq1.sv")
  `include_typ("back2back_posted_multierr_seq.sv")
  `include_typ("hqm_iosf_cg_seq.sv")
  `include_typ("hqm_iosf_sb_epspec_opcode_seq.sv")
  `include_typ("np_np_sb_seq.sv")
  `include_typ("np_p_sb_seq.sv")
  `include_typ("p_np_sb_seq.sv")
  `include_typ("p_p_sb_seq.sv")
  `include_typ("np_comp_sb_seq.sv")
  `include_typ("cmp_cmp_sb_seq.sv")

  //sideband unsupported _sequences
  `include_typ("hqm_iosf_sb_unsupported_rd_seq.sv")
  `include_typ("hqm_iosf_sb_unsupported_wr_seq.sv")
  `include_typ("hqm_iosf_sb_unsupported_wr_seq1.sv")
  `include_typ("hqm_iosf_sb_pm_seq.sv")
  `include_typ("hqm_iosf_sb_boot_seq.sv")
  `include_typ("hqm_iosf_sb_global_opcode_seq.sv")


  `include_typ("hqm_iosf_sb_UR_wr_sai_seq.sv")
  `include_typ("back2back_sb_unsupport_sai_wr_seq.sv")  
  `include_typ("hqm_iosf_sb_UR_sai_seq.sv")
  `include_typ("back2back_sb_unsupport_sai_seq.sv")
  `include_typ("hqm_iosf_crd_return_b2b_p_ur_seq.sv")
  `include_typ("hqm_write_once_register_seq.sv")

  `include_typ("hqm_iosf_user_data_phase_seq.sv")
  `include_typ("hqm_iosf_eot_seq.sv")
  `include_typ("hcw_processing_with_intermediate_flr_seq.sv")
  `include_typ("hqm_cfg_with_intermediate_flr_seq.sv")
  `include_typ("hqm_pre_adr_seq.sv")
  `include_typ("hqm_cfg_with_intermediate_primrst_seq.sv")

  `include_typ("hqm_pok_cfg_seq.sv")
  `include_typ("hqm_pok_user_data_seq.sv")
  `include_typ("hqm_pok_flush_seq.sv")

  `include_typ("hqm_system_burst_cfg_seq.sv")
  `include_typ("hqm_system_burst_user_data_seq.sv")
  `include_typ("hqm_system_burst_flush_seq.sv")

  `include_typ("hqm_system_error_burst_cfg_seq.sv")
  `include_typ("hqm_system_error_burst_user_data_seq.sv")
  `include_typ("hqm_system_error_burst_flush_seq.sv")

  `include_typ("hqm_unimp_addr_cfg_seq.sv")
  `include_typ("hqm_unimp_addr_user_data_seq.sv")
  `include_typ("hqm_unimp_addr_flush_seq.sv")

  `include_typ("hqm_pfvf_space_acc_seq.sv")

  `include_typ("hcw_pipeline_stress_cfg_seq.sv")
  `include_typ("hcw_pipeline_stress_user_data_seq.sv")
  `include_typ("hcw_pipeline_stress_flush_seq.sv")

  `include_typ("hqm_hdr_log_cov_user_data_seq.sv")

  `include_typ("cq_dead_wd_timer_seq.sv")
  `include_typ("hqm_flr_rereset_seq.sv")
  `include_typ("hqm_tb_reset_seq.sv")

  `include_typ("hqm_fabric_initiated_clkgating_seq.sv")
  `include_typ("hqm_sciov_intermediate_reset_seq.sv")
  `include_typ("hqm_survivability_patch_seq.sv")
  `include_typ("hqm_eot_survivability_chk_seq.sv")
  `include_typ("back2back_cfgrdwr_seq1.sv")
  `include_typ("back2back_memrdwr_seq2.sv")
  `include_typ("hqm_trigger_seq.sv")
  `include_typ("hqm_hcw_enq_sz_less_than_16B_seq.sv")
  `include_typ("hqm_hcw_pp_addr_aliasing_seq.sv")
  `include_typ("hqm_all_tok_exhaust_seq.sv")
  `include_typ("hqm_walking_1s_sai_hcw_seq.sv")
  `include_typ("hcw_msix_test_hcw_seq.sv")
  `include_typ("hqm_iosf_back2back_error_mwr_seq.sv")
  `include_typ("hqm_mbecc_wr_bad_lut_seq.sv")
  `include_typ("hqm_intermediate_resetprep_between_np_txns.sv")
  `include_typ("hqm_starvation_avoidance_seq.sv")

  `include_typ("hqm_reset_cycle_sequence.svh")
  `include_typ("hcw_d0_d3_d0_test_hcw_seq.sv")
  `include_typ("hqm_ral_base_seq.sv")
  `include_typ("hqm_backdoor_register_access_seq.sv")
  `include_typ("hqm_register_aliasing_check_seq.sv")

  `include_typ("hqmv30_pf_test_seq.sv")
  `include_typ("hqmv30_sciov_test_seq.sv")
`endif

endpackage
`endif //HQM_TB_TEST_SEQUENCES_PKG
