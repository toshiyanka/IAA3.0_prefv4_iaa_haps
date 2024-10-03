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
// File   : hqm_pwr_D0_to_D3hot_to_D0_seq.sv
// Author : rsshekha
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`HQM_PWR_STIM_CLASS_FOR_SEQ_COMMON_CODE(hqm_pwr_D0_to_D3hot_to_D0_seq,flr);

class hqm_pwr_D0_to_D3hot_to_D0_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_D0_to_D3hot_to_D0_seq)

  rand hqm_pwr_D0_to_D3hot_to_D0_seq_stim_config        cfg;

  hqm_pwr_check_cfg_pm_status_for_D0_seq   cfg_pm_status_for_D0;
  hqm_sla_pcie_flr_sequence                D3_to_D0_by_flr;
  hqm_sla_pcie_init_seq                    pcie_init;    

  `HQM_PWR_STIM_LIB_FUNC_NEW_COMMON_CODE(hqm_pwr_D0_to_D3hot_to_D0_seq)

  extern virtual task body();

endclass : hqm_pwr_D0_to_D3hot_to_D0_seq

task hqm_pwr_D0_to_D3hot_to_D0_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;
  sla_ral_field         fields[$];
  string ref_name;
  bit [63:0] D3toD0_event_cnt = 64'h0;
  
  `HQM_PWR_SEQ_TASK_BODY_COMMON_CODE(hqm_pwr_D0_to_D3hot_to_D0_seq)

  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
  // D0active->D3hot->D0uninit (using PMCSR.ps) 
  // D0active->D3hot->D0uninit (using Using FLR) 
  // Entered in D0active, hqm_idle;
  // check hqm is idle or wait;
  D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;

  `ovm_info(get_full_name(),$sformatf(" polling for pgcb_hqm_idle started "),OVM_LOW)
  poll("config_master","cfg_pm_status","pgcb_hqm_idle",SLA_FALSE,1'b1);
  `ovm_info(get_full_name(),$sformatf(" polling for pgcb_hqm_idle ended "),OVM_LOW)

  // read the list of the registers to update them in ral mirror
  `ovm_info(get_full_name(),$sformatf(" update_mirror_val started "),OVM_LOW)
  update_mirror_val();
  `ovm_info(get_full_name(),$sformatf(" update_mirror_val ended "),OVM_LOW)

  // PMCSR.ps = 2'b11;
  pmcsr_ps_cfg(`HQM_D3STATE);

  // reset the power gated domain registers in ral mirror.
  ral.reset_regs("D3HOT","vcccfn_gated",0);

  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset

  // check always on registers are uneffected by power off; 
  `ovm_info(get_full_name(),$sformatf(" check_pcie_cfg_space started "),OVM_LOW)
  check_pcie_cfg_space();
  `ovm_info(get_full_name(),$sformatf(" check_pcie_cfg_space ended "),OVM_LOW)

  `ovm_info(get_full_name(),$sformatf("cfg.flr=%d",cfg.flr),OVM_LOW)

  if (!cfg.flr) begin 
     // PMCSR.ps = 2'b00;
     pmcsr_ps_cfg(`HQM_D0STATE);
     // check always on registers are uneffected by power on;
     `ovm_info(get_full_name(),$sformatf(" check_pcie_cfg_space started "),OVM_LOW)
     check_pcie_cfg_space();
     `ovm_info(get_full_name(),$sformatf(" check_alwayson_mmio_cfg_space started "),OVM_LOW)
     check_alwayson_mmio_cfg_space();
  end   
  else begin    
      `ovm_info(get_full_name(),$sformatf(" calling D3_to_D0_by_flr "),OVM_LOW)
     // check that pf_cfg space is at the reset value; use the inbuilt task in the hqm_pcie_inits_seq; 
     `ovm_do_with(D3_to_D0_by_flr, {test_regs == 1;no_sys_init == 1;}) 
     // reset the ral registers since it's FLR.
     ral.reset_regs("FLR");
     reset_tb(); // After FLR scoreboard and prim_mon need to be reset

    `ovm_info(get_full_name(),$sformatf(" calling pcie_init "),OVM_LOW)
    `ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})
  end

  D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;

  // check reset values of power registers if flr is generated   
   if (cfg.flr) begin  
      `ovm_info(get_full_name(),$sformatf(" check_power_reg branch started "),OVM_LOW)
      check_power_reg();
      compare("config_master","cfg_pm_pmcsr_disable","disable",SLA_FALSE,0);
      `ovm_info(get_full_name(),$sformatf(" check_power_reg branch ended "),OVM_LOW)
   end

   // check power gated registers are at reset value;
    //polling for reset compelted [diagnostic_reset_status]
    poll_rst_done();
   `ovm_info(get_full_name(),$sformatf(" check_powergated_mmio_cfg_space started "),OVM_LOW)
    check_powergated_mmio_cfg_space();
   `ovm_info(get_full_name(),$sformatf(" check_powergated_mmio_cfg_space ended "),OVM_LOW)

   // compare the cfg_pm_status values for power on;
   `ovm_info(get_full_name(),$sformatf(" cfg_pm_status_for_D0 started "),OVM_LOW)
   `ovm_do(cfg_pm_status_for_D0)
   `ovm_info(get_full_name(),$sformatf(" cfg_pm_status_for_D0 ended "),OVM_LOW)

   compare("config_master","cfg_d3tod0_event_cnt_l","count",SLA_FALSE,D3toD0_event_cnt[31:0]);
   compare("config_master","cfg_d3tod0_event_cnt_h","count",SLA_FALSE,D3toD0_event_cnt[63:32]);

  `ovm_info(get_full_name(),$sformatf(" hqm_pwr_D0_to_D3hot_to_D0_seq ended "),OVM_LOW)
  /*

  Run 2 different type of the hqm functional tests before and after the D3 state transition
  */

endtask : body
