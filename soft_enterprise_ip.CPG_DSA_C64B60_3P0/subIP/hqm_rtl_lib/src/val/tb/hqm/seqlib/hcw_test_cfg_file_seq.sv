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
// File   : hcw_test_cfg_file_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_pf_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hcw_test_cfg_file_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_test_cfg_file_seq_stim_config";

  `ovm_object_utils_begin(hcw_test_cfg_file_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(inst_suffix,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_hqm_cfg_reset,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_sm_pf_cfg,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_wait_for_reset_done,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(msix_base_addr,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_addr_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_data_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hcw_test_cfg_file_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(do_hqm_cfg_reset)
    `stimulus_config_field_rand_int(do_sm_pf_cfg)
    `stimulus_config_field_rand_int(do_wait_for_reset_done)
    `stimulus_config_field_int(msix_base_addr)
    `stimulus_config_field_queue_int(msix_addr_q)
    `stimulus_config_field_queue_int(msix_data_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  bit                     do_hqm_cfg_reset;
  rand  bit                     do_sm_pf_cfg;
  rand  bit                     do_wait_for_reset_done;

  bit [63:0]                    msix_base_addr = 64'h00000000_fee00000;

  bit [63:0]                    msix_addr_q[$];
  bit [31:0]                    msix_data_q[$];

  constraint c_do_hqm_cfg_reset {
`ifdef IP_TYP_TE
    soft do_hqm_cfg_reset       == 1'b0;
`else
    soft do_hqm_cfg_reset       == 1'b1;
`endif
  }

  constraint c_do_sm_pf_cfg {
    soft do_sm_pf_cfg           == 1'b1;
  }

  constraint c_do_wait_for_reset_done {
    soft do_wait_for_reset_done == 1'b1;
  }

  function new(string name = "hcw_test_cfg_file_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_test_cfg_file_seq_stim_config

class hcw_test_cfg_file_seq extends ovm_sequence;
  `ovm_sequence_utils(hcw_test_cfg_file_seq,sla_sequencer)

  rand hcw_test_cfg_file_seq_stim_config             cfg;

  hqm_integ_seq_pkg::hqm_cfg_reset_seq                  cfg_reset_seq;
  hqm_integ_seq_pkg::hqm_sm_pf_cfg_seq                  sm_pf_cfg_seq;
  hqm_integ_seq_pkg::hqm_wait_for_reset_done_seq        wait_for_reset_done_seq;
  hqm_integ_seq_pkg::hqm_cfg_file_seq                   hqm_cfg_file_seq;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_test_cfg_file_seq_stim_config);
`endif

  function new(string name = "hcw_test_cfg_file_seq");
    super.new(name); 

    cfg = hcw_test_cfg_file_seq_stim_config::type_id::create("hcw_test_cfg_file_seq_stim_config");
`ifdef IP_TYP_TE
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    `ovm_info(get_name(), $psprintf("Starting with do_hqm_cfg_reset=%0d do_sm_pf_cfg=%0d do_wait_for_reset_done=%0d", cfg.do_hqm_cfg_reset, cfg.do_sm_pf_cfg, cfg.do_wait_for_reset_done), OVM_LOW);
    if (cfg.do_hqm_cfg_reset) begin
      `ovm_info(get_name(), $psprintf("Starting do_hqm_cfg_reset"), OVM_LOW);
      `ovm_create(cfg_reset_seq)
      cfg_reset_seq.inst_suffix = cfg.inst_suffix;
      `ovm_rand_send(cfg_reset_seq)
    end

    if (cfg.do_sm_pf_cfg) begin
      `ovm_info(get_name(), $psprintf("Starting sm_pf_cfg_seq"), OVM_LOW);
      `ovm_create(sm_pf_cfg_seq)
      sm_pf_cfg_seq.inst_suffix = cfg.inst_suffix;
      `ovm_rand_send(sm_pf_cfg_seq)
    end

    if (cfg.do_wait_for_reset_done) begin
      `ovm_info(get_name(), $psprintf("Starting wait_for_reset_done_seq"), OVM_LOW);
      `ovm_create(wait_for_reset_done_seq)
      wait_for_reset_done_seq.inst_suffix = cfg.inst_suffix;
      `ovm_rand_send(wait_for_reset_done_seq)
    end

    `ovm_info(get_name(), $psprintf("Starting hqm_cfg_file_seq"), OVM_LOW);
    `ovm_create(hqm_cfg_file_seq)
    hqm_cfg_file_seq.inst_suffix             = cfg.inst_suffix;
    `ovm_rand_send(hqm_cfg_file_seq)

  endtask : body
endclass : hcw_test_cfg_file_seq
