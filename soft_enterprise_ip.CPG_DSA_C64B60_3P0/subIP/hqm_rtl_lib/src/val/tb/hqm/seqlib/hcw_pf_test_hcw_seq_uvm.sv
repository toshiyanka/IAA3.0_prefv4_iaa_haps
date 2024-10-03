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
// File   : hcw_pf_test_hcw_seq.sv
//
// Description :
//
//   Sequence that supports HCW traffic for hcw_pf_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hcw_pf_test_hcw_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_pf_test_hcw_seq_stim_config";

  `uvm_object_utils_begin(hcw_pf_test_hcw_seq_stim_config)
    `uvm_field_string(tb_env_hier,                      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(inst_suffix,                      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_enum(hqm_pp_cq_base_seq::hcw_delay_rand_type_t, hcw_delay_type, UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_num_hcw,                         UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_num_loop,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_num_hcw_loop,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_stream_ctl,                      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_hcw_time,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_hcw_delay_min,                   UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_hcw_delay_max,                   UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_batch_min,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_batch_max,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_num_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_num_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_pad_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_pad_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_shuffle_min,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cacheline_max_shuffle_max,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cl_pad,                          UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_pad_prob_min,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_pad_prob_max,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_expad_prob_min,                  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_expad_prob_max,                  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_enum(hcw_qtype,          dir_qtype,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_num_hcw,                         UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_num_loop,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_num_hcw_loop,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_stream_ctl,                      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_hcw_time,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_hcw_delay_min,                   UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_hcw_delay_max,                   UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_batch_min,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_batch_max,                       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_num_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_num_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_pad_min,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_pad_max,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_shuffle_min,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cacheline_max_shuffle_max,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cl_pad,                          UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_wu_min,                          UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_wu_max,                          UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_pad_prob_min,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_pad_prob_max,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_expad_prob_min,                  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_expad_prob_max,                  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_acomp_rtn_ctrl,                  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(a_comp_return_delay,                 UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(a_comp_return_delay_mode,            UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(comp_return_delay,                   UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(comp_return_delay_mode,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(tok_return_delay,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(tok_return_delay_mode,               UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_enum(hcw_qtype,          ldb_qtype,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ctl_cq_base_addr,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cq_base_addr,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cq_base_addr,                    UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cq_hpa_base_addr,                UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cq_hpa_base_addr,                UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_cq_space,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_cq_space,                        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_cq_addr_q,                 UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_cq_addr_q,                 UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_cq_hpa_addr_q,             UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_cq_hpa_addr_q,             UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_cq_intr_remap_addr_q,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_cq_intr_remap_addr_q,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_pf_test_hcw_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(dir_num_hcw)
    `stimulus_config_field_rand_int(dir_num_loop)
    `stimulus_config_field_rand_int(dir_num_hcw_loop)
    `stimulus_config_field_rand_int(dir_stream_ctl)
    `stimulus_config_field_rand_int(dir_hcw_time)
    `stimulus_config_field_rand_enum(hqm_pp_cq_base_seq::hcw_delay_rand_type_t,hcw_delay_type)
    `stimulus_config_field_rand_int(dir_hcw_delay_min)
    `stimulus_config_field_rand_int(dir_hcw_delay_max)
    `stimulus_config_field_rand_int(dir_batch_min)
    `stimulus_config_field_rand_int(dir_batch_max)

    `stimulus_config_field_rand_int(dir_cacheline_max_num_min)
    `stimulus_config_field_rand_int(dir_cacheline_max_num_max)
    `stimulus_config_field_rand_int(dir_cacheline_max_pad_min)
    `stimulus_config_field_rand_int(dir_cacheline_max_pad_max)
    `stimulus_config_field_rand_int(dir_cacheline_max_shuffle_min)
    `stimulus_config_field_rand_int(dir_cacheline_max_shuffle_max)
    `stimulus_config_field_rand_int(dir_cl_pad)

    `stimulus_config_field_rand_int(dir_pad_prob_min)
    `stimulus_config_field_rand_int(dir_pad_prob_max)
    `stimulus_config_field_rand_int(dir_expad_prob_min)
    `stimulus_config_field_rand_int(dir_expad_prob_max)
    `stimulus_config_field_rand_enum(hcw_qtype,dir_qtype)
    `stimulus_config_field_rand_int(ldb_num_hcw)
    `stimulus_config_field_rand_int(ldb_num_loop)
    `stimulus_config_field_rand_int(ldb_num_hcw_loop)
    `stimulus_config_field_rand_int(ldb_stream_ctl)
    `stimulus_config_field_rand_int(ldb_hcw_time)
    `stimulus_config_field_rand_int(ldb_hcw_delay_min)
    `stimulus_config_field_rand_int(ldb_hcw_delay_max)
    `stimulus_config_field_rand_int(ldb_batch_min)
    `stimulus_config_field_rand_int(ldb_batch_max)
    `stimulus_config_field_rand_int(ldb_cacheline_max_num_min)
    `stimulus_config_field_rand_int(ldb_cacheline_max_num_max)
    `stimulus_config_field_rand_int(ldb_cacheline_max_pad_min)
    `stimulus_config_field_rand_int(ldb_cacheline_max_pad_max)
    `stimulus_config_field_rand_int(ldb_cacheline_max_shuffle_min)
    `stimulus_config_field_rand_int(ldb_cacheline_max_shuffle_max)
    `stimulus_config_field_rand_int(ldb_cl_pad)
    `stimulus_config_field_rand_int(ldb_wu_min)
    `stimulus_config_field_rand_int(ldb_wu_max)
    `stimulus_config_field_rand_int(ldb_pad_prob_min)
    `stimulus_config_field_rand_int(ldb_pad_prob_max)
    `stimulus_config_field_rand_int(ldb_expad_prob_min)
    `stimulus_config_field_rand_int(ldb_expad_prob_max)
    `stimulus_config_field_rand_int(ldb_acomp_rtn_ctrl)
    `stimulus_config_field_rand_int(comp_return_delay)
    `stimulus_config_field_rand_int(comp_return_delay_mode)
    `stimulus_config_field_rand_int(a_comp_return_delay)
    `stimulus_config_field_rand_int(a_comp_return_delay_mode)
    `stimulus_config_field_rand_int(tok_return_delay)
    `stimulus_config_field_rand_int(tok_return_delay_mode)
    `stimulus_config_field_rand_enum(hcw_qtype,ldb_qtype)
    `stimulus_config_field_int(ctl_cq_base_addr)
    `stimulus_config_field_int(dir_cq_base_addr)
    `stimulus_config_field_int(ldb_cq_base_addr)
    `stimulus_config_field_int(dir_cq_hpa_base_addr)
    `stimulus_config_field_int(ldb_cq_hpa_base_addr)
    `stimulus_config_field_int(dir_cq_space)
    `stimulus_config_field_int(ldb_cq_space)
    `stimulus_config_field_queue_int(dir_cq_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_addr_q)
    `stimulus_config_field_queue_int(dir_cq_hpa_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_hpa_addr_q)
    `stimulus_config_field_queue_int(dir_cq_intr_remap_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_intr_remap_addr_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  hqm_pp_cq_base_seq::hcw_delay_rand_type_t       hcw_delay_type;

  rand  int                     dir_num_hcw;
  rand  int                     dir_num_loop;
  rand  int                     dir_num_hcw_loop;
  rand  int                     dir_stream_ctl;
  rand  int                     dir_hcw_time;
  rand  int                     dir_hcw_delay_min;
  rand  int                     dir_hcw_delay_max;
  rand  int                     dir_batch_min;
  rand  int                     dir_batch_max;

  rand  int                     dir_cacheline_max_num_min;     
  rand  int                     dir_cacheline_max_num_max;     
  rand  int                     dir_cacheline_max_pad_min;     
  rand  int                     dir_cacheline_max_pad_max;     
  rand  int                     dir_cacheline_max_shuffle_min;     
  rand  int                     dir_cacheline_max_shuffle_max;     

  rand  int                     dir_cl_pad;
  rand  int                     dir_pad_prob_min;
  rand  int                     dir_pad_prob_max;
  rand  int                     dir_expad_prob_min;
  rand  int                     dir_expad_prob_max;
  rand  hcw_qtype               dir_qtype;

  rand  int                     ldb_num_hcw;
  rand  int                     ldb_num_loop;
  rand  int                     ldb_num_hcw_loop;
  rand  int                     ldb_stream_ctl;
  rand  int                     ldb_hcw_time;
  rand  int                     ldb_hcw_delay_min;
  rand  int                     ldb_hcw_delay_max;
  rand  int                     ldb_batch_min;
  rand  int                     ldb_batch_max;
  rand  int                     ldb_cacheline_max_num_min;     
  rand  int                     ldb_cacheline_max_num_max;     
  rand  int                     ldb_cacheline_max_pad_min;     
  rand  int                     ldb_cacheline_max_pad_max;     
  rand  int                     ldb_cacheline_max_shuffle_min;     
  rand  int                     ldb_cacheline_max_shuffle_max;     
  rand  int                     ldb_cl_pad;
  rand  int                     ldb_wu_min;
  rand  int                     ldb_wu_max;
  rand  int                     ldb_pad_prob_min;
  rand  int                     ldb_pad_prob_max;
  rand  int                     ldb_expad_prob_min;
  rand  int                     ldb_expad_prob_max;
  rand  hcw_qtype               ldb_qtype;

  rand  int                     ldb_acomp_rtn_ctrl;

  rand  int                     comp_return_delay;
  rand  int                     comp_return_delay_mode;
  rand  int                     a_comp_return_delay;
  rand  int                     a_comp_return_delay_mode;
  rand  int                     tok_return_delay;
  rand  int                     tok_return_delay_mode;

  int                           ctl_cq_base_addr=0;
  bit [63:0]                    dir_cq_base_addr = 64'h00000001_23450000;
  bit [63:0]                    ldb_cq_base_addr = 64'h00000006_789a0000;
  bit [63:0]                    dir_cq_hpa_base_addr = 64'h0000000F_BEEF0000;
  bit [63:0]                    ldb_cq_hpa_base_addr = 64'h0000000B_CAFE0000;
  bit [15:0]                    dir_cq_space = 16'h4000;
  bit [15:0]                    ldb_cq_space = 16'h4000;

  bit [63:0]                    dir_cq_addr_q[$];
  bit [63:0]                    ldb_cq_addr_q[$];

  bit [63:0]                    dir_cq_hpa_addr_q[$];
  bit [63:0]                    ldb_cq_hpa_addr_q[$];

  bit [63:0]                    dir_cq_intr_remap_addr_q[$];
  bit [63:0]                    ldb_cq_intr_remap_addr_q[$];

  constraint c_num_hcw {
    dir_num_hcw                 >= 0;
    dir_hcw_time                >= 0;
    ldb_num_hcw                 >= 0;
    ldb_hcw_time                >= 0;

    dir_num_hcw > 0     ->      dir_hcw_time == 0;
    dir_hcw_time > 0    ->      dir_num_hcw == 0;
    ldb_num_hcw > 0     ->      ldb_hcw_time == 0;
    ldb_hcw_time > 0    ->      ldb_num_hcw == 0;

    dir_num_hcw +
    dir_hcw_time                > 0;

    ldb_num_hcw +
    ldb_hcw_time                > 0;
  }

  constraint c_num_hcw_soft {
    soft dir_num_hcw    inside { 32,64,128 };
    soft dir_hcw_time   == 0;
    soft ldb_num_hcw    inside { 32,64,128 };
    soft ldb_hcw_time   == 0;

    soft dir_num_loop == 0;
    soft dir_num_hcw_loop == 0;
    soft dir_stream_ctl == 0;
    soft ldb_num_loop == 0;
    soft ldb_num_hcw_loop == 0;
    soft ldb_stream_ctl == 0;
  }

  constraint c_hcw_delay {
    dir_hcw_delay_min       > 0;
    dir_hcw_delay_max       > 0;
    dir_hcw_delay_min       <= dir_hcw_delay_max;

    ldb_hcw_delay_min       > 0;
    ldb_hcw_delay_max       > 0;
    ldb_hcw_delay_min       <= ldb_hcw_delay_max;
  }

  constraint c_hcw_delay_soft {
    soft hcw_delay_type == hqm_pp_cq_base_seq::NORMAL_DIST;
    soft dir_hcw_delay_min  inside { 2,4,8,40 };
    soft dir_hcw_delay_min  == dir_hcw_delay_max;

    soft ldb_hcw_delay_min  inside { 4,8,16,80 };
    soft ldb_hcw_delay_min  == ldb_hcw_delay_max;
  }

  constraint c_dir_batch {
    dir_batch_min >= 1;
    dir_batch_min <= 4;

    dir_batch_max >= 1;
    dir_batch_max <= 4;

    dir_batch_min <= dir_batch_max;
  }

  constraint c_dir_max_cacheline_ctrl {
    dir_cacheline_max_num_min == 1;
    dir_cacheline_max_num_max == 1;
    dir_cacheline_max_pad_min == 0;
    dir_cacheline_max_pad_max == 0;
    dir_cacheline_max_shuffle_min == 0;
    dir_cacheline_max_shuffle_max == 0;
  }

  constraint c_dir_pad_prob_soft {
    soft dir_pad_prob_min == 0;
    soft dir_pad_prob_max == 0;
    soft dir_expad_prob_min == 0;
    soft dir_expad_prob_max == 0;
  }

  constraint c_ldb_batch {
    ldb_batch_min >= 1;
    ldb_batch_min <= 4;

    ldb_batch_max >= 1;
    ldb_batch_max <= 4;

    ldb_batch_min <= ldb_batch_max;
  }

  constraint c_ldb_max_cacheline_ctrl {
    ldb_cacheline_max_num_min == 1;
    ldb_cacheline_max_num_max == 1;
    ldb_cacheline_max_pad_min == 0;
    ldb_cacheline_max_pad_max == 0;
    ldb_cacheline_max_shuffle_min == 0;
    ldb_cacheline_max_shuffle_max == 0;
  }

  constraint c_cl_pad_soft {
    soft ldb_cl_pad == 0;
    soft dir_cl_pad == 0;
  }

  constraint c_ldb_wu_soft {
    soft ldb_wu_min == 0;
    soft ldb_wu_max == 0;
  }

  constraint c_ldb_pad_prob_soft {
    soft ldb_pad_prob_min == 0;
    soft ldb_pad_prob_max == 0;
    soft ldb_expad_prob_min == 0;
    soft ldb_expad_prob_max == 0;
  }

  constraint c_ldb_acomp_ctrl_soft {
    soft ldb_acomp_rtn_ctrl == -1;

    soft comp_return_delay == 0;
    soft comp_return_delay_mode == -1;
    soft a_comp_return_delay == 0;
    soft a_comp_return_delay_mode == -1;
    soft tok_return_delay == 0;
    soft tok_return_delay_mode == -1;
  }

  constraint c_ldb_wu {
    ldb_wu_min >= 0;
    ldb_wu_min <= 3;

    ldb_wu_max >= 0;
    ldb_wu_max <= 3;

    ldb_wu_min <= ldb_wu_max;
  }

  constraint c_qtype_soft {
    soft dir_qtype      == QDIR;
    soft ldb_qtype      == QUNO;
  }

  function new(string name = "hcw_pf_test_hcw_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_test_hcw_seq_stim_config

class hcw_pf_test_hcw_seq extends slu_sequence_base;

  `uvm_object_utils(hcw_pf_test_hcw_seq) 

  `uvm_declare_p_sequencer(slu_sequencer)

  rand hcw_pf_test_hcw_seq_stim_config  cfg;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_test_hcw_seq_stim_config);
`endif

  hcw_pf_test_stim_dut_view     dut_view;

  hqm_cfg                       i_hqm_cfg;

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

  hqm_pp_cq_base_seq            dir_pp_cq_seq[hqm_pkg::NUM_DIR_PP];

  hqm_pp_cq_base_seq            ldb_pp_cq_seq[hqm_pkg::NUM_LDB_PP];

  hqm_pp_cq_status              i_hqm_pp_cq_status;

  int                           dir_qid_avail[$];
  int                           ldb_qid_avail[$];
  int                           ldb_qid_avail_2nd[$];

  //--cq_addr reprogramming
  int                           cq_addr_ctrl;

  semaphore                     qid_sem;

  function new(string name = "hcw_pf_test_hcw_seq");
    super.new(name);

    qid_sem = new(1);

    cfg = hcw_pf_test_hcw_seq_stim_config::type_id::create("hcw_pf_test_hcw_seq_stim_config");
`ifdef IP_OVM_STIM
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  endfunction

  virtual task body();
    uvm_object                  o_tmp;

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    dut_view = hcw_pf_test_stim_dut_view::instance(m_sequencer,cfg.inst_suffix);

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",cfg.inst_suffix}, o_tmp)) begin
       uvm_report_info(get_full_name(), "hcw_pf_test_hcw_seq: Unable to find i_hqm_cfg object", UVM_LOW);
       i_hqm_cfg = null;
    end else begin
       if (!$cast(i_hqm_cfg, o_tmp)) begin
         uvm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
       end 
    end 

    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hcw_scoreboard",cfg.inst_suffix}, o_tmp)) begin
       uvm_report_info(get_full_name(), "hcw_pf_test_hcw_seq: Unable to find i_hcw_scoreboard object", UVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         uvm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end 
    end 

    //-----------------------------
    // -- get i_hqm_pp_cq_status
    //-----------------------------
    if ( p_sequencer.get_config_object({"i_hqm_pp_cq_status",cfg.inst_suffix}, o_tmp) ) begin
        if ( ! ($cast(i_hqm_pp_cq_status, o_tmp)) ) begin
            uvm_report_fatal(get_full_name(), $psprintf("Object passed through i_hqm_pp_cq_status not compatible with class type hqm_pp_cq_status"));
        end 
    end else begin
        uvm_report_info(get_full_name(), $psprintf("No i_hqm_pp_cq_status set through set_config_object"));
        i_hqm_pp_cq_status = null;
    end 

    //-----------------------------
    //-----------------------------
    cq_addr_ctrl = cfg.ctl_cq_base_addr;
    if($test$plusargs("HQM_CQ_ADDR_REPROG")) begin
       cq_addr_ctrl = 1;
    end 
    uvm_report_info("hcw_pf_test_hcw_seq", $psprintf("hcw_pf_test_hcw_seq: Starting PF Traffic with num_dir_pp=%0d num_ldb_pp=%0d enable_msix=%0d enable_ims_poll=%0d enable_wdog_cq=%0d; cq_addr_ctrl=%0d", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.enable_msix, dut_view.enable_ims_poll, dut_view.enable_wdog_cq, cq_addr_ctrl), UVM_NONE);

    //-----------------------------
    //-----------------------------
    if(cq_addr_ctrl==1) hqm_cq_addr_reprogram();

    //-----------------------------
    //-----------------------------
    dir_qid_avail.delete();
    ldb_qid_avail.delete();
    ldb_qid_avail_2nd.delete();

    for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
      if (i_hqm_cfg.is_qid_v( 1'b1, qid)) begin
        ldb_qid_avail.push_back(qid);
      end 
    end 
    if(dut_view.num_ldb_pp >= hqm_pkg::NUM_LDB_QID) begin
      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
         if (i_hqm_cfg.is_qid_v( 1'b1, qid)) begin
           ldb_qid_avail_2nd.push_back(qid);
         end 
      end 
    end 

    for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
      if (i_hqm_cfg.is_qid_v( 1'b0, qid)) begin
        dir_qid_avail.push_back(qid);
      end 
    end 

    //-----------------------------
    //-- tasks 
    //-----------------------------
    for (int i = 0 ; i < dut_view.num_dir_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.dir_cq_hpa_addr_q.size()>pp) begin
            uvm_report_info("hcw_pf_test_hcw_seq", $psprintf("hcw_pf_test_hcw_seq: Call start_pp_cq DIRPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.dir_cq_hpa_addr_q[pp]), UVM_NONE);

            if(cfg.dir_cq_intr_remap_addr_q.size()>pp) begin
               uvm_report_info("hcw_pf_test_hcw_seq", $psprintf("hcw_pf_test_hcw_seq: Call start_pp_cq DIRPP[%0d].cq_hpa_addr=0x%0x with dir_cq_intr_remap_addr_q[%0d]=0x%0x", pp, cfg.dir_cq_hpa_addr_q[pp], pp, cfg.dir_cq_intr_remap_addr_q[pp]), UVM_NONE);
               start_pp_cq(.is_ldb(0), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.dir_cq_hpa_addr_q[pp]), .intr_remap_addr(cfg.dir_cq_intr_remap_addr_q[pp]), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
            end else begin
               start_pp_cq(.is_ldb(0), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.dir_cq_hpa_addr_q[pp]), .intr_remap_addr(0),  .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
            end 
          end else begin
            start_pp_cq(.is_ldb(0), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .intr_remap_addr(0),  .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
          end 
        end 
      join_none
    end 

    for (int i = 0 ; i < dut_view.num_ldb_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.ldb_cq_hpa_addr_q.size()>pp) begin
            uvm_report_info("hcw_pf_test_hcw_seq", $psprintf("hcw_pf_test_hcw_seq: Call start_pp_cq LDBPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.ldb_cq_hpa_addr_q[pp]), UVM_NONE);

            if(cfg.ldb_cq_intr_remap_addr_q.size()>pp) begin
                uvm_report_info("hcw_pf_test_hcw_seq", $psprintf("hcw_pf_test_hcw_seq: Call start_pp_cq LDBPP[%0d].cq_hpa_addr=0x%0x with ldb_cq_intr_remap_addr_q[%0d]=0x%0x", pp, cfg.ldb_cq_hpa_addr_q[pp], pp, cfg.ldb_cq_intr_remap_addr_q[pp]), UVM_NONE);
                start_pp_cq(.is_ldb(1), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.ldb_cq_hpa_addr_q[pp]), .intr_remap_addr(cfg.ldb_cq_intr_remap_addr_q[pp]),  .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
            end else begin
                start_pp_cq(.is_ldb(1), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.ldb_cq_hpa_addr_q[pp]), .intr_remap_addr(0),  .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
            end 
          end else begin
            start_pp_cq(.is_ldb(1), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .intr_remap_addr(0),  .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
          end 
        end 
      join_none
    end 

    fork
        msix_0_interrupt_monitor();
    join_none

    wait fork;

    uvm_report_info(get_full_name(), "hcw_pf_test_hcw_seq: Traffic Completed", UVM_NONE);

    //-----------------------------
    //-- super 
    //-----------------------------
    super.body();

    //-----------------------------
    //-- MULTI_INGRESS_ERR_INJ 
    //-----------------------------
    if ($test$plusargs("MULTI_INGRESS_ERR_INJ")) begin

        sla_ral_env           ral;
        sla_ral_reg           reg_h;
        slu_status_t          status;
        sla_ral_access_path_t ral_access_path;
        sla_ral_data_t        val[$];

        uvm_report_info(get_full_name(), $psprintf("Checking whether more and valid bits are set in pf_synd0 register"), UVM_LOW);
        ral_access_path = i_hqm_cfg.ral_access_path; //"iosf_pri";
        $cast(ral, sla_ral_env::get_ptr());

        if (ral == null) begin
            `uvm_fatal(get_full_name(), $psprintf("Unable to get RAL ptr"))
        end 

        reg_h = ral.find_reg_by_file_name("alarm_pf_synd0", {cfg.tb_env_hier,".hqm_system_csr"});
        if (reg_h == null) begin
            `uvm_fatal(get_full_name(), $psprintf("Couldn't get ptr to register alarm_pf_synd0"))
        end 

        reg_h.readx_fields(status, {"VALID", "MORE"}, {1'b1, 1'b1}, val, ral_access_path);
        reg_h.write_fields(status, {"VALID", "MORE"}, {1'b1, 1'b1}, ral_access_path);

    end 

  endtask

  //---------------------------------------------
  //--  hqm_cq_addr_reprogram()
  //---------------------------------------------
  task hqm_cq_addr_reprogram();
     sla_ral_env         ral;
     sla_ral_reg         my_reg;
     sla_ral_field       my_field;
     sla_ral_data_t      ral_data;
     slu_status_t        status;
     string              pp_cq_prefix;
     sla_ral_access_path_t ral_access_path;

     bit [63:0]                    decode_cq_gpa_tmp; 
     bit [63:0]                    decode_cq_gpa_addr; 
     bit [63:0]                    decode_cq_hpa_addr; 
     int                           pasid_tmp;
     int                           pp_idx;

     ral_access_path = i_hqm_cfg.ral_access_path; //"iosf_pri";
     uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming CQ address with the setting of cfg.dir_cq_addr_q.size=%0d cfg.dir_cq_hpa_addr_q.size=%0d cfg.dir_cq_base_addr=0x%0x cfg.dir_cq_space=0x%0x; cfg.ldb_cq_addr_q.size=%0d cfg.ldb_cq_hpa_addr_q.size=%0d ldb_cq_base_addr=0x%0x cfg.ldb_cq_space=0x%0x; ral_access_path=%0s", cfg.dir_cq_addr_q.size(), cfg.dir_cq_hpa_addr_q.size(), cfg.dir_cq_base_addr, cfg.dir_cq_space, cfg.ldb_cq_addr_q.size(), cfg.ldb_cq_hpa_addr_q.size(), cfg.ldb_cq_base_addr, cfg.ldb_cq_space,ral_access_path), UVM_NONE);

     if ($value$plusargs("HQM_RAL_ACCESS_PATH=%s", ral_access_path)) begin
      `uvm_info(get_full_name(),$psprintf("hcw_pf_test_hcw_seq: Reprogramming access_path is overrided by +HQM_RAL_ACCESS_PATH=%s", ral_access_path), UVM_LOW)
     end 

     $cast(ral, sla_ral_env::get_ptr());
     if (ral == null) begin
       uvm_report_fatal("CFG", "Unable to get RAL handle in hqm_cq_addr_reprogram");
     end 


       //-- LDB
       pp_idx=0;

       foreach(i_hqm_cfg.ldb_pp_cq_cfg[pp]) begin
          if(i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned) begin
              pp_cq_prefix = "LDB";
              if(pp < cfg.ldb_cq_addr_q.size()) begin
                 decode_cq_gpa_addr = cfg.ldb_cq_addr_q[pp];  
                 i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa = cfg.ldb_cq_addr_q[pp];
                 i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_hpa = cfg.ldb_cq_hpa_addr_q[pp];              
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with cfg.ldb_cq_addr_q[%0d]=0x%0x",     pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa, pp, cfg.ldb_cq_addr_q[pp]), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with cfg.ldb_cq_hpa_addr_q[%0d]=0x%0x", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_hpa, pp, cfg.ldb_cq_hpa_addr_q[pp]), UVM_LOW);
              end else begin
                 decode_cq_gpa_addr = cfg.ldb_cq_base_addr     + pp_idx * cfg.ldb_cq_space;
                 decode_cq_hpa_addr = cfg.ldb_cq_hpa_base_addr + pp_idx * cfg.ldb_cq_space;
                 i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;
                 i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_hpa = decode_cq_hpa_addr;              
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with ldb_cq_base_addr=0x%0x     + pp*ldb_cq_space=0x%0x", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa, cfg.ldb_cq_base_addr, pp*cfg.ldb_cq_space), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with ldb_cq_hpa_base_addr=0x%0x + pp*ldb_cq_space=0x%0x", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_hpa, cfg.ldb_cq_hpa_base_addr, pp*cfg.ldb_cq_space), UVM_LOW);
              end 

              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, this);
              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, this);
              pp_idx++; 
          end 
       end 


       //-- DIR
       pp_idx=0;
       foreach(i_hqm_cfg.dir_pp_cq_cfg[pp]) begin
          if(i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned) begin
              pp_cq_prefix = "DIR";
              if(pp < cfg.dir_cq_addr_q.size()) begin
                 decode_cq_gpa_addr = cfg.dir_cq_addr_q[pp];  
                 i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa = cfg.dir_cq_addr_q[pp];
                 i_hqm_cfg.dir_pp_cq_cfg[pp].cq_hpa = cfg.dir_cq_hpa_addr_q[pp];              
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with cfg.dir_cq_addr_q[%0d]=0x%0x",     pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa, pp, cfg.dir_cq_addr_q[pp]), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with cfg.dir_cq_hpa_addr_q[%0d]=0x%0x", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_hpa, pp, cfg.dir_cq_hpa_addr_q[pp]), UVM_LOW);
              end else begin
                 decode_cq_gpa_addr = cfg.dir_cq_base_addr     + pp_idx * cfg.dir_cq_space;
                 decode_cq_hpa_addr = cfg.dir_cq_hpa_base_addr + pp_idx * cfg.dir_cq_space;
                 i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;
                 i_hqm_cfg.dir_pp_cq_cfg[pp].cq_hpa = decode_cq_hpa_addr;              
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with dir_cq_base_addr=0x%0x     + pp*dir_cq_space=0x%0x", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa, cfg.dir_cq_base_addr, pp*cfg.dir_cq_space), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with dir_cq_hpa_base_addr=0x%0x + pp*dir_cq_space=0x%0x", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_hpa, cfg.dir_cq_hpa_base_addr, pp*cfg.dir_cq_space), UVM_LOW);
              end 

              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, this);
              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, this);
              pp_idx++; 
          end 
       end 

       uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq: Reprogramming CQ address done"), UVM_NONE);
  endtask


  //---------------------------------------------
  //--  msix_0_interrupt_monitor
  //---------------------------------------------
  task msix_0_interrupt_monitor();
 
      sla_ral_env           ral;
      sla_ral_reg           reg_h;
      slu_status_t          status;
      sla_ral_access_path_t ral_access_path;
      bit                   msix_0_seen;

      // -- ral access path
      ral_access_path = i_hqm_cfg.ral_access_path; //"iosf_pri";
      $cast(ral, sla_ral_env::get_ptr());

      if (ral == null) begin
          `uvm_fatal(get_full_name(), $psprintf("Unable to get RAL ptr"))
      end 

      reg_h = ral.find_reg_by_file_name("msix_ack", {cfg.tb_env_hier,".hqm_system_csr"});
      if (reg_h == null) begin
          `uvm_fatal(get_full_name(), $psprintf("Unable to get ptr to msix_ack register in hqm_system_csr"))
      end 

      if ($test$plusargs("MSIX_0_ISR_ENABLED")) begin
         uvm_report_info(get_full_name(), $psprintf("MSIX_0_ISR_ENABLED plusargs provided, ISR for MSIX-0 interrupt will run"), UVM_LOW);
         fork
             forever begin
                 repeat(100) begin @(slu_tb_env::sys_clk_r); end 
                 if (i_hcw_scoreboard.hcw_scoreboard_idle()) begin
                     uvm_report_info(get_full_name(), $psprintf("Exiting the MSIX-0 ISR routine"), UVM_LOW);
                     break;
                 end 
             end 
             forever begin
  
                 bit [15:0] msix_data;
  
                 i_hqm_pp_cq_status.wait_for_msix_int(0, msix_data);
                 uvm_report_info(get_full_name(), $psprintf("Received MSI-X 0 interrupt, clearing the field msix_0_ack of MSIX_ACK"), UVM_LOW);
                 reg_h.write_fields(status, {"MSIX_0_ACK"}, {1'b1}, ral_access_path, this);
                 msix_0_seen = 1'b1;
             end 
         join_any
         if (msix_0_seen) begin
             uvm_report_info(get_full_name(), $psprintf("MSIX 0 interrupt seen"), UVM_LOW);
         end else begin
            `uvm_error(get_full_name(), $psprintf("MSIX 0 interrupt not at all seen"));
         end 
      end else begin
         uvm_report_info(get_full_name(), $psprintf("MSIX_0_ISR_ENABLED plusargs not provided; no ISR for MSIX-0 interrupt"), UVM_LOW);
      end 
  
  endtask : msix_0_interrupt_monitor

  //---------------------------------------------
  //-- start_pp_cq 
  //---------------------------------------------
  virtual task start_pp_cq(bit is_ldb, int pp_cq_index_in, int has_cq_hpa_addr, bit[63:0] cq_hpa_addr, bit[63:0] intr_remap_addr,  int queue_list_size, output hqm_pp_cq_base_seq pp_cq_seq);
    int                 pp_cq_num_in;
    int                 qid;
    int                 qid_index;
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_field       my_field;
    sla_ral_data_t      ral_data;
    logic [63:0]        trf_cq_addr_val;
    logic [63:0]        cq_addr_val;
    logic [63:0]        ims_poll_addr_val;
    bit [63:0]          tbcnt_offset_in;
    int                 num_hcw_gen;
    int                 num_loop_gen;
    int                 num_hcw_loop_gen;
    int                 stream_ctl;
    int                 hcw_time_gen;
    string              pp_cq_prefix;
    hcw_qtype           qtype;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;

    int                 is_rob_enabled;
    int                 cacheline_max_num_min;
    int                 cacheline_max_num_max;
    int                 cacheline_max_num;
    int                 cacheline_max_pad_min;
    int                 cacheline_max_pad_max;
    int                 cacheline_max_shuffle_min;
    int                 cacheline_max_shuffle_max;

    int                 cl_pad;

    int                 wu_min;
    int                 wu_max;
    int                 pad_prob_min;
    int                 pad_prob_max;
    int                 expad_prob_min;
    int                 expad_prob_max;
    bit                 msix_mode;
    bit                 ims_poll_mode;
    int                 cq_poll_int;
    int                 set_cq_poll_int;
    int                 hcw_delay_ctrl_mode_in;
    int                 hcw_delay_min_in;
    int                 hcw_delay_max_in;
    int                 illegal_hcw_prob;
    int                 illegal_hcw_burst_len;
    hqm_pp_cq_base_seq::illegal_hcw_gen_mode_t      illegal_hcw_gen_mode;
    hqm_pp_cq_base_seq::illegal_hcw_type_t          illegal_hcw_type;
    string              illegal_hcw_type_str;
    int                 ingress_err;
    int                 ldb_lockid_ctrl;
    int                 ldb_acomp_ctrl;
    int                 hcw_qpri_weight0, hcw_qpri_weight1, hcw_qpri_weight2, hcw_qpri_weight3, hcw_qpri_weight4, hcw_qpri_weight5, hcw_qpri_weight6, hcw_qpri_weight7;  
    int                 cq_intr_process_delayval;
    int                 cq_intr_process_control;   

    int                 comp_return_delay;
    int                 comp_return_delay_mode;
    int                 a_comp_return_delay;
    int                 a_comp_return_delay_mode;
    int                 tok_return_delay;
    int                 tok_return_delay_mode;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      uvm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    if (is_ldb) begin
      if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",pp_cq_index_in),pp_cq_num_in)) begin
        qid_sem.get(1);

        if (ldb_qid_avail.size() > 0) begin
          if ($test$plusargs("HQM_CFG_USE_SEQUENTIAL_NAMES")) begin
             qid_index = 0;
          end else begin
             qid_index = $urandom_range(ldb_qid_avail.size() - 1, 0);
          end 
          qid = ldb_qid_avail[qid_index];
          ldb_qid_avail.delete(qid_index);
          uvm_report_info(get_full_name(), $psprintf("start_pp_cq_generate__prep: pp_cq_index_in=%0d pp_cq_num_in=%0d get qid=%0d ldb_qid_avail.size=%0d",  pp_cq_index_in, pp_cq_num_in, qid, ldb_qid_avail.size()), UVM_LOW);
        end else if (ldb_qid_avail_2nd.size() > 0 ) begin
          if ($test$plusargs("HQM_CFG_USE_SEQUENTIAL_NAMES")) begin
             qid_index = 0;
          end else begin
             qid_index = $urandom_range(ldb_qid_avail_2nd.size() - 1, 0);
          end 
          qid = ldb_qid_avail_2nd[qid_index];
          ldb_qid_avail_2nd.delete(qid_index);
          uvm_report_info(get_full_name(), $psprintf("start_pp_cq_generate__prep: pp_cq_index_in=%0d pp_cq_num_in=%0d get qid=%0d ldb_qid_avail_2nd.size=%0d, num_ldb_pp=%0d",  pp_cq_index_in, pp_cq_num_in, qid, ldb_qid_avail_2nd.size(), dut_view.num_ldb_pp), UVM_LOW);
        end else begin
          `uvm_error(get_full_name(),$psprintf("No more ldb QIDs available"))
          qid_sem.put(1);
          return;
        end 

        qid_sem.put(1);

        if (qid >= hqm_pkg::NUM_LDB_QID) begin
          `uvm_error(get_full_name(),$psprintf("LDB PP %0d does not have a valid vqid associated with it",pp_cq_num_in))
          return;
        end 
      end else begin
        `uvm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
        return;
      end 
    end else begin
      if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",pp_cq_index_in),pp_cq_num_in)) begin
        qid_sem.get(1);

        if (dir_qid_avail.size() > 0) begin
          if ($test$plusargs("HQM_CFG_USE_SEQUENTIAL_NAMES")) begin
             qid_index = 0;
          end else begin
             qid_index = $urandom_range(dir_qid_avail.size() - 1, 0);
          end 
          qid = dir_qid_avail[qid_index];
          dir_qid_avail.delete(qid_index);
        end else begin
          `uvm_error(get_full_name(),$psprintf("No more dir QIDs available"))
          qid_sem.put(1);
          return;
        end 

        qid_sem.put(1);

        if (qid >= hqm_pkg::NUM_DIR_QID) begin
          `uvm_error(get_full_name(),$psprintf("DIR PP %0d does not have a valid vqid associated with it",pp_cq_num_in))
          return;
        end 
      end else begin
        `uvm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
        return;
      end 
    end 

    //----------------------------------
    //----------------------------------
    cq_addr_val = '0;

    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end 

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp_cq_num_in), {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp_cq_num_in), {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x from RAL %0s ", is_ldb, pp_cq_num_in, cq_addr_val, {cfg.tb_env_hier,".hqm_system_csr"}), UVM_LOW);

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in); 
        uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), UVM_LOW);
    end  

    //----------------------------------
    //----------------------------------
    if(has_cq_hpa_addr>0) trf_cq_addr_val = cq_hpa_addr; //--SoC support
    else                  trf_cq_addr_val = cq_addr_val; //--AY_HQMV30_ATS--   is physical addr
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: is_ldb=%0d pp_cq_num_in=%0d trf_cq_addr_val=0x%0x, cq_addr_val=0x%0x cq_hpa_addr=0x%0x with has_cq_hpa_addr=%0d; intr_remap_addr=0x%0x ", is_ldb, pp_cq_num_in, trf_cq_addr_val, cq_addr_val, cq_hpa_addr, has_cq_hpa_addr, intr_remap_addr), UVM_LOW);


    //----------------------------------
    //----------------------------------
    my_field    = ral.find_field_by_name("MODE", "MSIX_MODE", {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data    = my_field.get_actual();

    msix_mode   = ral_data[0];

    my_field    = ral.find_field_by_name("IMS_POLLING", "MSIX_MODE", {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data    = my_field.get_actual();

    ims_poll_mode = ral_data[0];

    ims_poll_addr_val = i_hqm_cfg.get_ims_poll_addr(pp_cq_num_in,is_ldb);

  
    cq_intr_process_delayval = 0;
    $value$plusargs({$psprintf("%s_PP%0d_CQINTR_DELAY_VAL",pp_cq_prefix,pp_cq_index_in),"=%d"}, cq_intr_process_delayval);

    cq_intr_process_control = 0;
    if($test$plusargs("HQM_CQ_INTR_PROCESS_CTRL")) cq_intr_process_control=1;
    $value$plusargs({$psprintf("%s_PP%0d_CQINTR_PROCESS",pp_cq_prefix,pp_cq_index_in),"=%d"}, cq_intr_process_control);

    stream_ctl = is_ldb ? cfg.ldb_stream_ctl : cfg.dir_stream_ctl;
    $value$plusargs({$psprintf("%s_PP%0d_STREAM_CTL",pp_cq_prefix,pp_cq_index_in),"=%d"}, stream_ctl);

    ldb_lockid_ctrl  = 0;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_LOCKID_CTRL",pp_cq_prefix,pp_cq_index_in),"=%d"}, ldb_lockid_ctrl);

    ldb_acomp_ctrl  = cfg.ldb_acomp_rtn_ctrl;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_ACOMP_CTRL",pp_cq_prefix,pp_cq_index_in),"=%d"}, ldb_acomp_ctrl);

    hcw_delay_ctrl_mode_in = 0;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MODE",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_delay_ctrl_mode_in);

    hcw_delay_min_in = is_ldb ? cfg.ldb_hcw_delay_min : cfg.dir_hcw_delay_min;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_delay_min_in);

    hcw_delay_max_in = is_ldb ? cfg.ldb_hcw_delay_max : cfg.dir_hcw_delay_max;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_delay_max_in);

    hcw_delay_min_in    = hcw_delay_min_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);
    hcw_delay_max_in    = hcw_delay_max_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_delay_ctrl_mode_in=%0d hcw_delay_type=%s hcw_delay_min_in=%0d hcw_delay_max_in=%0d ldb_lockid_ctrl=%0d ldb_acomp_ctrl=%0d stream_ctl=%0d", hcw_delay_ctrl_mode_in, cfg.hcw_delay_type.name(), hcw_delay_min_in, hcw_delay_max_in, ldb_lockid_ctrl, ldb_acomp_ctrl, stream_ctl), UVM_MEDIUM);

    batch_min = is_ldb ? cfg.ldb_batch_min : cfg.dir_batch_min;
    batch_max = is_ldb ? cfg.ldb_batch_max : cfg.dir_batch_max;

    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, batch_min);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, batch_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: batch_min=%0d batch_max=%0d", batch_min, batch_max), UVM_LOW);


    //--HQMV30 ROB: max cacheline num/pad/shuffle control
    cacheline_max_num_min = is_ldb ? cfg.ldb_cacheline_max_num_min : cfg.dir_cacheline_max_num_min;
    cacheline_max_num_max = is_ldb ? cfg.ldb_cacheline_max_num_max : cfg.dir_cacheline_max_num_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLNUM_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_num_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLNUM_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_num_max);
    cacheline_max_num = $urandom_range(cacheline_max_num_min,cacheline_max_num_max); 
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cacheline_max_num_min=%0d cacheline_max_num_max=%0d => cacheline_max_num=%0d", cacheline_max_num_min, cacheline_max_num_max, cacheline_max_num), UVM_LOW);

    cacheline_max_pad_min = is_ldb ? cfg.ldb_cacheline_max_pad_min : cfg.dir_cacheline_max_pad_min;
    cacheline_max_pad_max = is_ldb ? cfg.ldb_cacheline_max_pad_max : cfg.dir_cacheline_max_pad_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_pad_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_pad_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cacheline_max_pad_min=%0d cacheline_max_pad_max=%0d", cacheline_max_pad_min, cacheline_max_pad_max), UVM_LOW);

    cacheline_max_shuffle_min = is_ldb ? cfg.ldb_cacheline_max_shuffle_min : cfg.dir_cacheline_max_shuffle_min;
    cacheline_max_shuffle_max = is_ldb ? cfg.ldb_cacheline_max_shuffle_max : cfg.dir_cacheline_max_shuffle_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_shuffle_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_shuffle_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", cacheline_max_shuffle_min, cacheline_max_shuffle_max), UVM_LOW);

    cl_pad = is_ldb ? cfg.ldb_cl_pad : cfg.dir_cl_pad;
    $value$plusargs({$psprintf("%s_PP%0d_CL_PAD",pp_cq_prefix,pp_cq_index_in),"=%d"}, cl_pad);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cl_pad=%0d ", cl_pad), UVM_LOW);

    //-- call i_hqm_cfg.get_cl_rob to check if HQMV30 RTL has been programmed to set ROB=1 
    is_rob_enabled = i_hqm_cfg.get_cl_rob(is_ldb, pp_cq_num_in);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: is_rob_enabled=%0d ", is_rob_enabled), UVM_LOW);

    //-- if ROB is not set to 1 in this PP, reset cacheline_max_num=1, cl_pad=0
    if(is_rob_enabled==0 && !$test$plusargs("HQM_PP_FORCE_CL_SHUFFLED")) begin
        cacheline_max_num = 1;
        cacheline_max_pad_min = 0;
        cacheline_max_pad_max = 0;
        cacheline_max_shuffle_min = 0;
        cacheline_max_shuffle_max = 0;
        cl_pad = 0;
        uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: is_rob_enabled=%0d reset cacheline_max_num=%0d cl_pad=%0d cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", is_rob_enabled, cacheline_max_num, cl_pad, cacheline_max_shuffle_min, cacheline_max_shuffle_max), UVM_LOW);
    end 

    //--
    pad_prob_min = is_ldb ? cfg.ldb_pad_prob_min : cfg.dir_pad_prob_min;
    pad_prob_max = is_ldb ? cfg.ldb_pad_prob_max : cfg.dir_pad_prob_max;
    $value$plusargs({$psprintf("%s_PP%0d_PAD_PROB_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, pad_prob_min);
    $value$plusargs({$psprintf("%s_PP%0d_PAD_PROB_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, pad_prob_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: pad_prob_min=%0d pad_prob_max=%0d", pad_prob_min, pad_prob_max), UVM_LOW);

    expad_prob_min = is_ldb ? cfg.ldb_expad_prob_min : cfg.dir_expad_prob_min;
    expad_prob_max = is_ldb ? cfg.ldb_expad_prob_max : cfg.dir_expad_prob_max;
    $value$plusargs({$psprintf("%s_PP%0d_EXPAD_PROB_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, expad_prob_min);
    $value$plusargs({$psprintf("%s_PP%0d_EXPAD_PROB_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, expad_prob_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: expad_prob_min=%0d expad_prob_max=%0d", expad_prob_min, expad_prob_max), UVM_LOW);

    hcw_qpri_weight0=1;
    hcw_qpri_weight1=1;
    hcw_qpri_weight2=1;
    hcw_qpri_weight3=1;
    hcw_qpri_weight4=1;
    hcw_qpri_weight5=1;
    hcw_qpri_weight6=1;
    hcw_qpri_weight7=1;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W0",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight0 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W1",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight1 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W2",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight2 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W3",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight3 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W4",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight4 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W5",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight5 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W6",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight6 );
    $value$plusargs({$psprintf("%s_PP%0d_HCW_QPRI_W7",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_qpri_weight7 );
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight0=%0d ", hcw_qpri_weight0), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight1=%0d ", hcw_qpri_weight1), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight2=%0d ", hcw_qpri_weight2), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight3=%0d ", hcw_qpri_weight3), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight4=%0d ", hcw_qpri_weight4), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight5=%0d ", hcw_qpri_weight5), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight6=%0d ", hcw_qpri_weight6), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: hcw_qpri_weight7=%0d ", hcw_qpri_weight7), UVM_LOW);

    wu_min = is_ldb ? cfg.ldb_wu_min : 0;
    wu_max = is_ldb ? cfg.ldb_wu_max : 0;

    $value$plusargs({$psprintf("%s_PP%0d_WU_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, wu_min);
    $value$plusargs({$psprintf("%s_PP%0d_WU_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, wu_max);

    if (!$value$plusargs({$psprintf("%s_PP%0d_INGRESS_ERR",pp_cq_prefix,pp_cq_index_in),"=%d"}, ingress_err)) ingress_err = 0;

    if (!$value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_PROB",pp_cq_prefix,pp_cq_index_in),"=%d"}, illegal_hcw_prob)) illegal_hcw_prob = 0;

    if (!$value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_BURST_LEN",pp_cq_prefix,pp_cq_index_in),"=%d"}, illegal_hcw_burst_len)) illegal_hcw_burst_len = 0;

    $value$plusargs({$psprintf("%s_PP%0d_ILLEGAL_HCW_TYPE",pp_cq_prefix,pp_cq_index_in),"=%s"}, illegal_hcw_type_str);
    illegal_hcw_type_str = illegal_hcw_type_str.tolower();

    case (illegal_hcw_type_str)
      "illegal_hcw_cmd":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_HCW_CMD;
      "all_0":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_0;
      "all_1":                  illegal_hcw_type = hqm_pp_cq_base_seq::ALL_1;
      "illegal_pp_num":         illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_NUM;
      "illegal_pp_type":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_PP_TYPE;
      "illegal_qid_num":        illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_NUM;
      "illegal_qid_type":       illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_QID_TYPE;
      "illegal_dev_vf_num":     illegal_hcw_type = hqm_pp_cq_base_seq::ILLEGAL_DEV_VF_NUM;
      "qid_grt_127":            illegal_hcw_type = hqm_pp_cq_base_seq::QID_GRT_127;
      "vas_write_permission":   illegal_hcw_type = hqm_pp_cq_base_seq::VAS_WRITE_PERMISSION;
    endcase

    set_cq_poll_int=1;
    $value$plusargs("HQM_TRF_CQ_POLL=%d",set_cq_poll_int);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: set_cq_poll_int=%0d ", set_cq_poll_int), UVM_LOW);
 
    cq_poll_int = (dut_view.enable_msix || dut_view.enable_ims_poll || dut_view.enable_wdog_cq) ? 0 : set_cq_poll_int;
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cq_poll_int=%0d ", cq_poll_int), UVM_LOW);

    if ($value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_index_in),"=%d"}, cq_poll_int) == 0) begin
      $value$plusargs({$psprintf("%s_CQ_POLL",pp_cq_prefix),"=%d"}, cq_poll_int);
      uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cq_poll_int=%0d (CQ_POLL)", cq_poll_int), UVM_LOW);
    end 


    tbcnt_offset_in = 0;
    if ($value$plusargs({$psprintf("%s_PP%0d_TBCNT_OFFSET",pp_cq_prefix,pp_cq_index_in),"=%h"}, tbcnt_offset_in) == 0) begin
      $value$plusargs({$psprintf("%s_TBCNT_OFFSET",pp_cq_prefix),"=%h"}, tbcnt_offset_in);
    end 
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: %s_PP%0d_TBCNT_OFFSET=0x%0x", pp_cq_prefix,pp_cq_index_in, tbcnt_offset_in), UVM_LOW);


    `uvm_create(pp_cq_seq)
    pp_cq_seq.inst_suffix = cfg.inst_suffix;
    pp_cq_seq.tb_env_hier = cfg.tb_env_hier;
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_index_in)); // [UVM MIGRATION][FIXME]  UVM does not allow renaming component.
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num                  == pp_cq_num_in;      // Producer Port/Consumer Queue number
                     pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                     queue_list.size()          == queue_list_size;

                     hcw_enqueue_batch_min      == batch_min;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max      == batch_max;  // Maximum number of HCWs to send as a batch (1-4)

                     pp_max_cacheline_num_min   == cacheline_max_num;
                     pp_max_cacheline_num_max   == cacheline_max_num;
                     pp_max_cacheline_pad_min   == cacheline_max_pad_min;
                     pp_max_cacheline_pad_max   == cacheline_max_pad_max;
                     pp_max_cacheline_shuffle_min   == cacheline_max_shuffle_min;
                     pp_max_cacheline_shuffle_max   == cacheline_max_shuffle_max;
  
                     hcw_enqueue_cl_pad         == cl_pad;

                     hcw_enqueue_wu_min         == wu_min;  // Minimum WU value for HCWs
                     hcw_enqueue_wu_max         == wu_max;  // Maximum WU value for HCWs

                     hcw_enqueue_pad_prob_min   == pad_prob_min;  // noop padding control
                     hcw_enqueue_pad_prob_max   == pad_prob_max;  // noop padding control 

                     hcw_enqueue_expad_prob_min == expad_prob_min;  // extra noop padding control
                     hcw_enqueue_expad_prob_max == expad_prob_max;  // extra noop padding control 

                     hcw_lockid_ctrl            == ldb_lockid_ctrl;
                     hcw_acomp_ctrl             == ldb_acomp_ctrl;

                     hcw_delay_ctrl_mode        == hcw_delay_ctrl_mode_in;

                     queue_list_delay_min       == hcw_delay_min_in;
                     queue_list_delay_max       == hcw_delay_max_in;

                     cq_addr                    == trf_cq_addr_val;
                     intr_remap_addr            == intr_remap_addr;
                     ims_poll_addr              == ims_poll_addr_val;

                     cq_poll_interval           == cq_poll_int;

                     hqm_stream_ctl             == stream_ctl;

                     cq_intr_process_delay      == cq_intr_process_delayval;  
                     cq_intr_process_ctrl       == cq_intr_process_control;  

                   } ) begin
      `uvm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end 

    vf_num_val = -1;

    if ($value$plusargs({$psprintf("%s_PP%0d_VF",pp_cq_prefix,pp_cq_index_in),"=%d"}, vf_num_val) == 0) begin
      $value$plusargs({$psprintf("%s_VF",pp_cq_prefix),"=%d"}, vf_num_val);
    end 

    if (vf_num_val >= 0) begin
      pp_cq_seq.is_vf   = 1;
      pp_cq_seq.vf_num  = vf_num_val;
    end 

    if( $value$plusargs({$psprintf("%s_PP%0d_QID",pp_cq_prefix,pp_cq_index_in),"=%d"}, qid) == 0) begin
      $value$plusargs({$psprintf("%s_QID",pp_cq_prefix),"=%d"}, qid);
    end 

    qtype_str = is_ldb ? cfg.ldb_qtype.name() : cfg.dir_qtype.name();
    $value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_index_in),"=%s"}, qtype_str);
    qtype_str = qtype_str.tolower();

    lock_id = 16'h4000 + pp_cq_index_in;
    if( $value$plusargs({$psprintf("%s_PP%0d_LOCKID",pp_cq_prefix,pp_cq_index_in),"=%d"}, lock_id) == 0) begin
      $value$plusargs({$psprintf("%s_LOCKID",pp_cq_prefix),"=%d"}, lock_id);
    end 

    dsi = 16'h0100;
    if( $value$plusargs({$psprintf("%s_PP%0d_DSI",pp_cq_prefix,pp_cq_index_in),"=%d"}, dsi) == 0) begin
      $value$plusargs({$psprintf("%s_DSI",pp_cq_prefix),"=%d"}, dsi);
    end 

    case (qtype_str)
      "qdir": qtype = QDIR;
      "quno": qtype = QUNO;
      "qatm": qtype = QATM;
      "qord": qtype = QORD;
    endcase

    //--return delay controls
    //--a_comp
    if($value$plusargs({$psprintf("%s_PP%0d_A_COMP_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, a_comp_return_delay_mode)) begin
         pp_cq_seq.a_comp_return_delay_mode = a_comp_return_delay_mode;
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, a_comp_return_delay_mode), UVM_LOW);
    end else if(cfg.a_comp_return_delay_mode >=0) begin
         pp_cq_seq.a_comp_return_delay_mode = cfg.a_comp_return_delay_mode;
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, cfg.a_comp_return_delay_mode), UVM_LOW);
    end 

    if($value$plusargs({$psprintf("%s_PP%0d_A_COMP_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, a_comp_return_delay)) begin
         pp_cq_seq.a_comp_return_delay_q.push_back(a_comp_return_delay);
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, a_comp_return_delay), UVM_LOW);
    end else if(cfg.a_comp_return_delay > 0) begin
         pp_cq_seq.a_comp_return_delay_q.push_back($urandom_range(0,cfg.a_comp_return_delay));
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_A_COMP_RETURN_DELAY=%0d (rnd)", pp_cq_prefix, pp_cq_seq.pp_cq_num, cfg.a_comp_return_delay), UVM_LOW);
    end 

    //--comp
    if($value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay_mode)) begin
         pp_cq_seq.comp_return_delay_mode = comp_return_delay_mode;
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, comp_return_delay_mode), UVM_LOW);
    end else if(cfg.comp_return_delay_mode >=0 ) begin
         pp_cq_seq.comp_return_delay_mode = cfg.comp_return_delay_mode;
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, cfg.comp_return_delay_mode), UVM_LOW);
    end 

    if($value$plusargs({$psprintf("%s_PP%0d_COMP_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, comp_return_delay)) begin
         pp_cq_seq.comp_return_delay_q.push_back(comp_return_delay);
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, comp_return_delay), UVM_LOW);
    end else if(cfg.comp_return_delay > 0 ) begin
         pp_cq_seq.comp_return_delay_q.push_back($urandom_range(0,cfg.comp_return_delay));
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_COMP_RETURN_DELAY=%0d (rnd)", pp_cq_prefix, pp_cq_seq.pp_cq_num, cfg.comp_return_delay), UVM_LOW);
    end 

    //--tok
    if($value$plusargs({$psprintf("%s_PP%0d_TOK_RETURN_DELAY_MODE", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, tok_return_delay_mode)) begin
         pp_cq_seq.tok_return_delay_mode = tok_return_delay_mode;
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOK_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, tok_return_delay_mode), UVM_LOW);
    end else if(cfg.tok_return_delay_mode >= 0) begin
         pp_cq_seq.tok_return_delay_mode = cfg.tok_return_delay_mode;
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOk_RETURN_DELAY_MODE=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, cfg.tok_return_delay_mode), UVM_LOW);
    end 

    if($value$plusargs({$psprintf("%s_PP%0d_TOK_RETURN_DELAY", pp_cq_prefix, pp_cq_seq.pp_cq_num), "=%d"}, tok_return_delay)) begin
         pp_cq_seq.tok_return_delay_q.push_back(tok_return_delay);
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOK_RETURN_DELAY=%0d", pp_cq_prefix, pp_cq_seq.pp_cq_num, tok_return_delay), UVM_LOW);
    end else if(cfg.tok_return_delay > 0) begin
         pp_cq_seq.tok_return_delay_q.push_back($urandom_range(0,cfg.tok_return_delay));
         uvm_report_info(get_full_name(), $psprintf("%s_PP%0d_TOK_RETURN_DELAY=%0d  (rnd)", pp_cq_prefix, pp_cq_seq.pp_cq_num, cfg.tok_return_delay), UVM_LOW);
    end 


    //---------------
    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = is_ldb ? cfg.ldb_num_hcw : cfg.dir_num_hcw;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_index_in,i),"=%d"}, num_hcw_gen);

      num_loop_gen = is_ldb ? cfg.ldb_num_loop : cfg.dir_num_loop;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_LOOP",pp_cq_prefix,pp_cq_index_in,i),"=%d"}, num_loop_gen);

      num_hcw_loop_gen = is_ldb ? cfg.ldb_num_hcw_loop : cfg.dir_num_hcw_loop;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_LOOP_HCW",pp_cq_prefix,pp_cq_index_in,i),"=%d"}, num_hcw_loop_gen);

      if(num_hcw_loop_gen>0) begin
          //--  
      end else begin
          num_hcw_loop_gen = num_hcw_gen * num_loop_gen;
      end 

      hcw_time_gen = is_ldb ? cfg.ldb_hcw_time : cfg.dir_hcw_time;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_HCW_TIME",pp_cq_prefix,pp_cq_index_in,i),"=%d"}, hcw_time_gen);

      if ((hcw_time_gen > 0) && (num_hcw_gen == 0)) begin
        num_hcw_gen = 1;
      end 

      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;
      pp_cq_seq.queue_list[i].num_loop                  = num_loop_gen;
      pp_cq_seq.queue_list[i].num_hcw_loop              = num_hcw_loop_gen;
      pp_cq_seq.queue_list[i].hcw_time                  = hcw_time_gen;
      pp_cq_seq.queue_list[i].qid                       = qid + i;
      pp_cq_seq.queue_list[i].qtype                     = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
      pp_cq_seq.queue_list[i].hcw_delay_type            = cfg.hcw_delay_type;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_min_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].tbcnt_offset              = tbcnt_offset_in;

      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].a_comp_flow               = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
 
      if ($test$plusargs("RANDOM_PRI")) begin
          uvm_report_info(get_full_name(), $psprintf("Random priority is selected"), UVM_LOW);
          pp_cq_seq.queue_list[i].qpri_weight[0] = 1;
          pp_cq_seq.queue_list[i].qpri_weight[1] = 1;
          pp_cq_seq.queue_list[i].qpri_weight[2] = 1;
          pp_cq_seq.queue_list[i].qpri_weight[3] = 1;
          pp_cq_seq.queue_list[i].qpri_weight[4] = 1;
          pp_cq_seq.queue_list[i].qpri_weight[5] = 1;
          pp_cq_seq.queue_list[i].qpri_weight[6] = 1;
          pp_cq_seq.queue_list[i].qpri_weight[7] = 1;
      end else if ($test$plusargs("DIST_PRI_0")) begin
          uvm_report_info(get_full_name(), $psprintf("DIST_PRI_0 priority is selected"), UVM_LOW);
          pp_cq_seq.queue_list[i].qpri_weight[0] = hcw_qpri_weight0;
          pp_cq_seq.queue_list[i].qpri_weight[1] = hcw_qpri_weight1;
          pp_cq_seq.queue_list[i].qpri_weight[2] = hcw_qpri_weight2;
          pp_cq_seq.queue_list[i].qpri_weight[3] = hcw_qpri_weight3;
          pp_cq_seq.queue_list[i].qpri_weight[4] = hcw_qpri_weight4;
          pp_cq_seq.queue_list[i].qpri_weight[5] = hcw_qpri_weight5;
          pp_cq_seq.queue_list[i].qpri_weight[6] = hcw_qpri_weight6;
          pp_cq_seq.queue_list[i].qpri_weight[7] = hcw_qpri_weight7;
      end 

      if(ingress_err)begin
        pp_cq_seq.queue_list[i].illegal_hcw_burst_len     = (i == 0) ? illegal_hcw_burst_len : 0;
        pp_cq_seq.queue_list[i].illegal_hcw_prob          = (i == 0) ? illegal_hcw_prob : 0;
        if (pp_cq_seq.queue_list[i].illegal_hcw_prob > 0) begin
          pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::RAND_ILLEGAL;
        end else if (pp_cq_seq.queue_list[i].illegal_hcw_burst_len > 0) begin
          pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::BURST_ILLEGAL;
        end else begin
          pp_cq_seq.queue_list[i].illegal_hcw_gen_mode = hqm_pp_cq_base_seq::NO_ILLEGAL;
        end 
        pp_cq_seq.queue_list[i].illegal_hcw_type_q.push_back(illegal_hcw_type);
      end 

      //-- condition is pp[idx] => cq[idx]
      if(qtype != QDIR) 
          i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in] = (stream_ctl==0)? num_hcw_gen : (num_hcw_gen+num_hcw_loop_gen); //num_hcw_gen;
      else 
          i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in] = (stream_ctl==0)? num_hcw_gen : (num_hcw_gen+num_hcw_loop_gen); //num_hcw_gen;

      uvm_report_info(get_type_name(),$psprintf("start_pp_cq_generate__[%0d]: pp_cq_index_in=%0d/pp_cq_num_in=%0d/qtype=%0s/qid=%0d/lockid=0x%0x/delay=[%0d:%0d]/num_hcw_gen=%0d/num_hcw_loop_gen=%0d/num_loop stream_ctl=%0d/hcw_time_gen=%0d, hcw_ldb_cq_hcw_num[%0d]=%0d/hcw_dir_cq_hcw_num[%0d]=%0d; cq_poll_int=%0d", i, pp_cq_index_in, pp_cq_num_in, qtype.name(), pp_cq_seq.queue_list[i].qid, lock_id, hcw_delay_min_in, hcw_delay_max_in, num_hcw_gen, num_hcw_loop_gen, num_loop_gen, stream_ctl, hcw_time_gen, pp_cq_num_in, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in], pp_cq_num_in, i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in], cq_poll_int ),  UVM_LOW);
    end 

    finish_item(pp_cq_seq);
  endtask

endclass
