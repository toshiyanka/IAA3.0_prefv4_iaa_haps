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
// File   : hqm_pwr_D0_to_D3hot_check_nsr_seq.sv
// Author : rsshekha
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(check_nsr,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(segment,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(check_nsr)
    `stimulus_config_field_rand_int(segment)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      check_nsr;
  rand int                      segment;
  constraint soft_check_nsr { soft check_nsr == 0;}       
  constraint soft_segment { soft segment == 0;}       

  function new(string name = "hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config

class hqm_pwr_D0_to_D3hot_check_nsr_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_D0_to_D3hot_check_nsr_seq)

  rand hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config        cfg;

  hqm_sla_pcie_init_seq                    pcie_init;    
  
  //-- hqm_cfg
  hqm_cfg                       inst_hqm_cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config);

  function new(string name = "hqm_pwr_D0_to_D3hot_check_nsr_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config::type_id::create("hqm_pwr_D0_to_D3hot_check_nsr_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);

    inst_hqm_cfg = hqm_cfg::get();
  endfunction

  extern virtual task body();

endclass : hqm_pwr_D0_to_D3hot_check_nsr_seq

task hqm_pwr_D0_to_D3hot_check_nsr_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;
  sla_ral_field         fields[$];
  string ref_name;
  

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_D0_to_D3hot_check_nsr_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;

  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
  // D0active->D3hot->D0uninit (using PMCSR.ps) 
  // Entered in D0active, hqm_idle;
  // check hqm is idle or wait;

  pwr_seq = "HQM_NSR_SEQ";

  `ovm_info(get_full_name(),$sformatf("\n polling for pgcb_hqm_idle started \n"),OVM_LOW)
  poll("config_master","cfg_pm_status","pgcb_hqm_idle",SLA_FALSE,1'b1);
  `ovm_info(get_full_name(),$sformatf("\n polling for pgcb_hqm_idle ended \n"),OVM_LOW)

  `ovm_info(get_full_name(),$sformatf("\n skip_regs started \n"),OVM_LOW)
  if (cfg.segment == 1) begin  
     skip_regs_by_name("hqm_csr_cp_lo","hqm_sif_csr");
     skip_regs_by_name("hqm_csr_cp_hi","hqm_sif_csr");
     skip_regs_by_name("hqm_csr_rac_lo","hqm_sif_csr");
     skip_regs_by_name("hqm_csr_rac_hi","hqm_sif_csr");
     skip_regs_by_name("hqm_csr_wac_lo","hqm_sif_csr");
     skip_regs_by_name("hqm_csr_wac_hi","hqm_sif_csr");
     skip_regs_by_name("prim_cdc_ctl","hqm_sif_csr");
     skip_regs_by_name("side_cdc_ctl","hqm_sif_csr");
     skip_regs_by_name("iosfp_cgctl","hqm_sif_csr");
     skip_regs_by_name("iosfs_cgctl","hqm_sif_csr");
     `ovm_info(get_full_name(),$sformatf("\n wr_inverse hqm_sif_csr started \n"),OVM_LOW)
      wr_inverse("hqm_sif_csr");
  end
  else if (cfg.segment == 2) begin 
     skip_regs_by_name("cfg_pm_pmcsr_disable","config_master"); 
     skip_regs_by_name("cfg_pm_override","config_master");
     skip_regs_by_name("cfg_clk_switch_override","config_master");
     // skip_regs_by_name("cfg_hqm_pgcb_cdc_lock","config_master"); // doesn't exist now, 30/08/2018
     `ovm_info(get_full_name(),$sformatf("\n wr_inverse config_master started \n"),OVM_LOW)
      wr_inverse("config_master");
  end
  else if (cfg.segment == 3) begin 
     skip_regs_by_name("device_command","hqm_pf_cfg_i");
     skip_regs_by_name("func_bar_l","hqm_pf_cfg_i");
     skip_regs_by_name("func_bar_h","hqm_pf_cfg_i");
     skip_regs_by_name("csr_bar_l","hqm_pf_cfg_i");
     skip_regs_by_name("csr_bar_h","hqm_pf_cfg_i");
     skip_regs_by_name("pcie_cap_device_control","hqm_pf_cfg_i");
     skip_regs_by_name("pm_cap_control_status","hqm_pf_cfg_i");
     skip_regs_by_name("pasid_control","hqm_pf_cfg_i");
     `ovm_info(get_full_name(),$sformatf("\n wr_inverse hqm_pf_cfg_i started \n"),OVM_LOW)
      wr_inverse("hqm_pf_cfg_i");
  end
  else if (cfg.segment == 4) begin 
  end
  `ovm_info(get_full_name(),$sformatf("\n skip_regs ended \n"),OVM_LOW)

  // PMCSR.ps = 2'b11;
  pmcsr_ps_cfg(`HQM_D3STATE);

  // reset the power gated domain registers in ral mirror.
  ral.reset_regs(.powerwell("vcccfn_gated"));

  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset

  // PMCSR.ps = 2'b00;
  pmcsr_ps_cfg(`HQM_D0STATE);

  `ovm_info(get_full_name(),$sformatf("\n polling for CFG_DIAGNOSTIC_RESET_STATUS started \n"),OVM_LOW)
  poll("config_master","cfg_diagnostic_reset_status","hqm_proc_reset_done",SLA_FALSE,1'b1);
  `ovm_info(get_full_name(),$sformatf("\n polling for CFG_DIAGNOSTIC_RESET_STATUS ended \n"),OVM_LOW)

  inst_hqm_cfg.backdoor_mem_init();

  `ovm_info(get_full_name(),$sformatf("\n check_nsr compare branch started \n"),OVM_LOW)
  if (cfg.segment == 1) begin 
     compare_regs("hqm_sif_csr");
  end
  else if (cfg.segment == 2) begin 
     compare_regs("config_master");
  end 
  else if (cfg.segment == 3) begin 
     compare_regs("hqm_pf_cfg_i");
  end 
  else if (cfg.segment == 4) begin 
  end 
  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_D0_to_D3hot_check_nsr_seq ended \n"),OVM_LOW)

endtask : body
