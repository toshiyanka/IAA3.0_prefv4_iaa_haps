// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2018) (2018) Intel Corporation All Rights Reserved. 
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
// File   : hcw_d0_d3_d0_test_hcw_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_pf_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hcw_d0_d3_d0_test_hcw_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_d0_d3_d0_test_hcw_seq_stim_config";

  `ovm_object_utils_begin(hcw_d0_d3_d0_test_hcw_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hcw_d0_d3_d0_test_hcw_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
  `stimulus_config_object_utils_end
   sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_CFG_D0_D3_D0_PRE_SEQ";
  string                        file_mode_plusarg2 = "HQM_CFG_D0_D3_D0_SEQ";
 
 
  function new(string name = "hcw_d0_d3_d0_test_hcw_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_d0_d3_d0_test_hcw_seq_stim_config

class hcw_d0_d3_d0_test_hcw_seq extends hqm_pwr_base_seq;
  `ovm_sequence_utils(hcw_d0_d3_d0_test_hcw_seq,sla_sequencer)

  rand hcw_d0_d3_d0_test_hcw_seq_stim_config       cfg;
  hqm_cfg                                      i_hqm_cfg;
  hqm_integ_seq_pkg::hcw_pf_test_hqm_cfg_seq    cfg_seq;
  hqm_integ_seq_pkg::hcw_pf_test_hcw_seq        hcw_seq;
  hqm_tb_cfg_file_mode_seq                      i_file_mode_pre_seq;
  hqm_tb_cfg_file_mode_seq                      i_file_mode_seq;
  ovm_object     o_tmp;
//      sla_ral_addr_t addr;
//      sla_ral_reg    reg_h;
//      sla_ral_field  fields[$];
//      sla_ral_data_t rd_data;
//     `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_d0_d3_d0_test_hcw_seq_stim_config);

  function new(string name = "hcw_d0_d3_d0_test_hcw_seq");
    super.new(name); 

    cfg = hcw_d0_d3_d0_test_hcw_seq_stim_config::type_id::create("hcw_d0_d3_d0_test_hcw_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();
    ovm_object          o_tmp;
    hqm_iosf_prim_mon   i_hqm_iosf_prim_mon;

     if (!p_sequencer.get_config_object("i_hqm_cfg", o_tmp)) begin
        ovm_report_fatal(get_full_name(), "Unable to find i_hqm_cfg object");
      end

      if (!$cast(i_hqm_cfg, o_tmp)) begin
        ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
      end  


    apply_stim_config_overrides(1);

    i_file_mode_pre_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_pre_seq");
    i_file_mode_pre_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_pre_seq.start(get_sequencer());

    `ovm_info("D0_D3_D0_Test_DEBUG",$psprintf("Step1: sending hcw_seq"),OVM_LOW)
    `ovm_do(hcw_seq)

     ral_access_path = cfg.access_path;
     base_tb_env_hier = cfg.tb_env_hier;
     `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
     
 
    `ovm_info("D0_D3_D0_Test_DEBUG",$psprintf("Step2: calling HQM_D3STATE"),OVM_LOW)
     pmcsr_ps_cfg(`HQM_D3STATE);
     #2000ns;
     ral.reset_regs("D3HOT","vcccfn_gated",0);
     reset_tb("D3HOT");
     i_hqm_cfg.reset_hqm_cfg();
 
    `ovm_info("D0_D3_D0_Test_DEBUG",$psprintf("Step3: calling HQM_D0STATE"),OVM_LOW)
     pmcsr_ps_cfg(`HQM_D0STATE);
     #2000ns;

  //   ###poll to Wait for reset to be done 
  //   poll config_master.cfg_diagnostic_reset_status 0x800003ff 0x800003ff 500
  //   ###poll to Wait for unit_idle to be done 
  //   poll config_master.cfg_diagnostic_idle_status 0x0007ffff 0x0007ffff 500
     

 //   i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
 //   i_file_mode_seq.set_cfg(cfg.file_mode_plusarg2, 1'b0);
 //   i_file_mode_seq.start(get_sequencer());

   
    `ovm_info("D0_D3_D0_Test_DEBUG",$psprintf("Step4: polling for CFG_DIAGNOSTIC_RESET_STATUS started"),OVM_LOW)
     `ovm_info(get_full_name(),$sformatf("\n polling for CFG_DIAGNOSTIC_RESET_STATUS started \n"),OVM_LOW)
     poll("config_master","cfg_diagnostic_reset_status","hqm_proc_reset_done",SLA_FALSE,1'b1);
     `ovm_info(get_full_name(),$sformatf("\n polling for CFG_DIAGNOSTIC_RESET_STATUS ended \n"),OVM_LOW)

//   `ovm_info(get_full_name(),$sformatf("\n polling for CFG_DIAGNOSTIC_IDLE_STATUS started \n"),OVM_LOW)
//   poll("config_master","cfg_diagnostic_idle_status","aqed_unit_idle",SLA_FALSE,1'b1);
//  `ovm_info(get_full_name(),$sformatf("\n polling for CFG_DIAGNOSTIC_IDLE_STATUS ended \n"),OVM_LOW)
     #4000ns;
 
    if (!p_sequencer.get_config_object("i_hqm_iosf_prim_mon", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_iosf_prim_mon object");
    end

    if (!$cast(i_hqm_iosf_prim_mon, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_iosf_prim_mon not compatible with type of i_hqm_iosf_prim_mon"));
    end

    `ovm_info("D0_D3_D0_Test_DEBUG",$psprintf("Step5: i_hqm_iosf_prim_mon.cq_gen_reset"),OVM_LOW)
    i_hqm_iosf_prim_mon.cq_gen_reset();

    `ovm_info("D0_D3_D0_Test_DEBUG",$psprintf("Step6: cfg_seq"),OVM_LOW)
    `ovm_do(cfg_seq)

    `ovm_info("D0_D3_D0_Test_DEBUG",$psprintf("Step7: hcw_seq"),OVM_LOW)
    `ovm_do(hcw_seq)

  endtask : body
endclass : hcw_d0_d3_d0_test_hcw_seq
