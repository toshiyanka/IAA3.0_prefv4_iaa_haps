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
// File   : hcw_sciov_test_hcw2_seq.sv
//
// Description :
//
//   Sequence that supports HCW traffic for hcw_sciov_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hcw_sciov_test_hcw2_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_sciov_test_hcw2_seq_stim_config";

  `uvm_object_utils_begin(hcw_sciov_test_hcw2_seq_stim_config)
    `uvm_field_string(tb_env_hier,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(inst_suffix,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_num_hcw,                         UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
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
    `uvm_field_enum(hcw_qtype,          dir_qtype,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_num_hcw,                         UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
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
    `uvm_field_int(ldb_acomp_rtn_ctrl,                  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
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
    `uvm_field_queue_int(dir_ims_poll_hpa_addr_q,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_ims_poll_hpa_addr_q,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_cq_intr_remap_addr_q,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_cq_intr_remap_addr_q,      UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_sciov_test_hcw2_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(dir_num_hcw)
    `stimulus_config_field_rand_int(dir_hcw_time)
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
    `stimulus_config_field_rand_enum(hcw_qtype,dir_qtype)
    `stimulus_config_field_rand_int(ldb_num_hcw)
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
    `stimulus_config_field_rand_int(ldb_acomp_rtn_ctrl)
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
    `stimulus_config_field_queue_int(dir_ims_poll_hpa_addr_q)
    `stimulus_config_field_queue_int(ldb_ims_poll_hpa_addr_q)
    `stimulus_config_field_queue_int(dir_cq_intr_remap_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_intr_remap_addr_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  int                     dir_num_hcw;
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
  rand  hcw_qtype               dir_qtype;

  rand  int                     ldb_num_hcw;
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
  rand  hcw_qtype               ldb_qtype;
  rand  int                     ldb_acomp_rtn_ctrl;

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

  bit [63:0]                    dir_ims_poll_hpa_addr_q[$];
  bit [63:0]                    ldb_ims_poll_hpa_addr_q[$];

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

  constraint c_ldb_batch {
    ldb_batch_min >= 1;
    ldb_batch_min <= 4;

    ldb_batch_max >= 1;
    ldb_batch_max <= 4;

    ldb_batch_min <= ldb_batch_max;
  }

  constraint c_dir_max_cacheline_ctrl {
    dir_cacheline_max_num_min == 1;
    dir_cacheline_max_num_max == 1;
    dir_cacheline_max_pad_min == 0;
    dir_cacheline_max_pad_max == 0;
    dir_cacheline_max_shuffle_min == 0;
    dir_cacheline_max_shuffle_max == 0;
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

  constraint c_qtype_soft {
    soft dir_qtype      == QDIR;
    soft ldb_qtype      == QUNO;
  }

  constraint c_ldb_acomp_ctrl_soft {
    soft ldb_acomp_rtn_ctrl == 0;
  }

  function new(string name = "hcw_sciov_test_hcw2_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_sciov_test_hcw2_seq_stim_config

import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_sciov_test_hcw2_seq extends slu_sequence_base;

  `uvm_object_utils(hcw_sciov_test_hcw2_seq) 

  `uvm_declare_p_sequencer(slu_sequencer)
  
  rand hcw_sciov_test_hcw2_seq_stim_config       cfg;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_sciov_test_hcw2_seq_stim_config);
`endif
  
  hcw_sciov_test_stim_dut_view  dut_view;

  hqm_cfg                       i_hqm_cfg;

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

  hqm_pp_cq_base_seq            dir_pp_cq_seq[64];

  hqm_pp_cq_base_seq            ldb_pp_cq_seq[64];

  int                           dir_qid_used[*];
  int                           ldb_qid_used[*];
  int                           ldb_qid_used_2nd[*];

  //--cq_addr reprogramming
  int                           cq_addr_ctrl;

  semaphore                     qid_sem;

  function new(string name = "hcw_sciov_test_hcw2_seq");
    super.new(name);

    qid_sem = new(1);

    cfg = hcw_sciov_test_hcw2_seq_stim_config::type_id::create("hcw_sciov_test_hcw2_seq_stim_config");
`ifdef IP_OVM_STIM
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  endfunction

  virtual task body();
    uvm_object  o_tmp;

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    dut_view = hcw_sciov_test_stim_dut_view::instance(m_sequencer,cfg.inst_suffix);

    dir_qid_used.delete();
    ldb_qid_used.delete();
    ldb_qid_used_2nd.delete();

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",cfg.inst_suffix}, o_tmp)) begin
       uvm_report_info(get_full_name(), "hcw_sciov_test_hcw2_seq: Unable to find i_hqm_cfg object", UVM_LOW);
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
       uvm_report_info(get_full_name(), "hcw_sciov_test_hcw2_seq: Unable to find i_hcw_scoreboard object", UVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         uvm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end 
    end 

    //-----------------------------
    //-----------------------------
    cq_addr_ctrl = cfg.ctl_cq_base_addr;

    //--test purpose
    if($test$plusargs("HQM_CQ_ADDR_REPROG")) begin
       cq_addr_ctrl = 1;
       if($test$plusargs("HQM_CQ_ADDR_SET")) begin
          foreach(i_hqm_cfg.ldb_pp_cq_cfg[pp]) begin
               cfg.ldb_cq_addr_q[pp] = 64'h0000000f_edcb0000 + pp * cfg.ldb_cq_space; 
          end 
          foreach(i_hqm_cfg.dir_pp_cq_cfg[pp]) begin
               cfg.dir_cq_addr_q[pp] = 64'h00000008_76540000 + pp * cfg.ldb_cq_space; 
          end 
       end 
    end 
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Starting SCIOV Traffic with num_dir_pp=%0d num_ldb_pp=%0d num_vdev=%0d enable_ims=%0d enable_ims_poll=%0d enable_msix=%0d; cq_addr_ctrl=%0d", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.num_vdev, dut_view.enable_ims, dut_view.enable_ims_poll, dut_view.enable_msix, cq_addr_ctrl), UVM_LOW);

    //-----------------------------
    //-----------------------------
    if(cq_addr_ctrl==1) hqm_cq_addr_reprogram();


    //-----------------------------
    //-- tasks 
    //-----------------------------
    for (int i = 0 ; i < dut_view.num_dir_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.dir_cq_hpa_addr_q.size()>pp) begin
            uvm_report_info("hcw_sciov_test_hcw2_seq", $psprintf("hcw_sciov_test_hcw2_seq: Call start_pp_cq DIRPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.dir_cq_hpa_addr_q[pp]), UVM_NONE);

            if(cfg.dir_ims_poll_hpa_addr_q.size()>pp) begin
                 uvm_report_info("hcw_sciov_test_hcw2_seq", $psprintf("hcw_sciov_test_hcw2_seq: Call start_pp_cq DIRPP[%0d].cq_hpa_addr=0x%0x ims_poll_hpa_addr=0x%0x", pp, cfg.dir_cq_hpa_addr_q[pp], cfg.dir_ims_poll_hpa_addr_q[pp]), UVM_NONE);
                 start_pp_cq(.is_ldb(0), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.dir_cq_hpa_addr_q[pp]), .has_ims_poll_hpa_addr(1), .ims_poll_hpa_addr(cfg.dir_ims_poll_hpa_addr_q[pp]), .intr_remap_addr(cfg.dir_cq_intr_remap_addr_q[pp]), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
            end else begin
                 start_pp_cq(.is_ldb(0), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.dir_cq_hpa_addr_q[pp]), .has_ims_poll_hpa_addr(0), .ims_poll_hpa_addr(0), .intr_remap_addr(0), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
            end 

          end else begin
            start_pp_cq(.is_ldb(0), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .has_ims_poll_hpa_addr(0), .ims_poll_hpa_addr(0), .intr_remap_addr(0), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
          end 
        end 
      join_none
    end 

    for (int i = 0 ; i < dut_view.num_ldb_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.ldb_cq_hpa_addr_q.size()>pp) begin
            uvm_report_info("hcw_sciov_test_hcw2_seq", $psprintf("hcw_sciov_test_hcw2_seq: Call start_pp_cq LDBPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.ldb_cq_hpa_addr_q[pp]), UVM_NONE);

            if(cfg.ldb_ims_poll_hpa_addr_q.size()>pp) begin
                 uvm_report_info("hcw_sciov_test_hcw2_seq", $psprintf("hcw_sciov_test_hcw2_seq: Call start_pp_cq LDBPP[%0d].cq_hpa_addr=0x%0x ims_poll_hpa_addr=0x%0x", pp, cfg.ldb_cq_hpa_addr_q[pp], cfg.ldb_ims_poll_hpa_addr_q[pp]), UVM_NONE);
                 start_pp_cq(.is_ldb(1), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.ldb_cq_hpa_addr_q[pp]), .has_ims_poll_hpa_addr(1), .ims_poll_hpa_addr(cfg.ldb_ims_poll_hpa_addr_q[pp]), .intr_remap_addr(cfg.ldb_cq_intr_remap_addr_q[pp]), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
            end else begin
                 start_pp_cq(.is_ldb(1), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.ldb_cq_hpa_addr_q[pp]), .has_ims_poll_hpa_addr(0), .ims_poll_hpa_addr(0), .intr_remap_addr(0), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
            end 

          end else begin
            start_pp_cq(.is_ldb(1), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .has_ims_poll_hpa_addr(0), .ims_poll_hpa_addr(0), .intr_remap_addr(0), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
          end 
        end 
      join_none
    end 

    wait fork;

    super.body();

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

     uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming DIRCQ address with the setting of cfg.dir_cq_addr_q.size=%0d cfg.dir_cq_hpa_addr_q.size=%0d cfg.dir_cq_base_addr=0x%0x cfg.dir_cq_hpa_base_addr=0x%0x cfg.dir_cq_space=0x%0x; ral_access_path=%0s", cfg.dir_cq_addr_q.size(), cfg.dir_cq_hpa_addr_q.size(), cfg.dir_cq_base_addr, cfg.dir_cq_hpa_base_addr, cfg.dir_cq_space, ral_access_path), UVM_NONE);
     uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming LDBCQ address with the setting of cfg.ldb_cq_addr_q.size=%0d cfg.ldb_cq_hpa_addr_q.size=%0d cfg.ldb_cq_base_addr=0x%0x cfg.ldb_cq_hpa_base_addr=0x%0x cfg.ldb_cq_space=0x%0x; ral_access_path=%0s", cfg.ldb_cq_addr_q.size(), cfg.ldb_cq_hpa_addr_q.size(), cfg.ldb_cq_base_addr, cfg.ldb_cq_hpa_base_addr, cfg.ldb_cq_space, ral_access_path), UVM_NONE);

     if ($value$plusargs("HQM_RAL_ACCESS_PATH=%s", ral_access_path)) begin
      `uvm_info(get_full_name(),$psprintf("hcw_sciov_test_hcw2_seq: Reprogramming access_path is overrided by +HQM_RAL_ACCESS_PATH=%s", ral_access_path), UVM_LOW)
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
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with cfg.ldb_cq_addr_q[%0d]=0x%0x",     pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa, pp, cfg.ldb_cq_addr_q[pp]), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with cfg.ldb_cq_hpa_addr_q[%0d]=0x%0x", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_hpa, pp, cfg.ldb_cq_hpa_addr_q[pp]), UVM_LOW);
              end else begin
                 decode_cq_gpa_addr = cfg.ldb_cq_base_addr     + pp_idx * cfg.ldb_cq_space;
                 decode_cq_hpa_addr = cfg.ldb_cq_hpa_base_addr + pp_idx * cfg.ldb_cq_space;
                 i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;
                 i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_hpa = decode_cq_hpa_addr;              
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with ldb_cq_base_addr=0x%0x     + pp*ldb_cq_space=0x%0x", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa, cfg.ldb_cq_base_addr, pp*cfg.ldb_cq_space), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with ldb_cq_hpa_base_addr=0x%0x + pp*ldb_cq_space=0x%0x", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_hpa, cfg.ldb_cq_hpa_base_addr, pp*cfg.ldb_cq_space), UVM_LOW);
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
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with cfg.dir_cq_addr_q[%0d]=0x%0x",     pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa, pp, cfg.dir_cq_addr_q[pp]), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with cfg.dir_cq_hpa_addr_q[%0d]=0x%0x", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_hpa, pp, cfg.dir_cq_hpa_addr_q[pp]), UVM_LOW);
              end else begin
                 decode_cq_gpa_addr = cfg.dir_cq_base_addr     + pp_idx * cfg.dir_cq_space;
                 decode_cq_hpa_addr = cfg.dir_cq_hpa_base_addr + pp_idx * cfg.dir_cq_space;
                 i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;
                 i_hqm_cfg.dir_pp_cq_cfg[pp].cq_hpa = decode_cq_hpa_addr;              
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_gpa=0x%0x with dir_cq_base_addr=0x%0x     + pp*dir_cq_space=0x%0x", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa, cfg.dir_cq_base_addr, pp*cfg.dir_cq_space), UVM_LOW);
                 uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d cq_hpa=0x%0x with dir_cq_hpa_base_addr=0x%0x + pp*dir_cq_space=0x%0x", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_hpa, cfg.dir_cq_hpa_base_addr, pp*cfg.dir_cq_space), UVM_LOW);
              end 

              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, this);
              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, this);
              pp_idx++; 
          end 
       end 

       uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq: Reprogramming CQ address done"), UVM_NONE);
  endtask

  //---------------------------------------------
  //--  start_pp_cq 
  //---------------------------------------------
  virtual task start_pp_cq(bit is_ldb, int pp_cq_index_in, int has_cq_hpa_addr, bit[63:0] cq_hpa_addr, int has_ims_poll_hpa_addr, bit[63:0] ims_poll_hpa_addr, bit[63:0] intr_remap_addr, int queue_list_size, output hqm_pp_cq_base_seq pp_cq_seq);
    int                 pp_cq_num_in;
    int                 qid;
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_field       my_field;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    logic [63:0]        trf_cq_addr_val;
    logic [63:0]        ims_poll_addr_val;
    bit [63:0]          tbcnt_offset_in;
    logic [63:0]        trf_ims_poll_addr_val;
    int                 num_hcw_gen;
    int                 hcw_time_gen;
    string              pp_cq_prefix;
    hcw_qtype           qtype;
    string              qtype_str;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;
    bit                 msix_mode;
    int                 cq_poll_int;
    int                 hcw_delay_min_in;
    int                 hcw_delay_max_in;
    int                 vdev_val;
    bit [31:0]          cq_ims_ctrl;
    bit [7:0]           ims_idx_val; 

    int                 is_rob_enabled;
    int                 cacheline_max_num_min;
    int                 cacheline_max_num_max;
    int                 cacheline_max_num;
    int                 cacheline_max_pad_min;
    int                 cacheline_max_pad_max;
    int                 cacheline_max_shuffle_min;
    int                 cacheline_max_shuffle_max;

    int                 cl_pad;
    int                 ldb_acomp_ctrl;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      uvm_report_fatal("CFG", "Unable to get RAL handle");
    end    
    //uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq:start_pp_cq: is_ldb=%0d pp_cq_index_in=%0d cq_hpa_addr=0x%0x intr_remap_addr=0x%0x", is_ldb, pp_cq_index_in, cq_hpa_addr, intr_remap_addr));

    //-------------------------------
    if (is_ldb) begin
      pp_cq_prefix = "LDB";
    end else begin
      pp_cq_prefix = "DIR";
    end 

    //-------------------------------
    //--get qtype here
    qtype_str = is_ldb ? cfg.ldb_qtype.name() : cfg.dir_qtype.name();
    $value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_index_in),"=%s"}, qtype_str);
    qtype_str = qtype_str.tolower();

    case (qtype_str)
      "qdir": qtype = QDIR;
      "quno": qtype = QUNO;
      "qatm": qtype = QATM;
      "qord": qtype = QORD;
    endcase
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq:start_pp_cq: is_ldb=%0d pp_cq_index_in=%0d qtype=%0s; cq_hpa_addr=0x%0x intr_remap_addr=0x%0x", is_ldb, pp_cq_index_in, qtype_str, cq_hpa_addr, intr_remap_addr), UVM_LOW);


    //-------------------------------
    //--
    if (is_ldb) begin
       if(pp_cq_index_in < hqm_pkg::NUM_LDB_QID) begin
          if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",pp_cq_index_in),pp_cq_num_in)) begin
             ims_idx_val = i_hqm_cfg.get_ims_idx(is_ldb, pp_cq_num_in);
             qid_sem.get(1);
    
             for (qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
               if (!(ldb_qid_used.exists(qid)) && i_hqm_cfg.is_sciov_vqid_v( 1'b1, pp_cq_num_in, ((qtype == QDIR) ? 1'b0 : 1'b1), qid)) begin
                 ldb_qid_used[qid] = 1;
                 break;
               end 
             end 
    
             qid_sem.put(1);
    
             if (qid >= hqm_pkg::NUM_LDB_QID) begin
               `uvm_error(get_full_name(),$psprintf("LDB PP %0d does not have a valid vqid associated with it",pp_cq_num_in))
               return;
             end 
             vdev_val = i_hqm_cfg.get_vdev(is_ldb, pp_cq_num_in);
             uvm_report_info(get_full_name(), $psprintf("start_pp_cq pp_cq_index_in=%0d :: pp_cq_num_in=%0d vdev=%0d vqid=%0d qid=%0d; map of ldb_pp_cq_cfg[%0d].vdev=%0d; map of vdev_cfg[%0d].ldb_vqid_cfg[%0d].qid=%0d, ims_idx_val=%0d", pp_cq_index_in, pp_cq_num_in, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid, pp_cq_num_in, vdev_val, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid, ims_idx_val));
          end else begin
            `uvm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
            return;
          end 
       end else begin
          //--upper 32 PP
          if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",pp_cq_index_in),pp_cq_num_in)) begin
             ims_idx_val = i_hqm_cfg.get_ims_idx(is_ldb, pp_cq_num_in);
             qid_sem.get(1);

             for (qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
                if (!(ldb_qid_used_2nd.exists(qid)) && i_hqm_cfg.is_sciov_vqid_v( 1'b1, pp_cq_num_in, ((qtype == QDIR) ? 1'b0 : 1'b1), qid)) begin
                  ldb_qid_used_2nd[qid] = 1;
                  break;
                end 
             end 

             qid_sem.put(1);

             if (qid >= hqm_pkg::NUM_LDB_QID) begin
               `uvm_error(get_full_name(),$psprintf("LDB PP %0d does not have a valid vqid associated with it is_ldb=1 pp_cq_index_in=%0d (upper 32 pp)",pp_cq_num_in, pp_cq_index_in))
                return;
             end 

             vdev_val = i_hqm_cfg.get_vdev(is_ldb, pp_cq_num_in);

             uvm_report_info(get_full_name(), $psprintf("start_pp_cq pp_cq_index_in=%0d :: pp_cq_num_in=%0d vdev=%0d vqid=%0d qid=%0d; map of ldb_pp_cq_cfg[%0d].vdev=%0d; map of vdev_cfg[%0d].ldb_vqid_cfg[%0d].qid=%0d (upper 32 pp), ims_idx_val=%0d", pp_cq_index_in, pp_cq_num_in, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid, pp_cq_num_in, vdev_val, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid, ims_idx_val));
          end else begin
             `uvm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
             return;
          end 
       end //if(pp_cq_index_in < hqm_pkg::NUM_LDB_QID
    end else begin
      if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",pp_cq_index_in),pp_cq_num_in)) begin
        ims_idx_val = i_hqm_cfg.get_ims_idx(is_ldb, pp_cq_num_in);
        qid_sem.get(1);

        for (qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
          if (!(dir_qid_used.exists(qid)) && i_hqm_cfg.is_sciov_vqid_v( 1'b0, pp_cq_num_in, ((qtype == QDIR) ? 1'b0 : 1'b1), qid)) begin
            dir_qid_used[qid] = 1;
            break;
          end 
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


    //--
    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp_cq_num_in), {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp_cq_num_in), {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];

    //----------------------------------
    //-- AY_HQMV30_ATS:
    //-- the above cq_addr_val read from CQ_ADDR ral is virtual address
    //-- to get physical address: cq_addr_val=i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in);  
    //----------------------------------
    if(i_hqm_cfg.ats_enabled==1) begin
        cq_addr_val = i_hqm_cfg.get_cq_hpa(is_ldb, pp_cq_num_in); 
        uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq_setting: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), UVM_LOW);
    end  

    //----------------------------------
    //----------------------------------
    if(has_cq_hpa_addr>0) trf_cq_addr_val = cq_hpa_addr; //--SoC support
    else                  trf_cq_addr_val = cq_addr_val; //--AY_HQMV30_ATS-- is physical addr 
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq_setting: is_ldb=%0d pp=%0d trf_cq_addr_val=0x%0x, cq_addr_val=0x%0x cq_hpa_addr=0x%0x with has_cq_hpa_addr=%0d; intr_remap_addr=0x%0x", is_ldb, pp_cq_index_in, trf_cq_addr_val, cq_addr_val, cq_hpa_addr, has_cq_hpa_addr, intr_remap_addr), UVM_LOW);

    //----------------------------------
    //----------------------------------
    //--
    ims_poll_addr_val = i_hqm_cfg.get_ims_poll_addr(pp_cq_num_in,is_ldb);

    if(has_ims_poll_hpa_addr>0) trf_ims_poll_addr_val = ims_poll_hpa_addr;
    else                        trf_ims_poll_addr_val = ims_poll_addr_val;
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw2_seq_setting: is_ldb=%0d pp=%0d trf_ims_poll_addr_val=0x%0x, ims_poll_addr_val=0x%0x ims_poll_hpa_addr=0x%0x with has_ims_poll_hpa_addr=%0d", is_ldb, pp_cq_index_in, trf_ims_poll_addr_val, ims_poll_addr_val, ims_poll_hpa_addr, has_ims_poll_hpa_addr), UVM_LOW);

    //----------------------------------
    //----------------------------------
    //--
    my_field    = ral.find_field_by_name("MODE", "MSIX_MODE", {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data    = my_field.get_actual();

    msix_mode   = ral_data[0];

    //--
    if (dut_view.enable_ims || dut_view.enable_ims_poll) begin
       if(ims_idx_val>=0) begin
          my_reg   = ral.find_reg_by_file_name($psprintf("AI_CTRL[%0d]",ims_idx_val), {cfg.tb_env_hier,".hqm_system_csr"});
          ral_data    = my_reg.get_actual();
          cq_ims_ctrl = ral_data[31:0];
       end else begin
          cq_ims_ctrl = 0;
          uvm_report_error(get_type_name(),$psprintf("hcw_sciov_test_hcw2_seq: doesn't find ims_idx_val %0d < 0; is_ldb=%0d, cq=%0d", ims_idx_val, is_ldb,  pp_cq_num_in), UVM_LOW);
       end 
    end 

    hcw_delay_min_in = is_ldb ? cfg.ldb_hcw_delay_min : cfg.dir_hcw_delay_min;

    hcw_delay_max_in = is_ldb ? cfg.ldb_hcw_delay_max : cfg.dir_hcw_delay_max;

    hcw_delay_min_in    = hcw_delay_min_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);
    hcw_delay_max_in    = hcw_delay_max_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);

    batch_min = is_ldb ? cfg.ldb_batch_min : cfg.dir_batch_min;
    batch_max = is_ldb ? cfg.ldb_batch_max : cfg.dir_batch_max;

    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, batch_min);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, batch_max);


    //--HQMV30 ROB: max cacheline num/pad/shuffle control
    cacheline_max_num_min = is_ldb ? cfg.ldb_cacheline_max_num_min : cfg.dir_cacheline_max_num_min;
    cacheline_max_num_max = is_ldb ? cfg.ldb_cacheline_max_num_max : cfg.dir_cacheline_max_num_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLNUM_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_num_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLNUM_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_num_max);
    cacheline_max_num = $urandom_range(cacheline_max_num_min,cacheline_max_num_max); 
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: cacheline_max_num_min=%0d cacheline_max_num_max=%0d => cacheline_max_num=%0d", cacheline_max_num_min, cacheline_max_num_max, cacheline_max_num), UVM_LOW);

    cacheline_max_pad_min = is_ldb ? cfg.ldb_cacheline_max_pad_min : cfg.dir_cacheline_max_pad_min;
    cacheline_max_pad_max = is_ldb ? cfg.ldb_cacheline_max_pad_max : cfg.dir_cacheline_max_pad_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_pad_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_pad_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cacheline_max_pad_min=%0d cacheline_max_pad_max=%0d", cacheline_max_pad_min, cacheline_max_pad_max), UVM_LOW);

    cacheline_max_shuffle_min = is_ldb ? cfg.ldb_cacheline_max_shuffle_min : cfg.dir_cacheline_max_shuffle_min;
    cacheline_max_shuffle_max = is_ldb ? cfg.ldb_cacheline_max_shuffle_max : cfg.dir_cacheline_max_shuffle_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_shuffle_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_shuffle_max);
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", cacheline_max_shuffle_min, cacheline_max_shuffle_max), UVM_LOW);

    cl_pad = is_ldb ? cfg.ldb_cl_pad : cfg.dir_cl_pad;
    $value$plusargs({$psprintf("%s_PP%0d_CL_PAD",pp_cq_prefix,pp_cq_index_in),"=%d"}, cl_pad);
    uvm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cl_pad=%0d ", cl_pad), UVM_LOW);

    ldb_acomp_ctrl  = cfg.ldb_acomp_rtn_ctrl;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_ACOMP_CTRL",pp_cq_prefix,pp_cq_index_in),"=%d"}, ldb_acomp_ctrl);
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: ldb_acomp_ctrl=%0d ", ldb_acomp_ctrl), UVM_LOW);

    //-- call i_hqm_cfg.get_cl_rob to check if HQMV30 RTL has been programmed to set ROB=1 
    is_rob_enabled = i_hqm_cfg.get_cl_rob(is_ldb, pp_cq_num_in);
    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: is_rob_enabled=%0d ", is_rob_enabled), UVM_LOW);

    //-- if ROB is not set to 1 in this PP, reset cacheline_max_num=1, cl_pad=0
    if(is_rob_enabled==0 && !$test$plusargs("HQM_PP_FORCE_CL_SHUFFLED")) begin
        cacheline_max_num = 1;
        cacheline_max_pad_min = 0;
        cacheline_max_pad_max = 0;
        cacheline_max_shuffle_min = 0;
        cacheline_max_shuffle_max = 0;
        cl_pad = 0;
        uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: is_rob_enabled=%0d reset cacheline_max_num=%0d cl_pad=%0d cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", is_rob_enabled, cacheline_max_num, cl_pad, cacheline_max_shuffle_min, cacheline_max_shuffle_max), UVM_LOW);
    end 


    //--------------------------

    if (dut_view.enable_msix) begin
      cq_poll_int = 0;
    end else if (dut_view.enable_ims || dut_view.enable_ims_poll) begin
      //cq_poll_int = 0;
      if(cq_ims_ctrl==1) begin
        cq_poll_int = 1; //-- when ai_ctrl[ims_idx_val] bit0=1, cq_int is masked, disable cq_poll_int by setting cq_poll_int=1
      end else begin
        cq_poll_int = 0; //--enable cq_poll_int 
      end 
    end else begin
      cq_poll_int = 1;
    end 

    tbcnt_offset_in = 0;
    if ($value$plusargs({$psprintf("%s_PP%0d_TBCNT_OFFSET",pp_cq_prefix,pp_cq_index_in),"=%d"}, tbcnt_offset_in) == 0) begin
      $value$plusargs({$psprintf("%s_TBCNT_OFFSET",pp_cq_prefix),"=%d"}, tbcnt_offset_in);
    end 

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

                     hcw_acomp_ctrl             == ldb_acomp_ctrl;

                     queue_list_delay_min       == hcw_delay_min_in;
                     queue_list_delay_max       == hcw_delay_max_in;

                     cq_addr                    == trf_cq_addr_val;
                     ims_poll_addr              == trf_ims_poll_addr_val;
                     intr_remap_addr            == intr_remap_addr;

                     cq_poll_interval           == cq_poll_int;
                   } ) begin
      `uvm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end 

    //qtype_str = is_ldb ? cfg.ldb_qtype.name() : cfg.dir_qtype.name();
    //qtype_str = qtype_str.tolower();

    lock_id = 16'h4001;

    dsi = 16'h0100;

    //case (qtype_str)
    //  "qdir": qtype = QDIR;
    //  "quno": qtype = QUNO;
    //  "qatm": qtype = QATM;
    //  "qord": qtype = QORD;
    //endcase

    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = is_ldb ? cfg.ldb_num_hcw : cfg.dir_num_hcw;

      hcw_time_gen = is_ldb ? cfg.ldb_hcw_time : cfg.dir_hcw_time;

      if ((hcw_time_gen > 0) && (num_hcw_gen == 0)) begin
        num_hcw_gen = 1;
      end 

      pp_cq_seq.queue_list[i].num_hcw                   = num_hcw_gen;
      pp_cq_seq.queue_list[i].hcw_time                  = hcw_time_gen;
      pp_cq_seq.queue_list[i].qid                       = qid + i;
      pp_cq_seq.queue_list[i].qtype                     = qtype;
      pp_cq_seq.queue_list[i].qpri_weight[0]            = 1;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_min_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
      pp_cq_seq.queue_list[i].tbcnt_offset              = tbcnt_offset_in;
      pp_cq_seq.queue_list[i].comp_flow                 = 1;
      pp_cq_seq.queue_list[i].cq_token_return_flow      = 1;
      pp_cq_seq.queue_list[i].illegal_hcw_gen_mode      = hqm_pp_cq_base_seq::NO_ILLEGAL;
  
      //-- condition is pp[idx] => cq[idx]
      if(qtype != QDIR) 
          i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in] = num_hcw_gen;
      else 
          i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in] = num_hcw_gen;

      uvm_report_info(get_type_name(),$psprintf("start_pp_cq_generate__[%0d]: pp_cq_index_in=%0d/pp_cq_num_in=%0d/cq_addr_val=0x%0x/qtype=%0s/qid=%0d/lockid=0x%0x/delay=[%0d:%0d]/num_hcw_gen=%0d, hcw_ldb_cq_hcw_num[%0d]=%0d/hcw_dir_cq_hcw_num[%0d]=%0d; cq_ims_ctrl=0x%0x cq_poll_int=%0d, ims_idx_val=%0d", i, pp_cq_index_in, pp_cq_num_in, cq_addr_val, qtype.name(), pp_cq_seq.queue_list[i].qid, lock_id, hcw_delay_min_in, hcw_delay_max_in, num_hcw_gen, pp_cq_num_in, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in], pp_cq_num_in, i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in], cq_ims_ctrl, cq_poll_int, ims_idx_val),  UVM_LOW);
    end 

    finish_item(pp_cq_seq);
  endtask


endclass
