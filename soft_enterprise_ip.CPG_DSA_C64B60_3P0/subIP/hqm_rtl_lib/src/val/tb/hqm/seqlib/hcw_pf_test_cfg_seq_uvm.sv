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

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hcw_pf_test_cfg_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_pf_test_cfg_seq_stim_config";

  `uvm_object_utils_begin(hcw_pf_test_cfg_seq_stim_config)
    `uvm_field_string(tb_env_hier,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(inst_suffix,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(do_hqm_cfg_reset,            UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(do_sm_pf_cfg,                UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(do_wait_for_reset_done,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(msix_base_addr,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(msix_addr_q,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(msix_data_q,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_pf_test_cfg_seq_stim_config)
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

  function new(string name = "hcw_pf_test_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_test_cfg_seq_stim_config

class hcw_pf_test_cfg_seq extends uvm_sequence;
  `uvm_object_utils(hcw_pf_test_cfg_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

  rand hcw_pf_test_cfg_seq_stim_config                  cfg;

  hqm_integ_seq_pkg::hqm_cfg_reset_seq                  cfg_reset_seq;
  hqm_integ_seq_pkg::hqm_sm_pf_cfg_seq                  sm_pf_cfg_seq;
  hqm_integ_seq_pkg::hqm_wait_for_reset_done_seq        wait_for_reset_done_seq;
  hqm_integ_seq_pkg::hcw_pf_test_hqm_cfg_seq            hqm_cfg_seq;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_test_cfg_seq_stim_config);
`endif

  function new(string name = "hcw_pf_test_cfg_seq");
    super.new(name); 

    cfg = hcw_pf_test_cfg_seq_stim_config::type_id::create("hcw_pf_test_cfg_seq_stim_config");
`ifdef IP_OVM_STIM
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    `uvm_info(get_name(), $psprintf("Starting with do_hqm_cfg_reset=%0d do_sm_pf_cfg=%0d do_wait_for_reset_done=%0d", cfg.do_hqm_cfg_reset, cfg.do_sm_pf_cfg, cfg.do_wait_for_reset_done), UVM_LOW);
    if (cfg.do_hqm_cfg_reset) begin
      `uvm_info(get_name(), $psprintf("Starting do_hqm_cfg_reset"), UVM_LOW);
      `uvm_create(cfg_reset_seq)
      cfg_reset_seq.inst_suffix = cfg.inst_suffix;
      `uvm_rand_send(cfg_reset_seq)
    end 

    if (cfg.do_sm_pf_cfg) begin
      `uvm_info(get_name(), $psprintf("Starting sm_pf_cfg_seq"), UVM_LOW);
      `uvm_create(sm_pf_cfg_seq)
      sm_pf_cfg_seq.inst_suffix = cfg.inst_suffix;
      `uvm_rand_send(sm_pf_cfg_seq)
    end 

    if (cfg.do_wait_for_reset_done) begin
      `uvm_info(get_name(), $psprintf("Starting wait_for_reset_done_seq"), UVM_LOW);
      `uvm_create(wait_for_reset_done_seq)
      wait_for_reset_done_seq.inst_suffix = cfg.inst_suffix;
      `uvm_rand_send(wait_for_reset_done_seq)
    end 

    `uvm_info(get_name(), $psprintf("Starting hqm_cfg_seq"), UVM_LOW);
    `uvm_create(hqm_cfg_seq)
    hqm_cfg_seq.inst_suffix             = cfg.inst_suffix;
    hqm_cfg_seq.cfg.msix_base_addr      = cfg.msix_base_addr;
    hqm_cfg_seq.cfg.msix_addr_q         = cfg.msix_addr_q;
    hqm_cfg_seq.cfg.msix_data_q         = cfg.msix_data_q;
    `uvm_rand_send(hqm_cfg_seq)

  endtask : body
endclass : hcw_pf_test_cfg_seq
