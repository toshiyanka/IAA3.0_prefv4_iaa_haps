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
// File   : hqm_pok_user_data_seq.sv
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

class hqm_pok_user_data_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pok_user_data_seq_stim_config";

  `ovm_object_utils_begin(hqm_pok_user_data_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_warm_reset,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_wait_no_clkreq,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(default_strap_no_mgmt_acks,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(default_ip_ready,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pok_user_data_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_rand_int(do_warm_reset)
    `stimulus_config_field_rand_int(do_wait_no_clkreq)
    `stimulus_config_field_rand_int(default_strap_no_mgmt_acks)
    `stimulus_config_field_rand_int(default_ip_ready)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_DATA_SEQ";
  string                        file_mode_plusarg2 = "HQM_DATA_SEQ2";

  rand  bit                     do_warm_reset;
  rand  bit                     do_wait_no_clkreq;
  rand  bit                     default_strap_no_mgmt_acks;
  rand  bit                     default_ip_ready;

  constraint c_do_warm_reset_soft {
    do_warm_reset       == 1'b0;
  }

  constraint c_do_wait_no_clkreq_soft {
    do_wait_no_clkreq       == 1'b0;
  }

  constraint c_strap_no_mgmt_acks_soft {
    default_strap_no_mgmt_acks       == 1'b0;
  }

  constraint c_ip_ready_soft {
    default_ip_ready       == 1'b1;
  }

  function new(string name = "hqm_pok_user_data_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pok_user_data_seq_stim_config

class hqm_pok_user_data_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_pok_user_data_seq, sla_sequencer)

  rand hqm_pok_user_data_seq_stim_config        cfg;

  ovm_event_pool        global_pool;
  ovm_event             hqm_ip_ready;
  ovm_event             hqm_config_acks;
  ovm_event             hqm_fuse_download_req;

  hqm_iosf_prim_mon     i_hqm_iosf_prim_mon;
  hqm_tb_hcw_scoreboard i_hcw_scoreboard;

  hqm_reset_sequences_pkg::hqm_reset_unit_sequence      i_wait_no_clkreq_seq;
  hqm_reset_sequences_pkg::hqm_warm_reset_sequence      i_warm_reset_seq;
  hqm_reset_sequences_pkg::hqm_reset_unit_sequence      i_warm_reset_deassert_seq1;
  hqm_reset_sequences_pkg::hqm_reset_unit_sequence      i_warm_reset_deassert_seq2;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq2;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pok_user_data_seq_stim_config);

  bit [15:0] default_early_fuses;


  function new(string name = "hqm_pok_user_data_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name);

    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ip_ready = global_pool.get("hqm_ip_ready");
    hqm_config_acks = global_pool.get("hqm_config_acks");
    hqm_fuse_download_req = global_pool.get("hqm_fuse_download_req");

    cfg = hqm_pok_user_data_seq_stim_config::type_id::create("hqm_pok_user_data_seq_stim_config");
    apply_stim_config_overrides(0);

    default_early_fuses=0;
    if ($value$plusargs("HQM_TB_FUSE_VALUES=%h", default_early_fuses)) begin
      `ovm_info(get_full_name(),$psprintf("HQM_TB_FUSE_VALUES default value to drive early_fuses = 0x%0x", default_early_fuses),OVM_LOW)
    end
  endfunction

  virtual task body();
    ovm_object o_tmp;

    if (!p_sequencer.get_config_object("i_hqm_iosf_prim_mon", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_iosf_prim_mon object");
    end

    if (!$cast(i_hqm_iosf_prim_mon, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_iosf_prim_mon not compatible with type of i_hqm_iosf_prim_mon"));
    end

    if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
    end

    if (!$cast(i_hcw_scoreboard, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
    end

    apply_stim_config_overrides(1);

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());

    if (cfg.do_wait_no_clkreq) begin
      // Wait for prim_clkreq and side_clreq to deassert
      `ovm_do_on_with(i_wait_no_clkreq_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_SIDE_CLKREQ_DEASSERT;});
      `ovm_info(get_type_name(),"Completed i_wait_no_clkreq_seq", OVM_LOW);
    end

    if (cfg.do_warm_reset) begin
      `ovm_do(i_warm_reset_seq)
      // De assert all resets except Primary reset
      `ovm_do_on_with(i_warm_reset_deassert_seq1, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::RESET_DEASSERT_PART1; EarlyFuseIn_l==default_early_fuses;});
      `ovm_info(get_type_name(),"completed i_warm_reset_deassert_seq1", OVM_LOW);

      // wait for Fuse pull message
      hqm_fuse_download_req.wait_trigger();
      `ovm_info(get_type_name(),"Got hqm_fuse_download_req request", OVM_LOW);

      if (cfg.default_strap_no_mgmt_acks || cfg.default_ip_ready) begin
          // Wait for ip_ready from HQM output port
          hqm_config_acks.wait_trigger();
         `ovm_info(get_type_name(),"Got ip_ready responded on HQM output port", OVM_DEBUG);
      end else begin
         // Wait for IP_READY message from IP SB
         hqm_ip_ready.wait_trigger();
         `ovm_info(get_type_name(),"Got hqm_ip_ready request", OVM_LOW);
      end

      // Deassert Primary reset
      `ovm_do_on_with(i_warm_reset_deassert_seq2, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::RESET_DEASSERT_PART2;});
      `ovm_info(get_type_name(),"Completed i_warm_reset_deassert_seq2", OVM_LOW);

      i_hqm_iosf_prim_mon.cq_gen_reset();
      i_hcw_scoreboard.hcw_scoreboard_reset();
    end

    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());
  endtask

endclass : hqm_pok_user_data_seq
