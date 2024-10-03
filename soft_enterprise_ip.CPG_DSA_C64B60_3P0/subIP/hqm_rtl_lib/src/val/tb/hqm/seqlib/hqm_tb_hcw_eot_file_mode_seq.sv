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
// File   : hqm_tb_hcw_eot_file_mode_seq.sv
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

class hqm_tb_hcw_eot_file_mode_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_tb_hcw_eot_file_mode_seq_stim_config";

  `ovm_object_utils_begin(hqm_tb_hcw_eot_file_mode_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_eot_rd_seq,               OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_eot_status_seq,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_wait_clkreq_deassert_seq, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_tb_hcw_eot_file_mode_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(do_eot_rd_seq)
    `stimulus_config_field_rand_int(do_eot_status_seq)
    `stimulus_config_field_rand_int(do_wait_clkreq_deassert_seq)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";

  rand  bit                     do_eot_rd_seq;
  rand  bit                     do_eot_status_seq;
  rand  bit                     do_wait_clkreq_deassert_seq;

  constraint c_do_eot_rd_seq_soft {
    soft do_eot_rd_seq       == 1'b1;
  }

  constraint c_do_eot_status_seq_soft {
    soft do_eot_status_seq   == 1'b1;
  }

  constraint c_do_wait_clkreq_deassert_seq_soft {
    soft do_wait_clkreq_deassert_seq == 1'b1;
  }

  function new(string name = "hqm_tb_hcw_eot_file_mode_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_tb_hcw_eot_file_mode_seq_stim_config

class hqm_tb_hcw_eot_file_mode_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_tb_hcw_eot_file_mode_seq,sla_sequencer)

  rand hqm_tb_hcw_eot_file_mode_seq_stim_config        cfg;

  hqm_eot_rd_seq                                        i_hqm_eot_rd_seq;
  hqm_tb_cfg_eot_file_mode_seq                          i_eot_file_mode_seq;
  hqm_tb_eot_status_seq                                 i_hqm_tb_eot_status_seq;
  hqm_tb_cfg_eot_post_file_mode_seq                     i_eot_post_file_mode_seq;
  hqm_reset_sequences_pkg::hqm_reset_unit_sequence      i_wait_clkreq_deassert_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_tb_hcw_eot_file_mode_seq_stim_config);

  function new(string name = "hqm_tb_hcw_eot_file_mode_seq");
    super.new(name);

    cfg = hqm_tb_hcw_eot_file_mode_seq_stim_config::type_id::create("hqm_tb_hcw_eot_file_mode_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    apply_stim_config_overrides(1);

    if (cfg.do_eot_rd_seq) begin
      `ovm_info(get_type_name(),"hqm_tb_hcw_eot_file_mode_seq: call hqm_eot_rd_seq", OVM_LOW);
      `ovm_do(i_hqm_eot_rd_seq)
    end

    `ovm_info(get_type_name(),"hqm_tb_hcw_eot_file_mode_seq: call hqm_tb_cfg_eot_file_mode_seq", OVM_LOW);
    `ovm_do(i_eot_file_mode_seq)

    if (cfg.do_eot_status_seq) begin
      `ovm_info(get_type_name(),"hqm_tb_hcw_eot_file_mode_seq: call hqm_tb_eot_status_seq", OVM_LOW);
      `ovm_do(i_hqm_tb_eot_status_seq)
    end

    `ovm_info(get_type_name(),"hqm_tb_hcw_eot_file_mode_seq: call hqm_tb_cfg_eot_post_file_mode_seq", OVM_LOW);
    `ovm_do(i_eot_post_file_mode_seq)

    if (cfg.do_wait_clkreq_deassert_seq) begin
      // Wait for prim_clkreq and side_clreq to deassert
      `ovm_do_on_with(i_wait_clkreq_deassert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_SIDE_CLKREQ_DEASSERT;});
      `ovm_info(get_type_name(),"Completed i_wait_clkreq_deassert_seq", OVM_LOW);
    end

  endtask

endclass : hqm_tb_hcw_eot_file_mode_seq
