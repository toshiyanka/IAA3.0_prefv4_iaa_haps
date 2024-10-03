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
// File   : hqm_integ_seq_pkg.sv
// Author : Mike Betker
//
// Description :
//
// Package contains sequence files included in hqm_integ_lib
//------------------------------------------------------------------------------

package hqm_integ_seq_pkg;

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

  `import_mid(hcw_transaction_pkg::*)
  `import_mid(hcw_pkg::*)
  `import_mid(hqm_cfg_seq_pkg::*)
  `import_base(hqm_integ_pkg::*)

`ifndef HQM_IP_TB_OVM
      `include_mid("hqm_base_cfg_seq_uvm.sv")
      `include_mid("hqm_cfg_reset_seq_uvm.sv")
      `include_mid("hqm_sm_pf_cfg_seq_uvm.sv")
      `include_mid("hqm_wait_for_reset_done_seq_uvm.sv")
      `include_mid("hqm_cfg_file_seq_uvm.sv")
      `include_mid("hcw_test0_hqm_cfg_seq_uvm.sv")
      `include_mid("hcw_test0_cfg_seq_uvm.sv")
      `include_mid("hcw_test0_hcw_seq_uvm.sv")
      `include_mid("hqm_idle_test_pmcs_disable_seq_uvm.sv")
      `include_mid("hqm_idle_test_idle_seq_uvm.sv")  
      `include_mid("hqm_idle_test_seq_uvm.sv")
      `include_mid("hcw_pf_test_stim_dut_view_uvm.sv")
      `include_mid("hcw_pf_test_enable_msix_cfg_seq_uvm.sv")
      `include_mid("hcw_pf_test_hqm_cfg_seq_uvm.sv")
      `include_mid("hcw_pf_test_cfg_seq_uvm.sv")   
      `include_mid("hcw_pf_test_hcw_seq_uvm.sv")
      `include_mid("hcw_pf_test_multi_hcw_seq_uvm.sv")
      `include_mid("hcw_sciov_test_stim_dut_view_uvm.sv")
      `include_mid("hcw_sciov_test_enable_ims_cfg_seq_uvm.sv")
      `include_mid("hcw_sciov_test_enable_msix_cfg_seq_uvm.sv")
      `include_mid("hcw_sciov_test_hqm_cfg_seq_uvm.sv") 
      `include_mid("hcw_sciov_test_cfg_seq_uvm.sv")
      `include_mid("hcw_sciov_test_hcw2_seq_uvm.sv")
      `include_mid("hcw_test_cfg_file_seq_uvm.sv")
      `include_mid("hcw_enqtrf_test_enable_msix_cfg_seq_uvm.sv")
    `ifdef IP_TYP_TE
    `else
      `include_mid("hcw_enqtrf_test_hcw_seq_uvm.sv")
    `endif
      `include_mid("hqm_msix_isr_seq_uvm.sv")	 
      `include_mid("hqm_ims_isr_seq_uvm.sv") 
      `include_mid("hqm_gen_msix_seq_uvm.sv")
      `include_mid("hqm_pcie_corr_err_seq_uvm.sv")
      `include_mid("hqm_pcie_nonfatal_err_seq_uvm.sv")    
      `include_mid("hqm_pcie_fatal_err_seq_uvm.sv")
      `include_mid("hqm_eot_status_w_override_seq_uvm.sv")
      `include_mid("hqm_eot_check_seq_uvm.sv")   

`else
      `include_mid("hqm_base_cfg_seq.sv")
      `include_mid("hqm_cfg_reset_seq.sv")
      `include_mid("hqm_sm_pf_cfg_seq.sv")
      `include_mid("hqm_wait_for_reset_done_seq.sv")
      `include_mid("hqm_cfg_file_seq.sv")
      `include_mid("hcw_test0_hqm_cfg_seq.sv")
      `include_mid("hcw_test0_cfg_seq.sv")
      `include_mid("hcw_test0_hcw_seq.sv")
      `include_mid("hqm_idle_test_pmcs_disable_seq.sv")
      `include_mid("hqm_idle_test_idle_seq.sv")  
      `include_mid("hqm_idle_test_seq.sv")
      `include_mid("hcw_pf_test_stim_dut_view.sv")
      `include_mid("hcw_pf_test_enable_msix_cfg_seq.sv")
      `include_mid("hcw_pf_test_hqm_cfg_seq.sv")
      `include_mid("hcw_pf_test_cfg_seq.sv")   
      `include_mid("hcw_pf_test_hcw_seq.sv")
      `include_mid("hcw_pf_test_multi_hcw_seq.sv")
      `include_mid("hcw_pf_vf_test_stim_dut_view.sv")
      `include_mid("hcw_pf_vf_test_enable_int_cfg_seq.sv")
      `include_mid("hcw_pf_vf_test_hqm_cfg_seq.sv")
      `include_mid("hcw_pf_vf_test_cfg_seq.sv")
      `include_mid("hcw_pf_vf_test_hcw_seq.sv") 
      `include_mid("hcw_sciov_test_stim_dut_view.sv")
      `include_mid("hcw_sciov_test_enable_ims_cfg_seq.sv")
      `include_mid("hcw_sciov_test_enable_msix_cfg_seq.sv")
      `include_mid("hcw_sciov_test_hqm_cfg_seq.sv") 
      `include_mid("hcw_sciov_test_cfg_seq.sv")
      `include_mid("hcw_sciov_test_hcw2_seq.sv")
      `include_mid("hcw_test_cfg_file_seq.sv")
      `include_mid("hcw_enqtrf_test_enable_msix_cfg_seq.sv")
    `ifdef IP_TYP_TE
    `else
      `include_mid("hcw_enqtrf_test_hcw_seq.sv")
    `endif
    
      `include_mid("hqm_msix_isr_seq.sv")	 
      `include_mid("hqm_ims_isr_seq.sv") 
    
      `include_mid("hqm_gen_msix_seq.sv")
      `include_mid("hqm_pcie_corr_err_seq.sv")
      `include_mid("hqm_pcie_nonfatal_err_seq.sv")    
      `include_mid("hqm_pcie_fatal_err_seq.sv")
    
      `include_mid("hqm_eot_status_w_override_seq.sv")
      `include_mid("hqm_eot_check_seq.sv")   
`endif

endpackage
