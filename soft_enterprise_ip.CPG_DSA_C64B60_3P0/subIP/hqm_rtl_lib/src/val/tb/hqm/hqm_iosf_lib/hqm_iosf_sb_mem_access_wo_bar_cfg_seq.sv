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
// File   : hqm_iosf_sb_mem_access_wo_bar_cfg_seq.sv
// Author : rsshekha
// Description :
//
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config

class hqm_iosf_sb_mem_access_wo_bar_cfg_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_mem_access_wo_bar_cfg_seq,sla_sequencer)

  rand hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config        cfg;

  hqm_iosf_sb_mem_rd_seq                   sb_mem_rd_seq; 
  hqm_iosf_sb_mem_wr_seq                   sb_mem_wr_seq;
  hqm_iosf_sb_cfg_rd_seq                   sb_cfg_rd_seq; 
  hqm_iosf_sb_cfg_wr_seq                   sb_cfg_wr_seq; 
  hqm_sla_pcie_init_seq                    pcie_init;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config);

  function new(string name = "hqm_iosf_sb_mem_access_wo_bar_cfg_seq");
    super.new(name); 
    cfg = hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config::type_id::create("hqm_iosf_sb_mem_access_wo_bar_cfg_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction
  
  extern virtual task body();
endclass : hqm_iosf_sb_mem_access_wo_bar_cfg_seq

task  hqm_iosf_sb_mem_access_wo_bar_cfg_seq::body();
  
  bit [63:0] iosf_addr_mem_sb, addr_dc; 
  string  ref_name_file = "", ref_name_reg = "";
  hqm_config_master_bridge_file         master_regs;
  int cq = 0; 
  string                ral_tb_env_hier = "*.";    // -- Useful with multiple ral instances

  Iosf::data_t          iosf_data_0[], iosf_data_1[], iosf_data_2[], iosf_data_3[];

  apply_stim_config_overrides(1);
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_mem_access_wo_bar_cfg_seq started \n"),OVM_LOW)
  addr_dc  = get_reg_addr("hqm_pf_cfg_i","device_command", "sideband");
  
  iosf_data_0    = new[1];
  iosf_data_1    = new[1];
  iosf_data_2    = new[1];
  iosf_data_3    = new[1];
  iosf_data_0[0] = 32'h00100006;
  iosf_data_1[0] = 32'h00000000;
  iosf_data_2[0] = 32'h00000001;
  iosf_data_3[0] = 32'h00004444;

  `sla_assert($cast(master_regs,           ral.find_file({ral_tb_env_hier,"config_master"})),     ("Unable to get handle to master_regs."))

  `ovm_do_with(sb_cfg_rd_seq, {addr == addr_dc;exp_cplstatus == 2'b00;exp_rsp == 1;})
  `ovm_do_with(sb_cfg_wr_seq, {addr == addr_dc;wdata == iosf_data_0[0];exp_cplstatus == 2'b00;exp_rsp == 1;})
  `ovm_do_with(sb_cfg_rd_seq, {addr == addr_dc;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_0[0];})

  iosf_addr_mem_sb = get_reg_addr("config_master", "cfg_pm_pmcsr_disable", "sideband");

  `ovm_do_with(sb_mem_wr_seq, {addr == iosf_addr_mem_sb;wdata == iosf_data_1[0];})

  `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_1[0];})

  //wait_for_clk(10000); //wait for reset to be done
   poll_reg_val(master_regs.CFG_DIAGNOSTIC_RESET_STATUS,'h_8000_0bff,'h_ffff_ffff,1000);

  $sformat(ref_name_reg,"vector_ctrl[%0d]",cq);

  iosf_addr_mem_sb = get_reg_addr("hqm_msix_mem", ref_name_reg, "sideband");

  `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;bar == 3'h0;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_2[0];})

  iosf_addr_mem_sb = get_reg_addr("config_master", "cfg_hqm_cdc_control", "sideband");

  `ovm_do_with(sb_mem_rd_seq, {addr == iosf_addr_mem_sb;bar == 3'h2;exp_cplstatus == 2'b00;exp_rsp == 1;do_compare == 1'b1;mask == 32'hffffffff;exp_cmpdata == iosf_data_3[0];})

 `ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_mem_access_wo_bar_cfg_seq ended \n"),OVM_LOW)

endtask : body
