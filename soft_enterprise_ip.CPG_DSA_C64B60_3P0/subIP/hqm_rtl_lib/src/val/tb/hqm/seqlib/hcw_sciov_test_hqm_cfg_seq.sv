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
// File   : hcw_sciov_test_hqm_cfg_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_sciov_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hcw_sciov_test_hqm_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_sciov_test_hqm_cfg_seq_stim_config";

  `ovm_object_utils_begin(hcw_sciov_test_hqm_cfg_seq_stim_config)
    `ovm_field_string(tb_env_hier,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_ldb_pp,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_dir_pp,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_vdev,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_msix,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_ims,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_ims_poll,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_write_dir,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_write_ldb,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_first_write_dir, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_first_write_ldb, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_pasid_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_pasid_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_pasid_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_pasid_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_pp_rob_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_pp_rob_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_pp_rob_min,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_pp_rob_max,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(dir_pasid_q,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(ldb_pasid_q,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq2tc_map,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq2tc_map,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(int2tc_map,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(disable_wb_opt_cq,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(write_single_beats,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(use_sequential_names,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(early_dir_int,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_timer_int_thresh,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_timer_int_en,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_depth_int_thresh, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_depth_int_thresh, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_depth_int_en,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(crdt_cnt,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_depth,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_depth,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_atsresp_errtype,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_atsresp_errtype,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(PpQid_per_vas,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_sn_qid_v,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_ao_qid_v,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_base_addr_ctl,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_base_addr_ctl,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_ims_base_addr,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_ims_base_addr,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(dir_ims_addr_q,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(dir_ims_data_q,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(dir_ims_ctrl_q,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(ldb_ims_addr_q,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(ldb_ims_data_q,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(ldb_ims_ctrl_q,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ims_prog_rand,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(msix_base_addr,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_addr_q,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_data_q,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hcw_sciov_test_hqm_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(num_ldb_pp)
    `stimulus_config_field_rand_int(num_dir_pp)
    `stimulus_config_field_rand_int(num_vdev)
    `stimulus_config_field_rand_int(enable_msix)
    `stimulus_config_field_rand_int(enable_ims)
    `stimulus_config_field_rand_int(enable_ims_poll)
    `stimulus_config_field_rand_int(cfg_pad_write_dir)
    `stimulus_config_field_rand_int(cfg_pad_write_ldb)
    `stimulus_config_field_rand_int(cfg_pad_first_write_dir)
    `stimulus_config_field_rand_int(cfg_pad_first_write_ldb)
    `stimulus_config_field_rand_int(dir_cq2tc_map)
    `stimulus_config_field_rand_int(ldb_cq2tc_map)
    `stimulus_config_field_rand_int(dir_pasid_min)
    `stimulus_config_field_rand_int(dir_pasid_max)
    `stimulus_config_field_rand_int(ldb_pasid_min)
    `stimulus_config_field_rand_int(ldb_pasid_max)
    `stimulus_config_field_queue_int(dir_pasid_q)
    `stimulus_config_field_queue_int(ldb_pasid_q)
    `stimulus_config_field_rand_int(dir_pp_rob_min)
    `stimulus_config_field_rand_int(dir_pp_rob_max)
    `stimulus_config_field_rand_int(ldb_pp_rob_min)
    `stimulus_config_field_rand_int(ldb_pp_rob_max)
    `stimulus_config_field_rand_int(int2tc_map)
    `stimulus_config_field_rand_int(disable_wb_opt_cq)
    `stimulus_config_field_rand_int(write_single_beats)
    `stimulus_config_field_rand_int(use_sequential_names)
    `stimulus_config_field_rand_int(early_dir_int)
    `stimulus_config_field_rand_int(cq_timer_int_thresh)
    `stimulus_config_field_rand_int(cq_timer_int_en)
    `stimulus_config_field_rand_int(dir_cq_depth_int_thresh)
    `stimulus_config_field_rand_int(ldb_cq_depth_int_thresh)
    `stimulus_config_field_rand_int(cq_depth_int_en)
    `stimulus_config_field_rand_int(crdt_cnt)
    `stimulus_config_field_rand_int(dir_cq_depth)
    `stimulus_config_field_rand_int(ldb_cq_depth)
    `stimulus_config_field_rand_int(dir_atsresp_errtype)
    `stimulus_config_field_rand_int(ldb_atsresp_errtype)
    `stimulus_config_field_rand_int(PpQid_per_vas)
    `stimulus_config_field_rand_int(ldb_sn_qid_v)
    `stimulus_config_field_rand_int(ldb_ao_qid_v)
    `stimulus_config_field_rand_int(dir_cq_base_addr_ctl)
    `stimulus_config_field_rand_int(ldb_cq_base_addr_ctl)
    `stimulus_config_field_int(dir_ims_base_addr)
    `stimulus_config_field_int(ldb_ims_base_addr)
    `stimulus_config_field_queue_int(dir_ims_addr_q)
    `stimulus_config_field_queue_int(dir_ims_data_q)
    `stimulus_config_field_queue_int(dir_ims_ctrl_q)
    `stimulus_config_field_queue_int(ldb_ims_addr_q)
    `stimulus_config_field_queue_int(ldb_ims_data_q)
    `stimulus_config_field_queue_int(ldb_ims_ctrl_q)
    `stimulus_config_field_rand_int(ims_prog_rand)
    `stimulus_config_field_int(msix_base_addr)
    `stimulus_config_field_queue_int(msix_addr_q)
    `stimulus_config_field_queue_int(msix_data_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";

  rand  int                     num_vdev;
  rand  int                     num_ldb_pp;
  rand  int                     num_dir_pp;
  rand  bit                     enable_msix;
  rand  bit                     enable_ims;
  rand  bit                     enable_ims_poll;
  rand  bit                     cfg_pad_write_dir;
  rand  bit                     cfg_pad_write_ldb;
  rand  bit                     cfg_pad_first_write_dir;
  rand  bit                     cfg_pad_first_write_ldb;
  rand  int                     disable_wb_opt_cq;
  rand  int                     early_dir_int;
  rand  bit                     write_single_beats;
  rand  bit                     use_sequential_names;
  rand  bit [15:0]              dir_cq2tc_map;
  rand  bit [15:0]              ldb_cq2tc_map;
  rand  bit [3:0]               int2tc_map;

  rand  bit [22:0]              dir_pasid_min;
  rand  bit [22:0]              dir_pasid_max;
  rand  bit [22:0]              ldb_pasid_min;
  rand  bit [22:0]              ldb_pasid_max;
  bit [22:0]                    dir_pasid_q[$];
  bit [22:0]                    ldb_pasid_q[$];

  rand  bit                     dir_pp_rob_min;
  rand  bit                     dir_pp_rob_max;
  rand  bit                     ldb_pp_rob_min;
  rand  bit                     ldb_pp_rob_max;

  rand  bit                     cq_timer_int_en;
  rand  bit                     cq_depth_int_en;
  rand  int                     cq_timer_int_thresh;
  rand  int                     dir_cq_depth_int_thresh;
  rand  int                     ldb_cq_depth_int_thresh;
  rand  int                     crdt_cnt;
  rand  int                     dir_cq_depth;
  rand  int                     ldb_cq_depth;
  rand  int                     PpQid_per_vas;

  rand  int                     ldb_sn_qid_v;
  rand  int                     ldb_ao_qid_v;

  rand  int                     dir_cq_base_addr_ctl;
  rand  int                     ldb_cq_base_addr_ctl;

  rand  int                     dir_atsresp_errtype;
  rand  int                     ldb_atsresp_errtype;

  bit [63:0]                    dir_ims_base_addr = 64'h00000000_000aaa00;
  bit [63:0]                    ldb_ims_base_addr = 64'h00000000_00055500;

  bit [63:0]                    dir_ims_addr_q[$];
  bit [31:0]                    dir_ims_data_q[$];
  bit [31:0]                    dir_ims_ctrl_q[$];

  bit [63:0]                    ldb_ims_addr_q[$];
  bit [31:0]                    ldb_ims_data_q[$];
  bit [31:0]                    ldb_ims_ctrl_q[$];

  rand int                      ims_prog_rand;

  bit [63:0]                    msix_base_addr = 64'h00000000_fee00000;

  bit [63:0]                    msix_addr_q[$];
  bit [31:0]                    msix_data_q[$];

  constraint c_cq_intr_config {

      soft cq_timer_int_thresh         == 2;
      soft cq_timer_int_en             == 1;
      soft dir_cq_depth_int_thresh     == 1;
      soft ldb_cq_depth_int_thresh     == 1;
      soft cq_depth_int_en             == 1;
      soft crdt_cnt                    == 16384;
      soft dir_cq_depth                == 1024;
      soft ldb_cq_depth                == 1024;
      soft PpQid_per_vas               == 0;

  }

  constraint c_pad_write {
      soft cfg_pad_write_dir       == 1;
      soft cfg_pad_write_ldb       == 1;
      soft cfg_pad_first_write_dir == 0;
      soft cfg_pad_first_write_ldb == 0;
      soft disable_wb_opt_cq       == -1;
      soft write_single_beats      == 1'b0;
      soft use_sequential_names == 0;
      soft early_dir_int           == 0;
  }

  constraint c_num_pp_soft {
    soft num_ldb_pp                  >= 0;
    soft num_ldb_pp                  <= hqm_pkg::NUM_LDB_PP;
    soft num_ldb_pp                  <= hqm_pkg::NUM_LDB_QID;
    soft num_dir_pp                  >= 0;
    soft num_dir_pp                  <= hqm_pkg::NUM_DIR_PP;
    soft num_dir_pp                  <= hqm_pkg::NUM_DIR_QID;
    soft (num_ldb_pp + num_dir_pp)   > 0;
  }

  //constraint c_num_pp_soft {
  //  soft num_ldb_pp     inside { 0,1,2,4,8,16 };
  //  soft num_dir_pp     inside { 0,1,2,4,8,16 };
  //}

  constraint c_num_vdev_soft {
    solve num_ldb_pp before num_vdev;
    solve num_dir_pp before num_vdev;

    soft num_vdev                    >= 1;
    soft num_vdev                    <= 16;
    soft num_vdev                    <= num_dir_pp;
    soft num_vdev                    <= num_ldb_pp;
  }

  constraint c_pasid_soft {
    soft dir_pasid_min == 23'h0;
    soft dir_pasid_max == 23'h4fffff;
    soft ldb_pasid_min == 23'h0;
    soft ldb_pasid_max == 23'h4fffff;
  }

  constraint c_msix_soft {
    soft enable_msix == 0;
  }

  constraint c_imsprogrand_soft {
    soft ims_prog_rand == 0;
  }

  constraint c_dir_pp_rob_soft {
    soft dir_pp_rob_min       == 0;
    soft dir_pp_rob_max       == 0;
  }

  constraint c_ldb_pp_rob_soft {
    soft ldb_pp_rob_min       == 0;
    soft ldb_pp_rob_max       == 0;
  }

  constraint c_ldb_sn_ao_soft {
      soft ldb_sn_qid_v    == 0;
      soft ldb_ao_qid_v    == 0;
  }

  constraint c_atsresp_errtype {
      soft dir_atsresp_errtype    == 0;
      soft ldb_atsresp_errtype    == 0;
  }

  constraint c_cq_base_addr_ctl_soft {
    soft dir_cq_base_addr_ctl     == 0;
    soft ldb_cq_base_addr_ctl     == 0;
  }

  function new(string name = "hcw_sciov_test_hqm_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_sciov_test_hqm_cfg_seq_stim_config

class hcw_sciov_test_hqm_cfg_seq extends hqm_base_cfg_seq;
  `ovm_sequence_utils(hcw_sciov_test_hqm_cfg_seq,sla_sequencer)

  rand hcw_sciov_test_hqm_cfg_seq_stim_config   cfg;

  hcw_sciov_test_enable_ims_cfg_seq             enable_ims_cfg_seq;

  hcw_sciov_test_enable_msix_cfg_seq            enable_msix_cfg_seq;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_sciov_test_hqm_cfg_seq_stim_config);
`endif

  //--cq_addr reprogramming
  int                           dir_cq_addr_ctrl;
  int                           ldb_cq_addr_ctrl;


  function new(string name = "hcw_sciov_test_hqm_cfg_seq");
    super.new(name); 

    cfg = hcw_sciov_test_hqm_cfg_seq_stim_config::type_id::create("hcw_sciov_test_hqm_cfg_seq_stim_config");
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
    string      cfg_cmd;
    int         dir_vqid_avail[$];
    int         ldb_vqid_avail[$];
    int         ldb_vqid_avail_2nd[$];
    int         qid_avail[$];
    int         vqid_index;
    int         vqid;
    int         pp;
    int         qid;
    bit [hqm_pkg::NUM_DIR_CQ-1:0]       dir_cq_intr_armed;
    bit [hqm_pkg::NUM_LDB_CQ-1:0]       ldb_cq_intr_armed;
    int         dir_pp_per_vdev;
    int         ldb_pp_per_vdev;
    bit         exp_ingress_err;
    bit [22:0]  dir_pasid_val;
    bit [22:0]  ldb_pasid_val;
    bit         dir_cl_rob, ldb_cl_rob;
    int         ldb_sn_qid_prog, ldb_ao_qid_prog;
    int         ord_mode_prog, ord_slot_prog, ord_grp_prog;
    hcw_sciov_test_stim_dut_view        dut_view;

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    if (cfg.use_sequential_names) begin
      i_hqm_cfg.set_sequential_names(1);
    end

    dut_view = hcw_sciov_test_stim_dut_view::instance(m_sequencer,inst_suffix);

    dut_view.num_dir_pp         = cfg.num_dir_pp;
    dut_view.num_ldb_pp         = cfg.num_ldb_pp;
    dut_view.num_vdev           = cfg.num_vdev;
    dut_view.enable_msix        = cfg.enable_msix;
    dut_view.enable_ims         = cfg.enable_ims;
    dut_view.enable_ims_poll    = cfg.enable_ims_poll;

    //-----------------------------
    //-----------------------------
    dir_cq_addr_ctrl = cfg.dir_cq_base_addr_ctl;
    ldb_cq_addr_ctrl = cfg.ldb_cq_base_addr_ctl;
    if($test$plusargs("HQM_DIRCQ_ADDR_REPROG")) begin
       dir_cq_addr_ctrl = 1;
    end
    if($test$plusargs("HQM_LDBCQ_ADDR_REPROG")) begin
       ldb_cq_addr_ctrl = 1;
    end

    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hqm_cfg_seq: Starting SCIOV Config with num_dir_pp=%0d num_ldb_pp=%0d; enable_ims=%0d enable_ims_poll=%0d enable_msix=%0d ims_prog_rand=%0d; dir_pasid_q.size=%0d ldb_pasid_q.size=%0d dir_cq_addr_ctrl=%0d ldb_cq_addr_ctrl=%0d", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.enable_ims, dut_view.enable_ims_poll, dut_view.enable_msix, cfg.ims_prog_rand, cfg.dir_pasid_q.size(), cfg.ldb_pasid_q.size(), dir_cq_addr_ctrl, ldb_cq_addr_ctrl), OVM_NONE);

    if(cfg.enable_msix==1 && ((cfg.num_dir_pp + cfg.num_ldb_pp) >64)) begin
       cfg.enable_msix=0;
       dut_view.enable_msix=0; 
       ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hqm_cfg_seq: Starting SCIOV Config with num_dir_pp=%0d num_ldb_pp=%0d; Change:enable_msix=%0d due to total pp number>64", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.enable_msix), OVM_NONE);
    end

    //TODO  cfg_cmds.push_back("mem_update      # initialize memories to hqm_cfg defaults using backdoor access");

    cfg_cmds.push_back("cfg_begin");

    //-------------------------------
    for (int qid = 0 ; qid < cfg.num_dir_pp ; qid++) begin
      cfg_cmds.push_back($psprintf("dir qid DQ%0d:*",qid));
    end

    for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
      if(cfg.ldb_sn_qid_v==0)      ldb_sn_qid_prog=0;
      else if(cfg.ldb_sn_qid_v==1) ldb_sn_qid_prog=1;
      else                         ldb_sn_qid_prog=$urandom_range(0,1);

      if(cfg.ldb_ao_qid_v==0)      ldb_ao_qid_prog=0;
      else if(cfg.ldb_ao_qid_v==1) ldb_ao_qid_prog=1;
      else                         ldb_ao_qid_prog=$urandom_range(0,1);

      if(cfg.num_ldb_pp<=4) begin
         ord_mode_prog=3; 
         ord_grp_prog = qid[1];
         ord_slot_prog= qid[0]; 
      end else if(cfg.num_ldb_pp<=8) begin
         ord_mode_prog=2; 
         ord_grp_prog = qid[2];
         ord_slot_prog= qid[1:0]; 
      end else if(cfg.num_ldb_pp<=16) begin
         ord_mode_prog=1; 
         ord_grp_prog = qid[3];
         ord_slot_prog= qid[2:0]; 
      end else if(cfg.num_ldb_pp<=32) begin
         ord_mode_prog=0; 
         ord_grp_prog = qid[4];
         ord_slot_prog= qid[3:0]; 
      end

      if(cfg.num_ldb_pp < hqm_pkg::NUM_LDB_QID) begin  
         //--HQMV25 cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ao_cfg_v=0",qid,2048/cfg.num_ldb_pp));

           if(ldb_sn_qid_prog || ldb_ao_qid_prog) begin
              cfg_cmd=$psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1  ",qid,2048/hqm_pkg::NUM_LDB_QID);
              cfg_cmd = {cfg_cmd,$psprintf(" aqed_freelist_base=%0d aqed_freelist_limit=%0d ", qid * (2048/cfg.num_ldb_pp),((qid + 1) * (2048/cfg.num_ldb_pp)) - 1)};
              cfg_cmd = {cfg_cmd,$psprintf(" ord_mode=%0d ord_slot=%0d ord_grp=%0d sn_cfg_v=1 ", ord_mode_prog,ord_slot_prog,ord_grp_prog)};
              cfg_cmd = {cfg_cmd,$psprintf(" ao_cfg_v=%0d  ", ldb_ao_qid_prog)};

              ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PROG_CFG_CMD_LDB_DIQ[%0d] cfg_cmd=%0s", qid, cfg_cmd), OVM_LOW);
              cfg_cmds.push_back(cfg_cmd);
           end else begin
              cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ao_cfg_v=0",qid,2048/cfg.num_ldb_pp));
           end
      end else begin
        if(qid < hqm_pkg::NUM_LDB_QID) begin
         //--HQMV25 cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ao_cfg_v=0",qid,2048/hqm_pkg::NUM_LDB_QID));
           if(ldb_sn_qid_prog || ldb_ao_qid_prog) begin
              cfg_cmd=$psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ",qid,2048/hqm_pkg::NUM_LDB_QID);
              cfg_cmd = {cfg_cmd,$psprintf(" aqed_freelist_base=%0d aqed_freelist_limit=%0d ", qid * (2048/cfg.num_ldb_pp),((qid + 1) * (2048/cfg.num_ldb_pp)) - 1)};
              cfg_cmd = {cfg_cmd,$psprintf(" ord_mode=%0d ord_slot=%0d ord_grp=%0d sn_cfg_v=1 ", ord_mode_prog,ord_slot_prog,ord_grp_prog)};
              cfg_cmd = {cfg_cmd,$psprintf(" ao_cfg_v=%0d  ", ldb_ao_qid_prog)};

              ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PROG_CFG_CMD_LDB_DIQ[%0d] cfg_cmd=%0s", qid, cfg_cmd), OVM_LOW);
              cfg_cmds.push_back(cfg_cmd);
           end else begin
              cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ao_cfg_v=0",qid,2048/hqm_pkg::NUM_LDB_QID));
           end
        end
      end
    end

    //-------------------------------
    // in case of cfg.PpQid_per_vas=1, create as many VASes as num DIR + num
    // LDB ports and allocate one port each to a VAS
    if (cfg.PpQid_per_vas) begin
        for (int qid = 0 ; qid < cfg.num_dir_pp ; qid++) begin
          cfg_cmd = $psprintf("vas VAS%0d:* credit_cnt=%0d ", qid, cfg.crdt_cnt);
          cfg_cmd = {cfg_cmd,$psprintf("dir_qidv:DQ%0d=1 ",qid)};
          cfg_cmds.push_back(cfg_cmd);
        end

        for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
          cfg_cmd = $psprintf("vas VAS%0d:* credit_cnt=%0d ", (cfg.num_dir_pp+qid), cfg.crdt_cnt);
          cfg_cmd = {cfg_cmd,$psprintf("ldb_qidv:LQ%0d=1 ",qid)};
          cfg_cmds.push_back(cfg_cmd);
        end
    end else begin
        cfg_cmd = $psprintf("vas VAS0:* credit_cnt=%0d ", cfg.crdt_cnt);

        for (int qid = 0 ; qid < cfg.num_dir_pp ; qid++) begin
           cfg_cmd = {cfg_cmd,$psprintf("dir_qidv:DQ%0d=1 ",qid)};
        end

        for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
           if(qid < hqm_pkg::NUM_LDB_QID) begin
              cfg_cmd = {cfg_cmd,$psprintf("ldb_qidv:LQ%0d=1 ",qid)};
           end
        end

        cfg_cmds.push_back(cfg_cmd);
    end

    //----------------------------------------------------------
    if($test$plusargs("ATS_4KPAGE_ONLY")) begin
        if(cfg.dir_cq_depth>256) cfg.dir_cq_depth=256;
        if(cfg.ldb_cq_depth>256) cfg.ldb_cq_depth=256;
    end


    //-------------------------------
    dir_cl_rob = $urandom_range(cfg.dir_pp_rob_min, cfg.dir_pp_rob_max);
    ldb_cl_rob = $urandom_range(cfg.ldb_pp_rob_min, cfg.ldb_pp_rob_max);

    for (int pp = 0 ; pp < cfg.num_dir_pp ; pp++) begin
      cfg_cmds.push_back($psprintf("dir pp DQ%0d vas=VAS%0d", pp, (cfg.PpQid_per_vas ? pp : 0)));
      cfg_cmds.push_back($psprintf("dir pp DQ%0d rob=%0d", pp, dir_cl_rob));
      if(cfg.dir_pasid_q.size()>0) begin
         dir_pasid_val = cfg.dir_pasid_q[pp];
         ovm_report_info("hcw_sciov_test_hqm_cfg_seq", $psprintf("dir_pasid_program:: cfg.dir_pasid_q[%0d]=0x%0x", pp, dir_pasid_val), OVM_LOW);
      end else begin
         dir_pasid_val = $urandom_range(cfg.dir_pasid_min, cfg.dir_pasid_max);
         if(cfg.enable_ims_poll && dir_pasid_val[19:0]==0) dir_pasid_val[19:0] = 1;
         ovm_report_info("hcw_sciov_test_hqm_cfg_seq", $psprintf("dir_pasid_program:: cq=0x%0x cfg.dir_pasid_min=0x%0x cfg.dir_pasid_max=0x%0x: get dir_pasid_val=0x%0x", pp, cfg.dir_pasid_min, cfg.dir_pasid_max, dir_pasid_val), OVM_LOW);
      end

     `ifdef IP_TYP_TE
        if(cfg.enable_ims_poll)
           cfg_cmds.push_back($psprintf("dir cq DQ%0d cq_depth=%0d cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x400000:0x4fffff] ats_resp_errinj=%0d ",pp, cfg.dir_cq_depth, cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.dir_cq_depth_int_thresh, cfg.cq_depth_int_en, cfg.dir_atsresp_errtype));
           //--AY_HQMV30_ATS_ cfg_cmds.push_back($psprintf("dir cq DQ%0d cq_depth=%0d cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x400001,0x4fffff,0x455555,0x4aaaaa,0x%0x:0x%0x] ",pp, cfg.dir_cq_depth, cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.dir_cq_depth_int_thresh, cfg.cq_depth_int_en, dir_pasid_val, dir_pasid_val));
        else
           cfg_cmds.push_back($psprintf("dir cq DQ%0d cq_depth=%0d cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x400000,0x4fffff,0x455555,0x4aaaaa,0x%0x:0x%0x] ats_resp_errinj=%0d ",pp, cfg.dir_cq_depth, cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.dir_cq_depth_int_thresh, cfg.cq_depth_int_en, dir_pasid_val, dir_pasid_val, cfg.dir_atsresp_errtype));
     `else
        cfg_cmds.push_back($psprintf("dir cq DQ%0d cq_depth=%0d cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x%0x:0x%0x] ",pp, cfg.dir_cq_depth, cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.dir_cq_depth_int_thresh, cfg.cq_depth_int_en, dir_pasid_val, dir_pasid_val));
     `endif
    end

    //-------------------------------
    for (int pp = 0 ; pp < cfg.num_ldb_pp ; pp++) begin
      cfg_cmds.push_back($psprintf("ldb pp LPP%0d:* vas=VAS%0d rob=%0d",pp, (cfg.PpQid_per_vas ? (cfg.num_dir_pp+pp) : 0), ldb_cl_rob));
      cfg_cmd = $psprintf("ldb cq LPP%0d cq_depth=%0d ",pp, cfg.ldb_cq_depth);

      if(cfg.ldb_pasid_q.size()>0) begin
         ldb_pasid_val = cfg.ldb_pasid_q[pp];
         ovm_report_info("hcw_sciov_test_hqm_cfg_seq", $psprintf("ldb_pasid_program:: cfg.ldb_pasid_q[%0d]=0x%0x", pp, ldb_pasid_val), OVM_LOW);
      end else begin
         ldb_pasid_val = $urandom_range(cfg.ldb_pasid_min, cfg.ldb_pasid_max);
         if(cfg.enable_ims_poll && ldb_pasid_val[19:0]==0) ldb_pasid_val[19:0] = 1;
         ovm_report_info("hcw_sciov_test_hqm_cfg_seq", $psprintf("ldb_pasid_program:: cq=0x%0x cfg.ldb_pasid_min=0x%0x cfg.ldb_pasid_max=0x%0x: get ldb_pasid_val=0x%0x", pp, cfg.ldb_pasid_min, cfg.ldb_pasid_max, ldb_pasid_val), OVM_LOW);
      end

     `ifdef IP_TYP_TE
        if(cfg.enable_ims_poll) begin
           cfg_cmd = {cfg_cmd, $psprintf("cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x400000:0x4fffff] ats_resp_errinj=%0d ", cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.ldb_cq_depth_int_thresh, cfg.cq_depth_int_en, cfg.ldb_atsresp_errtype)};
           //--AY_HQMV30_ATS_ cfg_cmd = {cfg_cmd, $psprintf("cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x4fffff,0x455555,0x4aaaaa,0x%0x:0x%0x] ", cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.ldb_cq_depth_int_thresh, cfg.cq_depth_int_en, ldb_pasid_val, ldb_pasid_val)};
        end else begin
           cfg_cmd = {cfg_cmd, $psprintf("cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x4fffff,0x455555,0x4aaaaa,0x%0x:0x%0x] ats_resp_errinj=%0d ", cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.ldb_cq_depth_int_thresh, cfg.cq_depth_int_en, ldb_pasid_val, ldb_pasid_val, cfg.ldb_atsresp_errtype)};
        end
     `else
        cfg_cmd = {cfg_cmd, $psprintf("cq_timer_intr_thresh=%0d cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=%0d pasid=[0x%0x:0x%0x] ", cfg.cq_timer_int_thresh, cfg.cq_timer_int_en, cfg.ldb_cq_depth_int_thresh, cfg.cq_depth_int_en, ldb_pasid_val, ldb_pasid_val)};
     `endif


      cfg_cmd = {cfg_cmd,$psprintf("hist_list_base=%0d hist_list_limit=%0d ",pp * (2048/cfg.num_ldb_pp),((pp + 1) * (2048/cfg.num_ldb_pp)) - 1)};

      qid_avail.delete();
      for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
        if (qid != pp) begin
          qid_avail.push_back(qid);
        end
      end

      if(pp < hqm_pkg::NUM_LDB_QID) begin 
         cfg_cmd = {cfg_cmd,$psprintf("qidv0=1 qidix0=LQ%0d ",pp)};
      end else begin
         cfg_cmd = {cfg_cmd,$psprintf("qidv0=1 qidix0=LQ%0d ",(pp - hqm_pkg::NUM_LDB_QID))};
      end

      // in case of cfg.PpQid_per_vas=1, skip mapping other CQ slots to
      // Qids. Just one QID mapped to one LDB port slot 0 (previous cfg_cmd)
      if (!cfg.PpQid_per_vas && (cfg.num_ldb_pp <= hqm_pkg::NUM_LDB_QID)) begin
         for (int qidix = 1 ; qidix < 8  ; qidix++) begin
           if (qid_avail.size() > 0) begin
             int lqid;
             int qid_index;

             qid_index = $urandom_range(qid_avail.size() - 1, 0);
             lqid = qid_avail[qid_index];
             qid_avail.delete(qid_index);

             cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d ",qidix,qidix,lqid)};
           end
         end
      end

      cfg_cmds.push_back(cfg_cmd);
      ovm_report_info("hcw_sciov_test_hqm_cfg_seq", $psprintf("LDB_CQQIDPRIO_CQ[%0d] cfg_cmd=%0s", pp, cfg_cmd), OVM_LOW);
    end

    //-------------------------------
    for (int i = 0; i < hqm_pkg::NUM_DIR_PP; i++) begin
      exp_ingress_err=0;
      if ( $value$plusargs({$psprintf("DIR_PP%0d_INGRESS_ERR", i),"=%d"}, exp_ingress_err) ) begin
        cfg_cmds.push_back($psprintf("dir pp DQ%0d exp_ill_hcw_cmd=%0d", i, exp_ingress_err));
      end
    end

    for (int i = 0; i < hqm_pkg::NUM_LDB_PP; i++) begin
      exp_ingress_err=0;
      if ( $value$plusargs({$psprintf("LDB_PP%0d_INGRESS_ERR", i),"=%d"}, exp_ingress_err) ) begin
        cfg_cmds.push_back($psprintf("ldb pp LPP%0d exp_ill_hcw_cmd=%0d", i, exp_ingress_err));
      end
    end

    //-------------------------------
    dir_vqid_avail.delete();

    for (int qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
      dir_vqid_avail.push_back(qid);
    end

    //-------------------------------
    ldb_vqid_avail.delete();
    ldb_vqid_avail_2nd.delete();

    for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
      ldb_vqid_avail.push_back(qid);
    end

    //-------------------------------
    dir_pp_per_vdev = (cfg.num_dir_pp + cfg.num_vdev - 1) / cfg.num_vdev;
    ldb_pp_per_vdev = (cfg.num_ldb_pp + cfg.num_vdev - 1) / cfg.num_vdev;

    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hqm_cfg_seq: Starting SCIOV Config with num_dir_pp=%0d num_ldb_pp=%0d num_vdev=%0d dir_pp_per_vdev=%0d ldb_pp_per_vdev=%0d enable_ims=%0d enable_ims_poll=%0d enable_msix=%0d", cfg.num_dir_pp, cfg.num_ldb_pp, cfg.num_vdev, dir_pp_per_vdev, ldb_pp_per_vdev, cfg.enable_ims, cfg.enable_ims_poll, cfg.enable_msix), OVM_LOW);

    // create VDEV one each for a Dir port as well as LDB port and assign
    // respective qid to it in case of cfg.PpQid_per_vas=1
    if (cfg.PpQid_per_vas) begin
        for (int vdev = 0 ; vdev < (cfg.num_vdev/2) ; vdev++) begin
          cfg_cmd = $psprintf("vdev VDEV%0d:* ", (2*vdev));
    
          for (int pp = (vdev * dir_pp_per_vdev) ; (pp < ((vdev + 1) * dir_pp_per_vdev)) && (pp < cfg.num_dir_pp) ; pp++) begin
            cfg_cmd = {cfg_cmd,$psprintf("dir_pp:DQ%0d:_v=1 ",pp)};
    
            vqid_index = $urandom_range(dir_vqid_avail.size()-1,0);
            vqid = dir_vqid_avail[vqid_index];
            dir_vqid_avail.delete(vqid_index);
            cfg_cmd = {cfg_cmd,$psprintf("dir_vqid%0d_qid=DQ%0d ",vqid,pp)};
          end    
          cfg_cmds.push_back(cfg_cmd);

          cfg_cmd = $psprintf("vdev VDEV%0d:* ", ((2*vdev)+1));
    
          for (int pp = (vdev * ldb_pp_per_vdev) ; (pp < ((vdev + 1) * ldb_pp_per_vdev)) && (pp < cfg.num_ldb_pp) ; pp++) begin
            cfg_cmd = {cfg_cmd,$psprintf("ldb_pp:LPP%0d:_v=1 ",pp)};
    
            vqid_index = $urandom_range(ldb_vqid_avail.size()-1,0);
            vqid = ldb_vqid_avail[vqid_index];
            ldb_vqid_avail.delete(vqid_index);
            cfg_cmd = {cfg_cmd,$psprintf("ldb_vqid%0d_qid=LQ%0d ",vqid,pp)};
          end    
          cfg_cmds.push_back(cfg_cmd);
        end
    end //if (cfg.PpQid_per_vas)
    else begin
       //-------------------------------
       for (int vdev = 0 ; vdev < cfg.num_vdev ; vdev++) begin
         //-------------------------------
         cfg_cmd = $psprintf("vdev VDEV%0d:* ",vdev);

         for (int pp = (vdev * dir_pp_per_vdev) ; (pp < ((vdev + 1) * dir_pp_per_vdev)) && (pp < cfg.num_dir_pp) ; pp++) begin
           cfg_cmd = {cfg_cmd,$psprintf("dir_pp:DQ%0d:_v=1 ",pp)};

           vqid_index = $urandom_range(dir_vqid_avail.size()-1,0);
           vqid = dir_vqid_avail[vqid_index];
           dir_vqid_avail.delete(vqid_index);
           cfg_cmd = {cfg_cmd,$psprintf("dir_vqid%0d_qid=DQ%0d ",vqid,pp)};
         end

         //-------------------------------
         for (int pp = (vdev * ldb_pp_per_vdev) ; (pp < ((vdev + 1) * ldb_pp_per_vdev)) && (pp < cfg.num_ldb_pp) ; pp++) begin
           cfg_cmd = {cfg_cmd,$psprintf("ldb_pp:LPP%0d:_v=1 ",pp)};

           if(pp < hqm_pkg::NUM_LDB_QID) begin 
              vqid_index = $urandom_range(ldb_vqid_avail.size()-1,0);
              vqid = ldb_vqid_avail[vqid_index];
              ldb_vqid_avail.delete(vqid_index);
              ldb_vqid_avail_2nd.push_back(vqid);
              cfg_cmd = {cfg_cmd,$psprintf("ldb_vqid%0d_qid=LQ%0d ",vqid,pp)};
              ovm_report_info("hcw_sciov_test_hqm_cfg_seq", $psprintf("DEBUG: VDEV=%0d ldb_pp_per_vdev=%0d vqid=%0d qid_idx=%0d(LQ: pp loop range %0d:%0d) cfg_cmd=%0s", vdev,  ldb_pp_per_vdev, vqid, pp, (vdev* ldb_pp_per_vdev), ((vdev + 1) * ldb_pp_per_vdev), cfg_cmd), OVM_LOW);
           end else begin
              vqid = ldb_vqid_avail_2nd.pop_front(); 
              cfg_cmd = {cfg_cmd,$psprintf("ldb_vqid%0d_qid=LQ%0d ",vqid,(pp - hqm_pkg::NUM_LDB_QID))};
              ovm_report_info("hcw_sciov_test_hqm_cfg_seq", $psprintf("DEBUG: VDEV=%0d ldb_pp_per_vdev=%0d vqid=%0d qid_idx=%0d(LQ: pp loop range %0d:%0d) cfg_cmd=%0s (upper pp)", vdev,  ldb_pp_per_vdev, vqid, pp, (vdev* ldb_pp_per_vdev), ((vdev + 1) * ldb_pp_per_vdev), cfg_cmd), OVM_LOW);
           end
         end

         cfg_cmds.push_back(cfg_cmd);
       end//for (vdev
    end


    //-------------------------------
    for (int pp = 0 ; pp < cfg.num_dir_pp ; pp++) begin
      if(dir_cq_addr_ctrl==0) begin
      cfg_cmds.push_back($psprintf("dir cq DQ%0d gpa=sm",pp));
    end
      //-- skip gpa=sm when dir_cq_addr_ctrl=1 (traffic seq will program cq_gpa/cq_hpa/cq_pagesize/pasid)
    end
    
    for (int pp = 0 ; pp < cfg.num_ldb_pp ; pp++) begin
      if(ldb_cq_addr_ctrl==0) begin
      cfg_cmds.push_back($psprintf("ldb cq LPP%0d gpa=sm",pp));
    end
      //-- skip gpa=sm when ldb_cq_addr_ctrl=1 (traffic seq will program cq_gpa/cq_hpa/cq_pagesize/pasid)
    end

    cfg_cmds.push_back($psprintf("cfg_pad_write_dir %0d", cfg.cfg_pad_write_dir));
    cfg_cmds.push_back($psprintf("cfg_pad_write_ldb %0d", cfg.cfg_pad_write_ldb));
    cfg_cmds.push_back($psprintf("cfg_pad_first_write_dir %0d", cfg.cfg_pad_first_write_dir));
    cfg_cmds.push_back($psprintf("cfg_pad_first_write_ldb %0d", cfg.cfg_pad_first_write_ldb));

    if (cfg.disable_wb_opt_cq != -1) begin
        cfg_cmds.push_back($psprintf("dir cq DQ%0d disable_wb_opt=1", cfg.disable_wb_opt_cq));
    end

    cfg_cmds.push_back($psprintf("wr hqm_system_csr.write_buffer_ctl.write_single_beats %0d", cfg.write_single_beats));
    cfg_cmds.push_back($psprintf("cfg_early_dir_int %0d", cfg.early_dir_int));

    cfg_cmds.push_back($psprintf("wr hqm_sif_csr.dir_cq2tc_map 0x%0x",cfg.dir_cq2tc_map));
    cfg_cmds.push_back($psprintf("wr hqm_sif_csr.ldb_cq2tc_map 0x%0x",cfg.ldb_cq2tc_map));
    cfg_cmds.push_back($psprintf("wr hqm_sif_csr.int2tc_map 0x%0x",cfg.int2tc_map));

    cfg_cmds.push_back("cfg_end");

    cfg_cmds.push_back("idle 100");

    cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable 0xffffffff");
    cfg_cmds.push_back("rd hqm_system_csr.ingress_alarm_enable 0x0000003f");

    // Verify expected value of PCIe configuration registers for SCIOV
    cfg_cmds.push_back("brd hqm_pf_cfg_i.pcie_cap_device_cap_2.e2etlpps 1");
    cfg_cmds.push_back("brd hqm_pf_cfg_i.pcie_cap_device_cap_2.effs 1");
    cfg_cmds.push_back("brd hqm_pf_cfg_i.pasid_control.pasid_enable 1");

    super.body();

    if (cfg.enable_msix) begin
      `ovm_create(enable_msix_cfg_seq)
      enable_msix_cfg_seq.inst_suffix = inst_suffix;
      enable_msix_cfg_seq.cfg.msix_base_addr      = cfg.msix_base_addr;
      enable_msix_cfg_seq.cfg.msix_addr_q         = cfg.msix_addr_q;
      enable_msix_cfg_seq.cfg.msix_data_q         = cfg.msix_data_q;
      `ovm_rand_send(enable_msix_cfg_seq)
    end else if (cfg.enable_ims || cfg.enable_ims_poll) begin
      `ovm_create(enable_ims_cfg_seq)
      enable_ims_cfg_seq.inst_suffix = inst_suffix;
      enable_ims_cfg_seq.cfg.dir_ims_base_addr  = cfg.dir_ims_base_addr;
      enable_ims_cfg_seq.cfg.ldb_ims_base_addr  = cfg.ldb_ims_base_addr;
      enable_ims_cfg_seq.cfg.dir_ims_addr_q     = cfg.dir_ims_addr_q;
      enable_ims_cfg_seq.cfg.dir_ims_data_q     = cfg.dir_ims_data_q;
      enable_ims_cfg_seq.cfg.dir_ims_ctrl_q     = cfg.dir_ims_ctrl_q;
      enable_ims_cfg_seq.cfg.ldb_ims_addr_q     = cfg.ldb_ims_addr_q;
      enable_ims_cfg_seq.cfg.ldb_ims_data_q     = cfg.ldb_ims_data_q;
      enable_ims_cfg_seq.cfg.ldb_ims_ctrl_q     = cfg.ldb_ims_ctrl_q;
      enable_ims_cfg_seq.cfg.ims_prog_rand      = cfg.ims_prog_rand;
      `ovm_rand_send(enable_ims_cfg_seq)
    end
  endtask
endclass : hcw_sciov_test_hqm_cfg_seq
