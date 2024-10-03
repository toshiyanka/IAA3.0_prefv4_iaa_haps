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
// File   : hcw_pf_test_cfg_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_pf_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hcw_pf_test_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_pf_test_cfg_seq_stim_config";

  `ovm_object_utils_begin(hcw_pf_test_cfg_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(inst_suffix,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_sm_pf_cfg,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_wait_for_reset_done,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hcw_pf_test_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(do_sm_pf_cfg)
    `stimulus_config_field_rand_int(do_wait_for_reset_done)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  bit                     do_sm_pf_cfg;
  rand  bit                     do_wait_for_reset_done;

  constraint c_do_sm_pf_cfg {
    soft do_sm_pf_cfg           == 1'b1;
  }

  constraint c_do_wait_for_reset_done {
    soft do_wait_for_reset_done == 1'b1;
  }

  function new(string name = "hcw_pf_test_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_test_cfg_seq_stim_config

class hcw_pf_test_cfg_seq extends ovm_sequence;
  `ovm_sequence_utils(hcw_pf_test_cfg_seq,sla_sequencer)

  rand hcw_pf_test_cfg_seq_stim_config                  cfg;

  hqm_integ_seq_pkg::hqm_sm_pf_cfg_seq                  sm_pf_cfg_seq;
  hqm_integ_seq_pkg::hqm_wait_for_reset_done_seq        wait_for_reset_done_seq;
  hqm_integ_seq_pkg::hcw_pf_test_hqm_cfg_seq            hqm_cfg_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_test_cfg_seq_stim_config);

  function new(string name = "hcw_pf_test_cfg_seq");
    super.new(name); 

    cfg = hcw_pf_test_cfg_seq_stim_config::type_id::create("hcw_pf_test_cfg_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();

    apply_stim_config_overrides(1);

    if (cfg.do_sm_pf_cfg) begin
      `ovm_create(sm_pf_cfg_seq)
      sm_pf_cfg_seq.inst_suffix = cfg.inst_suffix;
      `ovm_rand_send(sm_pf_cfg_seq)
    end

    if (cfg.do_wait_for_reset_done) begin
      `ovm_create(wait_for_reset_done_seq)
      wait_for_reset_done_seq.inst_suffix = cfg.inst_suffix;
      `ovm_rand_send(wait_for_reset_done_seq)
    end

    `ovm_create(hqm_cfg_seq)
    hqm_cfg_seq.inst_suffix = cfg.inst_suffix;
    `ovm_rand_send(hqm_cfg_seq)

  endtask : body
endclass : hcw_pf_test_cfg_seq
