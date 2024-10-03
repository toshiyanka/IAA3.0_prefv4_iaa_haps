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
// File   : hcw_pf_test_multi_hcw_seq.sv
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

class hcw_pf_test_multi_hcw_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_pf_test_multi_hcw_seq_stim_config";

  `uvm_object_utils_begin(hcw_pf_test_multi_hcw_seq_stim_config)
    `uvm_field_string(tb_env_hier,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(hcw_seq_count,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(hcw_seq_delay,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_pf_test_multi_hcw_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(hcw_seq_count)
    `stimulus_config_field_rand_int(hcw_seq_delay)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";

  rand  int                     hcw_seq_count;
  rand  int                     hcw_seq_delay;

  constraint c_hcw_seq_count {
    soft hcw_seq_count           == 1;
  }

  constraint c_hcw_seq_delay {
    soft hcw_seq_delay == 1'b1;
  }

  function new(string name = "hcw_pf_test_multi_hcw_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_test_multi_hcw_seq_stim_config

class hcw_pf_test_multi_hcw_seq extends uvm_sequence;
  `uvm_object_utils(hcw_pf_test_multi_hcw_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

  rand hcw_pf_test_multi_hcw_seq_stim_config       cfg;

  hqm_integ_seq_pkg::hcw_pf_test_hcw_seq        hcw_seq;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_test_multi_hcw_seq_stim_config);
`endif

  function new(string name = "hcw_pf_test_multi_hcw_seq");
    super.new(name); 

    cfg = hcw_pf_test_multi_hcw_seq_stim_config::type_id::create("hcw_pf_test_multi_hcw_seq_stim_config");
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

    for (int i = 0 ; i < cfg.hcw_seq_count ; i++) begin
      if (i > 0) begin
        for (int j = 0 ; j < cfg.hcw_seq_delay ; j++) begin
          @ (slu_tb_env::sys_clk_r);
        end 
      end 

      `uvm_do(hcw_seq)
    end 
  endtask : body
endclass : hcw_pf_test_multi_hcw_seq
