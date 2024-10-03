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

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hcw_test0_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_test0_cfg_seq_stim_config";

  `ovm_object_utils_begin(hcw_test0_cfg_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(inst_suffix,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
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

class hcw_test0_cfg_seq extends ovm_sequence;
  `ovm_sequence_utils(hcw_test0_cfg_seq,sla_sequencer)

  rand hcw_test0_cfg_seq_stim_config  cfg;

  hqm_integ_seq_pkg::hqm_sm_pf_cfg_seq                   sm_pf_cfg_seq;
  hqm_integ_seq_pkg::hqm_wait_for_reset_done_seq         wait_for_reset_done_seq;
  hqm_integ_seq_pkg::hcw_test0_hqm_cfg_seq               hqm_cfg_seq;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_test0_cfg_seq_stim_config);
`endif

  function new(string name = "hcw_test0_cfg_seq");
    super.new(name); 

    cfg = hcw_test0_cfg_seq_stim_config::type_id::create("hcw_test0_cfg_seq_stim_config");
`ifdef IP_TYP_TE
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task pre_body();
    //ovm_test_done.raise_objection(this);
  endtask
  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task post_body();
    //ovm_test_done.drop_objection(this);
  endtask

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    `ovm_create(sm_pf_cfg_seq)
    sm_pf_cfg_seq.inst_suffix = cfg.inst_suffix;
    `ovm_rand_send(sm_pf_cfg_seq)

    `ovm_create(wait_for_reset_done_seq)
    wait_for_reset_done_seq.inst_suffix = cfg.inst_suffix;
    `ovm_rand_send(wait_for_reset_done_seq)

    `ovm_create(hqm_cfg_seq)
    hqm_cfg_seq.inst_suffix = cfg.inst_suffix;
    `ovm_rand_send(hqm_cfg_seq)

  endtask : body
endclass : hcw_test0_cfg_seq
