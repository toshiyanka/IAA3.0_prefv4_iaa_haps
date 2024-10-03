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
// File   : hqm_pwr_pmcsr_disable_flr_D3hot_seq.sv
// Author : rsshekha
//
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the test_seqbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(flr,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(flr)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      flr;
  constraint soft_flr { soft flr == 0;}       

  function new(string name = "hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config

class hqm_pwr_pmcsr_disable_flr_D3hot_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_pmcsr_disable_flr_D3hot_seq)

  rand hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config        cfg;

  hqm_sla_pcie_init_seq           pcie_init;    
  hqm_sla_pcie_flr_sequence       flr_in_D0uninit;
  hqm_tb_cfg_file_mode_seq        i_opt_file_mode_seq;
  hcw_perf_dir_ldb_test1_hcw_seq  hcw_traffic_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config);

  function new(string name = "hqm_pwr_pmcsr_disable_flr_D3hot_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config::type_id::create("hqm_pwr_pmcsr_disable_flr_D3hot_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

endclass : hqm_pwr_pmcsr_disable_flr_D3hot_seq

task hqm_pwr_pmcsr_disable_flr_D3hot_seq::body();

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_pmcsr_disable_flr_D3hot_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
  `ovm_info(get_full_name(),$sformatf("cfg.flr=%d",cfg.flr),OVM_LOW)

  if (!cfg.flr) begin 
     // PMCSR.ps = 2'b11;
     pmcsr_ps_cfg(`HQM_D3STATE);
     // reset the power gated domain registers in ral mirror.
     ral.reset_regs("D3HOT","vcccfn_gated",0);
     reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
     pmcsr_ps_cfg(`HQM_D0STATE);
     `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
     `ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})
  end   
  else begin    
     `ovm_info(get_full_name(),$sformatf("\n calling flr_in_D0uninit \n"),OVM_LOW)
     `ovm_do_with(flr_in_D0uninit, {test_regs == 0;no_sys_init == 1;}) 
     // reset the ral registers since it's FLR.
     ral.reset_regs("FLR");
     reset_tb(); // After FLR scoreboard and prim_mon need to be reset
     `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
     `ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})
  end

  WriteField("config_master","cfg_pm_pmcsr_disable","disable",1'b0);
  `ovm_info(get_full_name(),$sformatf("\n completed cfg_pm_pmcsr_disable \n"),OVM_LOW)

  poll_rst_done();

  i_opt_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_hqm_tb_cfg_opt_file_mode_seq");
  i_opt_file_mode_seq.set_cfg("HQM_SEQ_CFG", 1'b0);
  i_opt_file_mode_seq.start(get_sequencer());

  `ovm_info(get_full_name(),$sformatf("\n completed post i_hqm_tb_cfg_opt_file_mode_seq \n"),OVM_LOW)
  `ovm_do (hcw_traffic_seq)
  `ovm_info(get_full_name(),$sformatf("\n completed post hcw_traffic_seq \n"),OVM_LOW)

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_pmcsr_disable_flr_D3hot_seq ended \n"),OVM_LOW)
     
endtask : body
