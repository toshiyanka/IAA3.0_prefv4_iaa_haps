// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
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
// -----------------------------------------------------------------------------
// File   : hqm_pwr_D0_transitions_seq.sv
// Author : rsshekha
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`HQM_PWR_STIM_CLASS_FOR_SEQ_COMMON_CODE(hqm_pwr_D0_transitions_seq, flr)

class hqm_pwr_D0_transitions_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_D0_transitions_seq)

  rand hqm_pwr_D0_transitions_seq_stim_config        cfg;

  hqm_pwr_check_cfg_pm_status_for_D0_seq   cfg_pm_status_for_D0;
  hqm_sla_pcie_flr_sequence                D0act_to_D0uninit_by_flr;
  hqm_sla_pcie_init_seq                    pcie_init;    

  `HQM_PWR_STIM_LIB_FUNC_NEW_COMMON_CODE(hqm_pwr_D0_transitions_seq) 

  extern virtual task body();

endclass : hqm_pwr_D0_transitions_seq

task hqm_pwr_D0_transitions_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;
  sla_ral_field         fields[$];
  
  `HQM_PWR_SEQ_TASK_BODY_COMMON_CODE(hqm_pwr_D0_transitions_seq)

  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
  // D0active->D3hot->D0uninit (using PMCSR.ps) 
  // D0active->D3hot->D0uninit (using Using FLR) 
  // Entered in D0active, hqm_idle;
  // check hqm is idle or wait;  
  poll("config_master","cfg_pm_status","pgcb_hqm_idle",SLA_FALSE,1'b1);
  // read the list of the registers to update them in ral mirror
  update_mirror_val(); 
  `ovm_info(get_full_name(),$sformatf(" calling D0act_to_D0uninit_by_flr "),OVM_LOW)
  // check that pf_cfg space is at the reset value; use the inbuilt task in the hqm_pcie_inits_seq; 
  `ovm_do_with(D0act_to_D0uninit_by_flr, {test_regs == 1;no_sys_init == 1;}) 
  ral.reset_regs("FLR");
  reset_tb(); // After FLR scoreboard and prim_mon need to be reset
  `ovm_info(get_full_name(),$sformatf(" calling pcie_init "),OVM_LOW)
  `ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})
  // check reset values of power registers if flr is generated   
  check_power_reg();
  compare("config_master","cfg_pm_pmcsr_disable","disable",SLA_FALSE,0);
  // check power gated registers are at reset value;
  //polling for reset compelted [diagnostic_reset_status]
  poll_rst_done();
  check_powergated_mmio_cfg_space();
  // compare the cfg_pm_status values for power on;
  `ovm_do(cfg_pm_status_for_D0)
  `ovm_info(get_full_name(),$sformatf(" hqm_pwr_D0_transitions_seq ended "),OVM_LOW)
     
endtask : body
