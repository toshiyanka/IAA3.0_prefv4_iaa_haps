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
// File   : hqm_iosf_sb_intermediate_reset_prep_between_np_seq.sv
// Author : rsshekha
// Description :
//
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(b2b, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(b2b)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand bit   b2b;
  constraint c_b2b { soft b2b == 1'b0; }

  function new(string name = "hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config

class hqm_iosf_sb_intermediate_reset_prep_between_np_seq extends hqm_iosf_base_seq;
  `ovm_sequence_utils(hqm_iosf_sb_intermediate_reset_prep_between_np_seq,sla_sequencer)
  int num_txns = 4;
  int num_reset_prep = 1;

  rand hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config        cfg;

  hqm_iosf_sb_mem_rd_seq                   sb_mem_rd_seq; 
  hqm_iosf_sb_mem_wr_seq                   sb_mem_wr_seq;
  hqm_iosf_sb_cfg_rd_seq                   sb_cfg_rd_seq; 
  hqm_iosf_sb_cfg_wr_seq                   sb_cfg_wr_seq; 
  hqm_iosf_sb_resetPrep_seq                sb_resetPrep_seq; 
  hqm_reset_init_sequence                  warm_rst_seq;
  hqm_sla_pcie_init_seq                    pcie_init;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config);

  function new(string name = "hqm_iosf_sb_intermediate_reset_prep_between_np_seq");
    super.new(name); 
    cfg = hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config::type_id::create("hqm_iosf_sb_intermediate_reset_prep_between_np_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction
  
  extern virtual task body();
  extern virtual task gen_np_txns(int exp_rsp_l, logic [1:0] exp_cplstatus_l);
endclass : hqm_iosf_sb_intermediate_reset_prep_between_np_seq

task hqm_iosf_sb_intermediate_reset_prep_between_np_seq::gen_np_txns(int exp_rsp_l = 0, logic [1:0] exp_cplstatus_l = 2'b00);
  
  string                ref_name_file = "", ref_name_reg = "";
  int                   vf = 0; 
  bit [63:0]            addr_cppd, addr_ptvm, addr_dc, addr_cls, addr_cpc, addr_cps;
  
  Iosf::data_t          iosf_data_0[],iosf_data_1[];
  
  iosf_data_0    = new[1];
  iosf_data_1    = new[1];
  iosf_data_0[0] = 32'h0000000f;
  iosf_data_1[0] = 32'h00000039;
  
  addr_dc    = get_reg_addr("hqm_pf_cfg_i","device_command", "sideband"); 
  addr_cls   = get_reg_addr("hqm_pf_cfg_i","cache_line_size", "sideband"); 
  addr_cps   = get_reg_addr("config_master","cfg_pm_status", "sideband"); 
  addr_cpc   = get_reg_addr("credit_hist_pipe","cfg_patch_control", "sideband"); 
  addr_cppd  = get_reg_addr("config_master", "cfg_pm_pmcsr_disable", "sideband");
  
  ref_name_file="hqm_system_csr"; 
  ref_name_reg="aw_smon_timer[0]";

  addr_ptvm  = get_reg_addr(ref_name_file, ref_name_reg, "sideband");

  if(!$value$plusargs("HQM_IOSF_SB_TXNS_NUM=%d",num_txns)) num_txns = 4;

  for (int i=0;i<num_txns;i++) begin 

     `ovm_info(get_full_name(),$sformatf("\n sb_mem_rd_seq addr_cppd \n"),OVM_LOW)
     `ovm_do_with(sb_mem_rd_seq, {addr == addr_cppd;exp_rsp == exp_rsp_l;exp_cplstatus == exp_cplstatus_l;})

     `ovm_info(get_full_name(),$sformatf("\n sb_mem_rd_seq addr_ptvm \n"),OVM_LOW)
     `ovm_do_with(sb_mem_rd_seq, {addr == addr_ptvm;exp_rsp == exp_rsp_l;exp_cplstatus == exp_cplstatus_l;})
     
     `ovm_info(get_full_name(),$sformatf("\n sb_cfg_wr_seq addr_cls \n"),OVM_LOW)
     `ovm_do_with(sb_cfg_wr_seq, {addr == addr_cls;wdata == iosf_data_0[0];exp_rsp == exp_rsp_l;exp_cplstatus == exp_cplstatus_l;})
     
     //`ovm_do_with(sb_cfg_rd_seq, {addr == addr_cls;exp_cplstatus == 2'b00;exp_rsp == 0;})
     
     `ovm_info(get_full_name(),$sformatf("\n sb_mem_rd_seq addr_cps \n"),OVM_LOW)
     `ovm_do_with(sb_mem_rd_seq, {addr == addr_cps;exp_rsp == exp_rsp_l;exp_cplstatus == exp_cplstatus_l;})
     
     //`ovm_do_with(sb_mem_wr_seq, {addr == addr_cpc;wdata == iosf_data_1[0];})
     
     `ovm_info(get_full_name(),$sformatf("\n sb_mem_rd_seq addr_cpc \n"),OVM_LOW)
     `ovm_do_with(sb_mem_rd_seq, {addr == addr_cpc;exp_rsp == exp_rsp_l;exp_cplstatus == exp_cplstatus_l;})
  end 

endtask: gen_np_txns

task  hqm_iosf_sb_intermediate_reset_prep_between_np_seq::body();

  apply_stim_config_overrides(1);
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_intermediate_reset_prep_between_np_seq started \n"),OVM_LOW)

  if(!$value$plusargs("HQM_IOSF_SB_RESET_PREP_NUM=%d",num_reset_prep)) num_reset_prep = 1;

  for (int i=0;i<num_reset_prep;i++) begin 
  
     `ovm_info(get_full_name(),$sformatf("\n gen_np_txns before reset_prep \n"),OVM_LOW)
     $display($time, "cfg.b2b = %d", cfg.b2b);
     if (cfg.b2b) begin 
        gen_np_txns(.exp_rsp_l(0),.exp_cplstatus_l(2'b00));
     end
     else begin 
        gen_np_txns(.exp_rsp_l(1),.exp_cplstatus_l(2'b00));
     end 

     `ovm_info(get_full_name(),$sformatf("\n  reset_prep \n"),OVM_LOW)
     `ovm_do(sb_resetPrep_seq)

     `ovm_info(get_full_name(),$sformatf("\n gen_np_txns after reset_prep \n"),OVM_LOW)
     if (cfg.b2b) begin 
        gen_np_txns(.exp_rsp_l(0),.exp_cplstatus_l(2'b01));
        wait_for_clk(10000); //wait for all the completions to come
     end
     else begin 
        gen_np_txns(.exp_rsp_l(1),.exp_cplstatus_l(2'b01));
     end 
  end 


 `ovm_info(get_full_name(),$sformatf("\n generating warm reset  \n"),OVM_LOW)
 `ovm_do(warm_rst_seq)
 `ovm_do(pcie_init)
  `ovm_info(get_full_name(),$sformatf("\n hqm_iosf_sb_intermediate_reset_prep_between_np_seq ended \n"),OVM_LOW)

endtask : body
