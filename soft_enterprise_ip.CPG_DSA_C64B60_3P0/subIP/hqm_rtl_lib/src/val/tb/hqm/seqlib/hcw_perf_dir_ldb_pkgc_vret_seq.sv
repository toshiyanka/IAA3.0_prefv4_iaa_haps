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
// File   : hcw_perf_dir_ldb_pkgc_vret_seq.sv
//
// Description :
//
//   Sequence that supports clock control tests with optional warm reset.
//
//   Variables within stim_config class
//     * do_warm_reset - do a warm reset (default is 0)
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hcw_perf_dir_ldb_pkgc_vret_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_perf_dir_ldb_pkgc_vret_seq_stim_config";

  `ovm_object_utils_begin(hcw_perf_dir_ldb_pkgc_vret_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_goto_vret,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_goto_von,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_wait_no_clkreq,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hcw_perf_dir_ldb_pkgc_vret_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_rand_int(do_goto_vret)
    `stimulus_config_field_rand_int(do_goto_von)
    `stimulus_config_field_rand_int(do_wait_no_clkreq)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_USER_DATA_SEQ";
  string                        file_mode_plusarg2 = "HQM_USER_DATA_SEQ2";

  rand  bit                     do_goto_vret;
  rand  bit                     do_goto_von;
  rand  bit                     do_wait_no_clkreq;

  constraint c_do_goto_vret_soft {
    do_goto_vret        == 1'b1;
  }

  constraint c_do_goto_von_soft {
    do_goto_von         == 1'b1;
  }

  constraint c_do_wait_no_clkreq_soft {
    do_wait_no_clkreq       == 1'b0;
  }

  function new(string name = "hcw_perf_dir_ldb_pkgc_vret_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_perf_dir_ldb_pkgc_vret_seq_stim_config


class hcw_perf_dir_ldb_pkgc_vret_seq extends sla_sequence_base;

  `ovm_sequence_utils(hcw_perf_dir_ldb_pkgc_vret_seq, sla_sequencer)

  rand hcw_perf_dir_ldb_pkgc_vret_seq_stim_config        cfg;

  hqm_reset_sequences_pkg::hqm_reset_unit_sequence      i_wait_no_clkreq_seq;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq2;
  hqm_power_retention_sequence                          vret_seq;
  hqm_power_up_sequence                                 von_seq;
  hcw_perf_dir_ldb_test1_hcw_seq                        hcw_perf_dir_ldb_test1_hcw;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_perf_dir_ldb_pkgc_vret_seq_stim_config);

  function new(string name = "hcw_perf_dir_ldb_pkgc_vret_seq");
    super.new(name);

    cfg = hcw_perf_dir_ldb_pkgc_vret_seq_stim_config::type_id::create("hcw_perf_dir_ldb_pkgc_vret_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    super.body();

    apply_stim_config_overrides(1);

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());

    if (cfg.do_wait_no_clkreq) begin
      // Wait for prim_clkreq and side_clreq to deassert
      `ovm_do_on_with(i_wait_no_clkreq_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_SIDE_CLKREQ_DEASSERT;});
      `ovm_info(get_type_name(),"Completed i_wait_no_clkreq_seq", OVM_DEBUG);
    end

    if (cfg.do_goto_vret) begin
      #100ns;
      `ovm_do(vret_seq);
      #1000ns;
    end

    if (cfg.do_goto_von) begin
      #100ns;
      `ovm_do(von_seq);
      #100ns;
    end

    `ovm_do(hcw_perf_dir_ldb_test1_hcw);

    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());
  endtask: body
endclass: hcw_perf_dir_ldb_pkgc_vret_seq   

