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
// File   : hqm_system_burst_flush_seq.sv
//
// Description :
//
//   Sequence that supports clock control tests with optional warm reset.
//
//   Variables within stim_config class
//     * do_eot_rd_seq          - run hqm_eot_rd_seq sequence
//     * do_eot_status_seq      - run hqm_eot_status_seq sequence
//     * tb_env_hier            - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_system_burst_flush_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_system_burst_flush_seq_stim_config";

  `ovm_object_utils_begin(hqm_system_burst_flush_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_eot_rd_seq,               OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_eot_status_seq,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_system_burst_flush_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_rand_int(do_eot_rd_seq)
    `stimulus_config_field_rand_int(do_eot_status_seq)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_FLUSH_SEQ";
  string                        file_mode_plusarg2 = "HQM_FLUSH_SEQ2";

  rand  bit                     do_eot_rd_seq;
  rand  bit                     do_eot_status_seq;

  constraint c_do_eot_rd_seq_soft {
    do_eot_rd_seq       == 1'b1;
  }

  constraint c_do_eot_status_seq_soft {
    do_eot_status_seq   == 1'b1;
  }

  function new(string name = "hqm_system_burst_flush_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_system_burst_flush_seq_stim_config

class hqm_system_burst_flush_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_system_burst_flush_seq,sla_sequencer)

  rand hqm_system_burst_flush_seq_stim_config        cfg;

  hqm_eot_rd_seq                                        i_hqm_eot_rd_seq;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq;
  hqm_tb_eot_status_seq                                 i_hqm_tb_eot_status_seq;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq2;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_system_burst_flush_seq_stim_config);

  function new(string name = "hqm_system_burst_flush_seq");
    super.new(name);

    cfg = hqm_system_burst_flush_seq_stim_config::type_id::create("hqm_system_burst_flush_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    apply_stim_config_overrides(1);

    if (cfg.do_eot_rd_seq) begin
      `ovm_do(i_hqm_eot_rd_seq)
    end

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());

    if (cfg.do_eot_status_seq) begin
      `ovm_do(i_hqm_tb_eot_status_seq)
    end

    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());

  endtask

endclass : hqm_system_burst_flush_seq
