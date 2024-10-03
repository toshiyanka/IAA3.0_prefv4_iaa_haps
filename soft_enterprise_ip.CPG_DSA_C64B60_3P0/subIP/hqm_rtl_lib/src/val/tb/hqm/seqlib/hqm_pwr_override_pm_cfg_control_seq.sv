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
// File   : hqm_pwr_override_pm_cfg_control_seq.sv
// Author : rsshekha
// Description :
//
//   sequence to verify the iosf compliance in D3 hot state. 
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

import IosfPkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;

class hqm_pwr_override_pm_cfg_control_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_override_pm_cfg_control_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_override_pm_cfg_control_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_override_pm_cfg_control_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_pwr_override_pm_cfg_control_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_override_pm_cfg_control_seq_stim_config

class hqm_pwr_override_pm_cfg_control_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_override_pm_cfg_control_seq)


  rand hqm_pwr_override_pm_cfg_control_seq_stim_config        cfg;

  hqm_sla_pcie_init_seq                 pcie_init;
  hqm_iosf_sb_mem_rd_seq                sb_mem_rd_seq; 
  hqm_iosf_sb_mem_wr_seq                sb_mem_wr_seq; 
  hqm_reset_init_sequence               warm_reset_seq;
  hqm_iosf_sb_resetPrep_seq             resetPrep_seq;
  hqm_iosf_sb_forcewake_seq             forcePwrGatePOK_seq;
  ovm_event_pool                        global_pool;
  ovm_event                             hqm_ResetPrepAck;
  ovm_event                             hqm_ForcePwrGatePOK;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_override_pm_cfg_control_seq_stim_config);

  function new(string name = "hqm_pwr_override_pm_cfg_control_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 
    cfg = hqm_pwr_override_pm_cfg_control_seq_stim_config::type_id::create("hqm_pwr_override_pm_cfg_control_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ResetPrepAck = global_pool.get("hqm_ResetPrepAck");
    hqm_ForcePwrGatePOK = global_pool.get("hqm_ForcePwrGatePOK");
  endfunction

  extern virtual task body();

endclass : hqm_pwr_override_pm_cfg_control_seq
  
task hqm_pwr_override_pm_cfg_control_seq::body();
  
  bit [63:0]          addr_cmc;
  bit [31:0]          wdata_l;
  int                 wait_time;
  bit [1:0]           exp_cplstatus_l = 2'b00;
  bit                 do_compare_l = 1'b1;

  
  `ovm_info(get_full_name(),$sformatf(" hqm_pwr_override_pm_cfg_control_seq started "),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  if (!$value$plusargs("HQM_WAIT_TIME=%d",wait_time)) begin 
      wait_time = 200;
  end 
  `ovm_info(get_full_name(),$sformatf("wait for %d clks", wait_time),OVM_LOW)
  wait_for_clk(wait_time);
  `ovm_info(get_full_name(),$sformatf("wait completed"),OVM_LOW)

  if ($test$plusargs("HQM_OVERRIDE_PM_CFG_CONTROL_AFTER_RESET_PREP")) begin 
     // send a resetPrep
     `ovm_info(get_full_name(),$sformatf(" sending reset prep req to hqm "),OVM_LOW)
     `ovm_do(resetPrep_seq);
     `ovm_info(get_full_name(),$sformatf(" reset prep req to hqm done "),OVM_LOW)
     hqm_ResetPrepAck.wait_trigger();
     `ovm_info(get_full_name(),$sformatf(" reset prep ack received from hqm "),OVM_LOW)
     exp_cplstatus_l = 2'b01;
     do_compare_l = 1'b0;
  end
  else begin 
     exp_cplstatus_l = 2'b00;
     do_compare_l = 1'b1;
  end 

  addr_cmc = get_reg_addr("config_master","cfg_master_ctl", "sideband");

  `ovm_info(get_full_name(),$sformatf(" send mem rd to hqm to read data for register cfg_master_ctl "),OVM_LOW)
  `ovm_do_with(sb_mem_rd_seq, {addr == addr_cmc;exp_cplstatus == exp_cplstatus_l;exp_rsp == 1;})

  `ovm_info(get_full_name(),$sformatf(" mem rd to hqm for register cfg_master_ctl completed with read data %h", sb_mem_rd_seq.rdata),OVM_LOW)
  wdata_l = sb_mem_rd_seq.rdata;
  wdata_l[6:4] = 3'b011;

  `ovm_info(get_full_name(),$sformatf(" send mem write to hqm for register cfg_master_ctl with write data %h", wdata_l),OVM_LOW)
  `ovm_do_with(sb_mem_wr_seq, {addr == addr_cmc;wdata == wdata_l;})

  `ovm_info(get_full_name(),$sformatf(" send mem rd to hqm to read data for register cfg_master_ctl "),OVM_LOW)
  `ovm_do_with(sb_mem_rd_seq, {addr == addr_cmc;exp_cplstatus == exp_cplstatus_l;exp_rsp == 1;do_compare == do_compare_l;mask == 32'hffffffff;exp_cmpdata == wdata_l;})
  `ovm_info(get_full_name(),$sformatf(" mem rd to hqm for register cfg_master_ctl completed with read data %h", sb_mem_rd_seq.rdata),OVM_LOW)
  
  if ($test$plusargs("HQM_OVERRIDE_PM_CFG_CONTROL_AFTER_RESET_PREP")) begin 
     `ovm_info(get_full_name(),$sformatf(" sending forcePwrGatePOK req to hqm "),OVM_LOW)
     `ovm_do(forcePwrGatePOK_seq);
     `ovm_info(get_full_name(),$sformatf(" forcePwrGatePOK req to hqm done"),OVM_LOW)
  end 

  `ovm_info(get_full_name(),$sformatf("calling warm_reset_seq"),OVM_LOW)
  `ovm_do(warm_reset_seq)

  `ovm_info(get_full_name(),$sformatf(" calling pcie_init "),OVM_LOW)
  `ovm_do(pcie_init)

  `ovm_info(get_full_name(),$sformatf(" hqm_pwr_override_pm_cfg_control_seq ended "),OVM_LOW)

endtask : body
