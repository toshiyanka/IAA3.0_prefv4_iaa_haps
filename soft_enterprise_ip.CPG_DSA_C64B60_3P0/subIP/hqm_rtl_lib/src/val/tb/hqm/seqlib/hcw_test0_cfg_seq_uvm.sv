// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2020) Intel Corporation All Rights Reserved. 
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
// File   : hcw_test0_cfg_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_test0 test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hcw_test0_cfg_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_test0_cfg_seq_stim_config";

  `uvm_object_utils_begin(hcw_test0_cfg_seq_stim_config)
    `uvm_field_string(tb_env_hier,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(inst_suffix,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_test0_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix = "";

  function new(string name = "hcw_test0_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_test0_cfg_seq_stim_config

class hcw_test0_cfg_seq extends uvm_sequence;
  `uvm_object_utils(hcw_test0_cfg_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

  rand hcw_test0_cfg_seq_stim_config  cfg;

  hqm_integ_seq_pkg::hqm_sm_pf_cfg_seq                   sm_pf_cfg_seq;
  hqm_integ_seq_pkg::hqm_wait_for_reset_done_seq         wait_for_reset_done_seq;
  hqm_integ_seq_pkg::hcw_test0_hqm_cfg_seq               hqm_cfg_seq;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_test0_cfg_seq_stim_config);
`endif

  function new(string name = "hcw_test0_cfg_seq");
    super.new(name); 

    cfg = hcw_test0_cfg_seq_stim_config::type_id::create("hcw_test0_cfg_seq_stim_config");
`ifdef IP_OVM_STIM
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task pre_body();
    //uvm_test_done.raise_objection(this);
  endtask
  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task post_body();
    //uvm_test_done.drop_objection(this);
  endtask

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    `uvm_create(sm_pf_cfg_seq)
    sm_pf_cfg_seq.inst_suffix = cfg.inst_suffix;
    `uvm_rand_send(sm_pf_cfg_seq)

    `uvm_create(wait_for_reset_done_seq)
    wait_for_reset_done_seq.inst_suffix = cfg.inst_suffix;
    `uvm_rand_send(wait_for_reset_done_seq)

    `uvm_create(hqm_cfg_seq)
    hqm_cfg_seq.inst_suffix = cfg.inst_suffix;
    `uvm_rand_send(hqm_cfg_seq)

  endtask : body
endclass : hcw_test0_cfg_seq
