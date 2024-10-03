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



`ifndef HQM_TB_CFG_SEQ_PKG
`define HQM_TB_CFG_SEQ_PKG
   package hqm_tb_cfg_sequences_pkg;
    `include "vip_layering_macros.svh"

    `import_base(ovm_pkg::*)
    `include_base("ovm_macros.svh")

    `import_base(sla_pkg::*)
    `include_base("sla_macros.svh")

    import IosfPkg::*;
    import hqm_saola_pkg::*;

   `import_base(hcw_transaction_pkg::*)
   `import_mid(hcw_pkg::*)
   `import_base(hqm_cfg_seq_pkg::*)
   `import_base(hqm_integ_pkg::*)
   `import_base(hqm_integ_seq_pkg::*)

`ifdef HQM_INCLUDE_NON_PORTABLE_SEQ

      import "DPI-C" context SLA_VPI_put_value =
        function void hqm_seq_put_value(input chandle handle, input logic [0:0] value);

      import "DPI-C" context SLA_VPI_get_value =
        function void hqm_seq_get_value(input chandle handle, output logic [31:0] value);

      `include_typ("hqm_pcie_msg_seq.sv")
      `include_typ("pp_cq_model_seq.sv")
      `include_typ("process_cq_seq.sv")
      `include_typ("hqm_tb_cfg_seq.sv")
      `include_typ("hqm_tb_eot_status_seq.sv")
      `include_typ("hqm_background_cfg_file_mode_seq.sv")
      //NS: Check why commented `include_typ("hqm_survivability_patch_seq.sv")
      //NS: CHeck why commented `include_typ("hqm_eot_survivability_chk_seq.sv")
      `include_typ("hqm_reg_cfg_base_seq.sv")
      `include_typ("hqm_init_seq.sv")
      `include_typ("hqm_tb_cfg_file_mode_seq.sv")
      `include_typ("ral_pfrst_seq.sv")
      `include_typ("hqm_tb_cfg2_file_mode_seq.sv")
      `include_typ("hqm_tb_cfg_user_data_file_mode_seq.sv")
      `include_typ("hqm_tb_cfg_eot_file_mode_seq.sv")
      `include_typ("hqm_tb_cfg_eot_post_file_mode_seq.sv")
      `include_typ("hqm_tb_cfg_opt_file_mode_seq.sv")
      `include_typ("hqm_tb_cfg_pre_file_mode_seq.sv")
      `include_typ("hqm_prim_rst_no_clk_seq.sv")
      `include_typ("hqm_tb_strap_chk_seq.sv")
      `include_typ("hqm_non_standard_warm_reset_seq.sv")
      `include_typ("hqm_tb_hcw_cfg_seq.sv")
      `include_typ("hqm_system_eot_seq.sv")
      `include_typ("hqm_eot_seq.sv")
      `include_typ("hcw_pp_cq_hcw_seq.sv")
      `include_typ("hcw_ldb_pp_cq_hcw_seq.sv")
      `include_typ("hcw_perf_test1_hcw_seq.sv")
      `include_typ("hcw_perf_dir_test1_hcw_seq.sv")
      `include_typ("hqm_base_seq.sv")
      `include_typ("hcw_dir_test_hcw_seq.sv")
      `include_typ("hqm_ral_cfg_seq.sv")
      `include_typ("hqm_sai_access_check_seq.sv")
      `include_typ("hcw_ldb_test_hcw_seq.sv")
      `include_typ("hcw_ldb_test_hcw_smoke_seq.sv")
      `include_typ("hcw_ldb_test_hcw_busnum_seq.sv")
      `include_typ("hcw_ldb_test_hcw_busnum_sciov_seq.sv")
      `include_typ("hqm_msix_busnum_seq.sv")
      `include_typ("hcw_dir_traffic_seq.sv")
      `include_typ("hcw_ldb_traffic_seq.sv")
      `include_typ("hcw_sciov_all_pp_dir_traffic_seq.sv")
      `include_typ("hcw_sciov_all_pp_ldb_traffic_seq.sv")
      `include_typ("hcw_sciov_pf_mix_ldb_traffic_seq.sv")
      `include_typ("hcw_perf_ldb_test1_hcw_seq.sv")
      `include_typ("hqm_ldb_qos_test_hcw_seq.sv")
      `include_typ("hqm_arb_pri_test_hcw_seq.sv")
      `include_typ("hqm_trf_test_hcw_seq.sv")
      `include_typ("hcw_perf_atm_test_hcw_seq.sv")
      `include_typ("hcw_perf_dir_ldb_test1_hcw_seq.sv")
      `include_typ("hcw_perf_dir_ldb_test1_agi_hcw_seq.sv")
      `include_typ("hcw_ingress_check_test_hcw_seq.sv")
      `include_typ("hcw_ingress_token_error_test_hcw_seq.sv")
      `include_typ("hcw_credit_error_seq.sv")
      `include_typ("hqm_visa_seq.sv")
      `include_typ("hqm_visa_security_seq.sv")
      `include_typ("hqm_hw_agitate_seq.sv")
      `include_typ("hqm_fifo_hwm_stress_seq.sv")
      `include_typ("hqm_arm_cmd_seq.sv") 
      `include_typ("hcw_arm_cmd_seq.sv") 
      `include_typ("hcw_rearm_cmd_seq.sv") 
      `include_typ("hcw_cq_threshold_0_seq.sv")
      `include_typ("hcw_all_resources_pf_hcw_seq.sv")
      `include_typ("hqm_ecc_error_seq.sv")
      `include_typ("hcw_enqueuetime_prochotswitch_seq.sv")
      `include_typ("hqm_cial_rearm_check_seq.sv")
      `include_typ("hqm_dir_traffic_wr_optimization_seq.sv")
      `include_typ("hqm_dir_ldb_traffic_wr_optimization_seq.sv")
      `include_typ("hqm_dir_ldb_pad_w_wo_optimization_seq.sv")
      `include_typ("hqm_sciov_enq_stress_seq.sv")
      `include_typ("hqm_sriov_enq_stress_seq.sv")
      `include_typ("hcw_traffic_all_resources_seq.sv")
      `include_typ("hqm_tb_config_file_mode_seq.sv")
      `include_typ("iosf_eot_seq.sv")
      `include_typ("hqm_extra_data_phase_seq.sv")
`ifdef IP_TYP_TE
      `include_typ("hcw_enqtrf_test_hcw_seq.sv")
`endif
      `include_typ("hcw_cial_thrsh_timer_hcw_seq.sv")
      `include_typ("hcw_all_resources_pf_comp_mode_seq.sv")
      `include_typ("hcw_cq_cial_timer_reset_check_seq.sv")       
      `include_typ("hcw_cial_cwdi_seq.sv")
      `include_typ("hcw_cq_cial_depth_timer_int_rearm_seq.sv")
      `include_typ("hqm_parity_check_seq.sv")
      `include_typ("hqm_policy_reg_cfg_seq.sv")


`endif

   endpackage
`endif //HQM_TB_CFG_SEQ_PKG
