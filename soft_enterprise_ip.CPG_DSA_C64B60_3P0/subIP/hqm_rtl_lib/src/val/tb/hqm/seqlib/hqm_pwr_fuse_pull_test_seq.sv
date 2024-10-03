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
// File   : hqm_pwr_fuse_pull_test_seq.sv
// Author : rsshekha
// Description :
//
//   sequence to verify the fuse load registers are uneffected by the Device state change 
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

import IosfPkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_pwr_fuse_pull_test_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_fuse_pull_test_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_fuse_pull_test_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(sel_cold_reset,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_fuse_pull_test_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(sel_cold_reset)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      sel_cold_reset;
  constraint soft_sel_cold_reset { soft sel_cold_reset == 0;}       

  function new(string name = "hqm_pwr_fuse_pull_test_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_fuse_pull_test_seq_stim_config

class hqm_pwr_fuse_pull_test_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_fuse_pull_test_seq)

  bit [31:0]            hqm_fuse_values;
  string                fuse_string = "0x00000000", diff_fuse_string = "0x00000000", ref_name = "hqm_pf_cfg_i";
  longint               lfuse_val, diff_lfuse_val;

  rand hqm_pwr_fuse_pull_test_seq_stim_config        cfg;

  hqm_sla_pcie_init_seq                    pcie_init;
  hqm_reset_init_sequence                  warm_rst_seq;
  hqm_cold_reset_sequence                  cold_rst_seq; 

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_fuse_pull_test_seq_stim_config);

  function new(string name = "hqm_pwr_fuse_pull_test_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_fuse_pull_test_seq_stim_config::type_id::create("hqm_pwr_fuse_pull_test_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task compare_fuses(input bit [31:0] fuse_val, int skip_mmio_regs);

endclass : hqm_pwr_fuse_pull_test_seq

task hqm_pwr_fuse_pull_test_seq::compare_fuses(input bit [31:0] fuse_val, int skip_mmio_regs);
  compare("hqm_pf_cfg_i","revision_id_class_code","ridl",SLA_FALSE,fuse_val[11: 8]);
  compare("hqm_pf_cfg_i","revision_id_class_code","ridu",SLA_FALSE,fuse_val[15:12]);
  if (!skip_mmio_regs) begin 
     compare("hqm_sif_csr","hqm_pulled_fuses_0","fuses",SLA_FALSE,fuse_val[31:0]);
     compare("config_master","cfg_pm_status","fuse_proc_disable",SLA_FALSE,fuse_val[0]);
     compare("config_master","cfg_pm_status","fuse_force_on",SLA_FALSE,fuse_val[1]);
  end 
endtask: compare_fuses    

task hqm_pwr_fuse_pull_test_seq::body();

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_fuse_pull_test_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  $value$plusargs("HQM_TB_FUSE_VALUES=%s",fuse_string);
  if (lvm_common_pkg::token_to_longint(fuse_string,lfuse_val) == 0) begin
    `ovm_error("hqm_pwr_fuse_pull_test_seq",$psprintf("+HQM_TB_FUSE_VALUES=%s not a valid integer value",fuse_string))
    return;
  end
  hqm_fuse_values = lfuse_val[31:0];
  compare_fuses(hqm_fuse_values, 0);
  pmcsr_ps_cfg(`HQM_D3STATE);
  // reset the power gated domain registers in ral mirror.
  ral.reset_regs("D3HOT","vcccfn_gated",0);
  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
  compare_fuses(hqm_fuse_values, 1);
  pmcsr_ps_cfg(`HQM_D0STATE);
  compare_fuses(hqm_fuse_values, 0);
  if (!cfg.sel_cold_reset) begin 
     `ovm_info(get_full_name(),$sformatf("\n generating warm reset  \n"),OVM_LOW)
     `ovm_do(warm_rst_seq)
  end
  else begin
     `ovm_info(get_full_name(),$sformatf("\n generating cold reset  \n"),OVM_LOW)
     `ovm_do(cold_rst_seq)
  end
  ral.reset_regs();
  reset_tb(); // After D3hot scoreboard and prim_mon need to be reset
  $value$plusargs("HQM_TB_FUSE_VALUES_DIFF=%s",diff_fuse_string);
  if (lvm_common_pkg::token_to_longint(diff_fuse_string,diff_lfuse_val) == 0) begin
    `ovm_error("hqm_pwr_fuse_pull_test_seq",$psprintf("+HQM_TB_FUSE_VALUES_DIFF=%s not a valid integer value",diff_fuse_string))
    return;
  end
  hqm_fuse_values = diff_lfuse_val[31:0];
  `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
  `ovm_do(pcie_init)
  compare_fuses(hqm_fuse_values, 0);
  pmcsr_ps_cfg(`HQM_D3STATE);
  // reset the power gated domain registers in ral mirror.
  ral.reset_regs("D3HOT","vcccfn_gated",0);
  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
  compare_fuses(hqm_fuse_values, 1);
  pmcsr_ps_cfg(`HQM_D0STATE);
  compare_fuses(hqm_fuse_values, 0);
  if (!cfg.sel_cold_reset) begin 
     `ovm_info(get_full_name(),$sformatf("\n generating warm reset  \n"),OVM_LOW)
     `ovm_do(warm_rst_seq)
  end
  else begin
     `ovm_info(get_full_name(),$sformatf("\n generating cold reset  \n"),OVM_LOW)
     `ovm_do(cold_rst_seq)
  end
  ral.reset_regs();
  reset_tb(); // After D3hot scoreboard and prim_mon need to be reset
  hqm_fuse_values = lfuse_val[31:0];
  `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
  `ovm_do(pcie_init)
  compare_fuses(hqm_fuse_values, 0);
  pmcsr_ps_cfg(`HQM_D3STATE);
  // reset the power gated domain registers in ral mirror.
  ral.reset_regs("D3HOT","vcccfn_gated",0);
  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
  compare_fuses(hqm_fuse_values, 1);
  pmcsr_ps_cfg(`HQM_D0STATE);
  compare_fuses(hqm_fuse_values, 0);
  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_fuse_pull_test_seq ended \n"),OVM_LOW)
  poll_rst_done();
endtask : body
