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
// File   : hcw_pf_test_hqm_cfg_seq.sv
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

class hcw_pf_test_hqm_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_pf_test_hqm_cfg_seq_stim_config";

  `ovm_object_utils_begin(hcw_pf_test_hqm_cfg_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_ldb_pp,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_dir_pp,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_msix,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_ims_poll,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pad_first_write_dir,   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pad_write_dir,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pad_first_write_ldb,   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(pad_write_ldb,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq2tc_map,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq2tc_map,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(int2tc_map,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(wu_limit,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(disable_wb_opt_cq,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(write_single_beats,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(sparse_cq_mode_dir,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(sparse_cq_mode_ldb,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(use_sequential_names,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(early_dir_int,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_wdog_cq,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_cdc_ctrl,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_sys_its,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(prochot_disable,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_hlexp_rnd,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_hlexp,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)

    `ovm_field_int(dir_pp_rob_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_pp_rob_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_pp_rob_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_pp_rob_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_qid_comp_code_min, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_qid_comp_code_max, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio0,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio1,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio2,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio3,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio4,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio5,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio6,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_prio7,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_sn_qid_v,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_ao_qid_v,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_atsresp_errtype,   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC) 
    `ovm_field_int(ldb_atsresp_errtype,   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC) 
    `ovm_field_int(cq_depth,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_depth_intr_thresh,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cq_timer_intr_ena,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cqqid_slotctrl,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_inflights,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_qid_inflights,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_aqed_limit,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_base_addr_ctl,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_base_addr_ctl,  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(palb_enable,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC) 
    `ovm_field_int(palb_period,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(palb_on_thrsh_min,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(palb_on_thrsh_max,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(palb_off_thrsh_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(palb_off_thrsh_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(msix_base_addr,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_addr_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_data_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hcw_pf_test_hqm_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(num_ldb_pp)
    `stimulus_config_field_rand_int(num_dir_pp)
    `stimulus_config_field_rand_int(enable_msix)
    `stimulus_config_field_rand_int(enable_ims_poll)
    `stimulus_config_field_rand_int(pad_first_write_dir)
    `stimulus_config_field_rand_int(pad_write_dir)
    `stimulus_config_field_rand_int(pad_first_write_ldb)
    `stimulus_config_field_rand_int(pad_write_ldb)
    `stimulus_config_field_rand_int(dir_cq2tc_map)
    `stimulus_config_field_rand_int(ldb_cq2tc_map)
    `stimulus_config_field_rand_int(int2tc_map)
    `stimulus_config_field_rand_int(wu_limit)
    `stimulus_config_field_rand_int(disable_wb_opt_cq)
    `stimulus_config_field_rand_int(early_dir_int)
    `stimulus_config_field_rand_int(write_single_beats)
    `stimulus_config_field_rand_int(sparse_cq_mode_dir)
    `stimulus_config_field_rand_int(sparse_cq_mode_ldb)
    `stimulus_config_field_rand_int(use_sequential_names)
    `stimulus_config_field_rand_int(enable_wdog_cq)
    `stimulus_config_field_rand_int(enable_cdc_ctrl)
    `stimulus_config_field_rand_int(enable_sys_its)
    `stimulus_config_field_rand_int(prochot_disable)
    `stimulus_config_field_rand_int(cq_hlexp_rnd)
    `stimulus_config_field_rand_int(cq_hlexp)
    `stimulus_config_field_rand_int(ldb_cq_inflights)
    `stimulus_config_field_rand_int(ldb_qid_inflights)
    `stimulus_config_field_rand_int(ldb_aqed_limit)
    `stimulus_config_field_rand_int(dir_cq_base_addr_ctl)
    `stimulus_config_field_rand_int(ldb_cq_base_addr_ctl)

    `stimulus_config_field_rand_int(dir_pp_rob_min)
    `stimulus_config_field_rand_int(dir_pp_rob_max)
    `stimulus_config_field_rand_int(ldb_pp_rob_min)
    `stimulus_config_field_rand_int(ldb_pp_rob_max)
    `stimulus_config_field_rand_int(ldb_qid_comp_code_min)
    `stimulus_config_field_rand_int(ldb_qid_comp_code_max)
    `stimulus_config_field_rand_int(ldb_prio0)
    `stimulus_config_field_rand_int(ldb_prio1)
    `stimulus_config_field_rand_int(ldb_prio2)
    `stimulus_config_field_rand_int(ldb_prio3)
    `stimulus_config_field_rand_int(ldb_prio4)
    `stimulus_config_field_rand_int(ldb_prio5)
    `stimulus_config_field_rand_int(ldb_prio6)
    `stimulus_config_field_rand_int(ldb_prio7)
    `stimulus_config_field_rand_int(ldb_sn_qid_v)
    `stimulus_config_field_rand_int(ldb_ao_qid_v)
    `stimulus_config_field_rand_int(cq_depth)
    `stimulus_config_field_rand_int(cq_depth_intr_thresh)
    `stimulus_config_field_rand_int(cq_timer_intr_ena)
    `stimulus_config_field_rand_int(ldb_cqqid_slotctrl)
    `stimulus_config_field_rand_int(palb_enable)
    `stimulus_config_field_rand_int(palb_period)
    `stimulus_config_field_rand_int(palb_on_thrsh_min)
    `stimulus_config_field_rand_int(palb_on_thrsh_max)
    `stimulus_config_field_rand_int(palb_off_thrsh_min)
    `stimulus_config_field_rand_int(palb_off_thrsh_max)
    `stimulus_config_field_rand_int(dir_atsresp_errtype)
    `stimulus_config_field_rand_int(ldb_atsresp_errtype)
    `stimulus_config_field_int(msix_base_addr)
    `stimulus_config_field_queue_int(msix_addr_q)
    `stimulus_config_field_queue_int(msix_data_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";

  rand  bit                     enable_msix;
  rand  bit                     enable_ims_poll;
  rand  bit                     pad_first_write_dir;
  rand  bit                     pad_write_dir;
  rand  bit                     pad_first_write_ldb;
  rand  bit                     pad_write_ldb;
  rand  int                     disable_wb_opt_cq;
  rand  int                     early_dir_int;
  rand  bit                     write_single_beats;
  rand  bit                     sparse_cq_mode_dir;
  rand  bit                     sparse_cq_mode_ldb;
  rand  bit                     use_sequential_names;
  rand  bit [15:0]              dir_cq2tc_map;
  rand  bit [15:0]              ldb_cq2tc_map;
  rand  bit [3:0]               int2tc_map;
  rand  int                     wu_limit;
  rand  int                     num_ldb_pp;
  rand  int                     num_dir_pp;
  rand  bit                     enable_wdog_cq;
  rand  bit                     enable_cdc_ctrl;
  rand  bit                     enable_sys_its;
  rand  bit                     prochot_disable;
  rand  bit                     cq_hlexp_rnd;
  rand  bit                     cq_hlexp;

  rand  bit                     dir_pp_rob_min;
  rand  bit                     dir_pp_rob_max;
  rand  bit                     ldb_pp_rob_min;
  rand  bit                     ldb_pp_rob_max;

  rand  bit [2:0]               ldb_qid_comp_code_min;
  rand  bit [2:0]               ldb_qid_comp_code_max;

  rand  bit [2:0]               ldb_prio0;
  rand  bit [2:0]               ldb_prio1;
  rand  bit [2:0]               ldb_prio2;
  rand  bit [2:0]               ldb_prio3;
  rand  bit [2:0]               ldb_prio4;
  rand  bit [2:0]               ldb_prio5;
  rand  bit [2:0]               ldb_prio6;
  rand  bit [2:0]               ldb_prio7;

  rand  int                     ldb_sn_qid_v;
  rand  int                     ldb_ao_qid_v;

  rand  int                     ldb_cqqid_slotctrl;
  rand  int                     cq_depth;
  rand  int                     cq_depth_intr_thresh;
  rand  int                     cq_timer_intr_ena;

  rand  int                     ldb_cq_inflights;
  rand  int                     ldb_qid_inflights;
  rand  int                     ldb_aqed_limit;
  rand  int                     dir_cq_base_addr_ctl;
  rand  int                     ldb_cq_base_addr_ctl;

  rand  bit                     palb_enable; 
  rand  bit [3:0]               palb_period;
  rand  bit [9:0]               palb_on_thrsh_min;
  rand  bit [9:0]               palb_on_thrsh_max;
  rand  bit [9:0]               palb_off_thrsh_min;
  rand  bit [9:0]               palb_off_thrsh_max;

  rand  int                     dir_atsresp_errtype;
  rand  int                     ldb_atsresp_errtype;

  bit [63:0]                    msix_base_addr = 64'h00000000_fee00000;

  bit [63:0]                    msix_addr_q[$];
  bit [31:0]                    msix_data_q[$];

  constraint c_write_single_beats {
      soft pad_write_dir       == 1;
      soft pad_write_ldb       == 1;
      soft pad_first_write_dir == 0;
      soft pad_first_write_ldb == 0;
      soft disable_wb_opt_cq   == -1;
      soft write_single_beats  == 1'b0;
      soft sparse_cq_mode_dir  == 0;
      soft sparse_cq_mode_ldb  == 0;
      soft use_sequential_names == 0;
      soft early_dir_int       == 0;
      soft cq_depth            == 1024;
      soft cq_depth_intr_thresh == 1;
      soft cq_timer_intr_ena == 1;
      soft enable_wdog_cq == 0;
      soft enable_cdc_ctrl == 0;
      soft enable_sys_its == 0;
      soft prochot_disable == 0;
      
      soft ldb_qid_comp_code_min == 0;
      soft ldb_qid_comp_code_max == 0;

      soft ldb_prio0       == 0;
      soft ldb_prio1       == 0;
      soft ldb_prio2       == 0;
      soft ldb_prio3       == 0;
      soft ldb_prio4       == 0;
      soft ldb_prio5       == 0;
      soft ldb_prio6       == 0;
      soft ldb_prio7       == 0;

      soft ldb_sn_qid_v    == 0;
      soft ldb_ao_qid_v    == 0;

      soft ldb_cqqid_slotctrl == 0;

      soft cq_hlexp_rnd == 0;
      soft cq_hlexp     == 0;
}

  constraint c_num_pp {
    num_ldb_pp                  >= 0;
    num_ldb_pp                  <= hqm_pkg::NUM_LDB_PP;
    num_ldb_pp                  <= hqm_pkg::NUM_LDB_QID;
    num_dir_pp                  >= 0;
    num_dir_pp                  <= hqm_pkg::NUM_DIR_PP;
    num_dir_pp                  <= hqm_pkg::NUM_DIR_QID;
    (num_ldb_pp + num_dir_pp)   >  0;
    (num_ldb_pp + num_dir_pp)   <= 160; //64;
  }

  constraint c_num_pp_soft {
    //--anyan_test soft num_ldb_pp     inside { 0,1,2,4,8 };
    //--anyan_test soft num_dir_pp     inside { 0,1,2,4,8 };
  }

  constraint c_wu_limit_soft {
    soft wu_limit       == -1;
  }

  constraint c_dir_pp_rob_soft {
    soft dir_pp_rob_min       == 0;
    soft dir_pp_rob_max       == 0;
  }

  constraint c_ldb_pp_rob_soft {
    soft ldb_pp_rob_min       == 0;
    soft ldb_pp_rob_max       == 0;
  }

  constraint c_palb_soft {
    soft palb_enable == 0; 
    soft palb_period == 8; 
    soft palb_on_thrsh_min == 64; 
    soft palb_on_thrsh_max == 64; 
    soft palb_off_thrsh_min == 64; 
    soft palb_off_thrsh_max == 64; 
  }

  constraint c_atsresp_errtype_soft {
    soft dir_atsresp_errtype == 0; 
    soft ldb_atsresp_errtype == 0; 
  }

  constraint c_inflights_soft {
    soft ldb_cq_inflights  == -1; 
    soft ldb_qid_inflights == -1; 
    soft ldb_aqed_limit    == -1; 
  }

  constraint c_cq_base_addr_ctl_soft {
    soft dir_cq_base_addr_ctl       == 0;
    soft ldb_cq_base_addr_ctl       == 0;
  }

  function new(string name = "hcw_pf_test_hqm_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_test_hqm_cfg_seq_stim_config

class hcw_pf_test_hqm_cfg_seq extends hqm_base_cfg_seq;
  `ovm_sequence_utils(hcw_pf_test_hqm_cfg_seq,sla_sequencer)

  rand hcw_pf_test_hqm_cfg_seq_stim_config       cfg;

  hqm_integ_seq_pkg::hcw_pf_test_enable_msix_cfg_seq    enable_msix_cfg_seq;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_test_hqm_cfg_seq_stim_config);
`endif

  //--cq_addr reprogramming
  int                           dir_cq_addr_ctrl;
  int                           ldb_cq_addr_ctrl;

  function new(string name = "hcw_pf_test_hqm_cfg_seq");
    super.new(name); 

    cfg = hcw_pf_test_hqm_cfg_seq_stim_config::type_id::create("hcw_pf_test_hqm_cfg_seq_stim_config");
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
    int         qid_avail[$];
    int         pp;
    int         qid;
    bit [hqm_pkg::NUM_DIR_CQ-1:0]       dir_cq_intr_armed;
    bit [hqm_pkg::NUM_LDB_CQ-1:0]       ldb_cq_intr_armed;
    hcw_pf_test_stim_dut_view           dut_view;
    bit [2:0]   qidix_tmp;
    int         cq_pick;
    bit         dir_cl_rob, ldb_cl_rob;
    bit         cq_hlexp;
    int         ldb_sn_qid_prog, ldb_ao_qid_prog;
    int         ord_mode_prog, ord_slot_prog, ord_grp_prog;


    bit [2:0]   ldb_prio[8];
    bit [2:0]   ldb_qid_comp_code;
    bit [9:0]   palb_on_thrsh; 
    bit [9:0]   palb_off_thrsh; 

    int         ldb_qid_inflight_val;
    int         ldb_aqed_limit_val;
    int         ldb_cq_inflights_val; 
    int         ldb_qid_sn_map_on; 

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    if (cfg.use_sequential_names) begin
      i_hqm_cfg.set_sequential_names(1);
    end

    dut_view = hcw_pf_test_stim_dut_view::instance(m_sequencer,inst_suffix);

    dut_view.num_dir_pp         = cfg.num_dir_pp;
    dut_view.num_ldb_pp         = cfg.num_ldb_pp;
    dut_view.enable_msix        = cfg.enable_msix;
    dut_view.enable_ims_poll    = cfg.enable_ims_poll;
    dut_view.enable_wdog_cq     = cfg.enable_wdog_cq;

    ldb_qid_sn_map_on = 0;
    
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

    ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("hcw_pf_test_hqm_cfg_seq: Starting PF Config with num_dir_pp=%0d num_ldb_pp=%0d enable_msix=%0d enable_ims_poll=%0d enable_wdog_cq=%0d dir_cq_addr_ctrl=%0d ldb_cq_addr_ctrl=%0d", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.enable_msix, dut_view.enable_ims_poll, dut_view.enable_wdog_cq, dir_cq_addr_ctrl, ldb_cq_addr_ctrl), OVM_NONE);

    if(cfg.enable_msix==1 && ((cfg.num_dir_pp + cfg.num_ldb_pp) >64)) begin
       cfg.enable_msix=0;
       dut_view.enable_msix=0; 
       ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("hcw_pf_test_hqm_cfg_seq: Starting PF Config with num_dir_pp=%0d num_ldb_pp=%0d; Change:enable_msix=%0d due to total pp number>64", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.enable_msix), OVM_NONE);

    end


    ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("hcw_pf_test_hqm_cfg_seq: Starting PF Config with ldb_sn_qid_v=%0d ldb_ao_qid_v=%0d ldb_cq_inflights=%0d ldb_qid_inflights=%0d ldb_aqed_limit=%0d", cfg.ldb_sn_qid_v, cfg.ldb_ao_qid_v, cfg.ldb_cq_inflights, cfg.ldb_qid_inflights, cfg.ldb_aqed_limit), OVM_NONE);

    //----------------------------------------------------------
    //TODO cfg_cmds.push_back("mem_update      # initialize memories to hqm_cfg defaults using backdoor access");

    ldb_prio[0] = cfg.ldb_prio0; 
    ldb_prio[1] = cfg.ldb_prio1; 
    ldb_prio[2] = cfg.ldb_prio2; 
    ldb_prio[3] = cfg.ldb_prio3; 
    ldb_prio[4] = cfg.ldb_prio4; 
    ldb_prio[5] = cfg.ldb_prio5; 
    ldb_prio[6] = cfg.ldb_prio6; 
    ldb_prio[7] = cfg.ldb_prio7; 
    cq_pick       = $urandom_range(0, (cfg.num_ldb_pp-1));

    cfg_cmds.push_back("cfg_begin");

    //----------------------------------------------------------
    for (int qid = 0 ; qid < cfg.num_dir_pp ; qid++) begin
      cfg_cmds.push_back($psprintf("dir qid DQ%0d:*",qid));
    end

    //----------------------------------------------------------
    for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
      ldb_qid_comp_code = $urandom_range(cfg.ldb_qid_comp_code_max, cfg.ldb_qid_comp_code_min);
      if(cfg.ldb_sn_qid_v==0)      ldb_sn_qid_prog=0;
      else if(cfg.ldb_sn_qid_v==1) ldb_sn_qid_prog=1;
      else begin
           if(qid==0) ldb_sn_qid_prog = 1;
      else                         ldb_sn_qid_prog=$urandom_range(0,1);
      end

      if(cfg.ldb_ao_qid_v==0)      ldb_ao_qid_prog=0;
      else if(cfg.ldb_ao_qid_v==1) ldb_ao_qid_prog=1;
      else begin
           if(qid==0) ldb_ao_qid_prog = 1;
      else                         ldb_ao_qid_prog=$urandom_range(0,1);
      end                         

      if(ldb_sn_qid_prog || ldb_ao_qid_prog) ldb_qid_sn_map_on = 1; //sticky

      if(cfg.num_ldb_pp<=4) begin
         ord_mode_prog=3; 
         ord_grp_prog = qid[1];
         ord_slot_prog= qid[0]; 
         ldb_cq_inflights_val=512;
      end else if(cfg.num_ldb_pp<=8) begin
         ord_mode_prog=2; 
         ord_grp_prog = qid[2];
         ord_slot_prog= qid[1:0]; 
         ldb_cq_inflights_val=256;
      end else if(cfg.num_ldb_pp<=16) begin
         ord_mode_prog=1; 
         ord_grp_prog = qid[3];
         ord_slot_prog= qid[2:0]; 
         ldb_cq_inflights_val=128;
      end else if(cfg.num_ldb_pp<=32) begin
         ord_mode_prog=0; 
         ord_grp_prog = qid[4];
         ord_slot_prog= qid[3:0]; 
         ldb_cq_inflights_val=64;
      end

      if(cfg.ldb_qid_inflights>0) begin
          ldb_qid_inflight_val = cfg.ldb_qid_inflights;
      end else if(ldb_qid_sn_map_on==1) begin
          ldb_qid_inflight_val = ldb_cq_inflights_val;
      end else begin
          ldb_qid_inflight_val = 2048/cfg.num_ldb_pp;
      end

      if(cfg.ldb_aqed_limit>0) begin
          ldb_aqed_limit_val   = cfg.ldb_aqed_limit;
      end else if(ldb_qid_sn_map_on==1) begin
          ldb_aqed_limit_val   = ldb_cq_inflights_val;
      end else begin
          ldb_aqed_limit_val   = 2048/cfg.num_ldb_pp;
      end
      ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("LDBQIDPROG:   cfg.ldb_qid_inflights=%0d ->  ldb_qid_inflight_val=%0d; cfg.ldb_aqed_limit=%0d -> ldb_aqed_limit_val=%0d", cfg.ldb_qid_inflights, ldb_qid_inflight_val, cfg.ldb_aqed_limit, ldb_aqed_limit_val), OVM_LOW);
      ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("LDBQIDCQPROG: ldb_sn_qid_prog=%0d ldb_ao_qid_prog=%0d ldb_qid_sn_map_on=%0d ord_mode_prog=%0d -> ldb_qid_inflight_val=%0d ldb_aqed_limit_val=%0d", ldb_sn_qid_prog, ldb_ao_qid_prog, ldb_qid_sn_map_on, ord_mode_prog, ldb_qid_inflight_val, ldb_aqed_limit_val), OVM_LOW);



      if(cfg.num_ldb_pp < hqm_pkg::NUM_LDB_QID) begin  
         //cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ao_cfg_v=0 qid_comp_code=%0d",qid,2048/cfg.num_ldb_pp,ldb_qid_comp_code));

           if(ldb_sn_qid_prog || ldb_ao_qid_prog) begin
              cfg_cmd=$psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1  qid_comp_code=%0d",qid,ldb_qid_inflight_val,ldb_qid_comp_code);
              cfg_cmd = {cfg_cmd,$psprintf(" aqed_freelist_base=%0d aqed_freelist_limit=%0d ", qid * ldb_aqed_limit_val, ((qid + 1) * (ldb_aqed_limit_val)) - 1)};
              cfg_cmd = {cfg_cmd,$psprintf(" ord_mode=%0d ord_slot=%0d ord_grp=%0d sn_cfg_v=1 ", ord_mode_prog,ord_slot_prog,ord_grp_prog)};
              cfg_cmd = {cfg_cmd,$psprintf(" ao_cfg_v=%0d  ", ldb_ao_qid_prog)};

              ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PROG_CFG_CMD_LDB_QID[%0d] cfg_cmd=%0s", qid, cfg_cmd), OVM_LOW);
              cfg_cmds.push_back(cfg_cmd);
           end else begin
              cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ao_cfg_v=0 qid_comp_code=%0d",qid,ldb_qid_inflight_val,ldb_qid_comp_code));
              ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PROG_CFG_CMD_LDB_QID[%0d] cfg_cmd=%0s", qid, cfg_cmd), OVM_LOW);
           end
      end else begin
        if(qid < hqm_pkg::NUM_LDB_QID) begin
           if(ldb_sn_qid_prog || ldb_ao_qid_prog) begin
              cfg_cmd=$psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1  qid_comp_code=%0d",qid,ldb_qid_inflight_val,ldb_qid_comp_code);
              cfg_cmd = {cfg_cmd,$psprintf(" aqed_freelist_base=%0d aqed_freelist_limit=%0d ", qid * (ldb_aqed_limit_val),((qid + 1) * (ldb_aqed_limit_val)) - 1)};
              cfg_cmd = {cfg_cmd,$psprintf(" ord_mode=%0d ord_slot=%0d ord_grp=%0d sn_cfg_v=1 ", ord_mode_prog,ord_slot_prog,ord_grp_prog)};
              cfg_cmd = {cfg_cmd,$psprintf(" ao_cfg_v=%0d  ", ldb_ao_qid_prog)};

              ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PROG_CFG_CMD_LDB_QID[%0d] cfg_cmd=%0s", qid, cfg_cmd), OVM_LOW);
              cfg_cmds.push_back(cfg_cmd);
           end else begin
              cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1 ao_cfg_v=0 qid_comp_code=%0d",qid,ldb_qid_inflight_val,ldb_qid_comp_code));
              ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PROG_CFG_CMD_LDB_QID[%0d] cfg_cmd=%0s", qid, cfg_cmd), OVM_LOW);
           end
        end
      end
    end

    cfg_cmd = "vas VAS0:* credit_cnt=16384 ";

    for (int qid = 0 ; qid < cfg.num_dir_pp ; qid++) begin
      cfg_cmd = {cfg_cmd,$psprintf("dir_qidv:DQ%0d=1 ",qid)};
    end

    for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
      if(cfg.num_ldb_pp < hqm_pkg::NUM_LDB_QID) begin  
         cfg_cmd = {cfg_cmd,$psprintf("ldb_qidv:LQ%0d=1 ",qid)};
      end else begin
        if(qid < hqm_pkg::NUM_LDB_QID) begin
          cfg_cmd = {cfg_cmd,$psprintf("ldb_qidv:LQ%0d=1 ",qid)};
        end
      end
    end

    cfg_cmds.push_back(cfg_cmd);

    //----------------------------------------------------------
    if($test$plusargs("ATS_4KPAGE_ONLY")) begin
        if(cfg.cq_depth>256) cfg.cq_depth=256;
    end


    //----------------------------------------------------------
    for (int pp = 0 ; pp < cfg.num_dir_pp ; pp++) begin
      dir_cl_rob = $urandom_range(cfg.dir_pp_rob_min, cfg.dir_pp_rob_max);
      if(dir_cl_rob) begin
         cfg_cmds.push_back($psprintf("dir pp DQ%0d vas=VAS0 rob=%0d",pp, dir_cl_rob));
      end else begin
         cfg_cmds.push_back($psprintf("dir pp DQ%0d vas=VAS0",pp));
      end

      if(cfg.enable_ims_poll)
         if(dir_cq_addr_ctrl==0) begin
         cfg_cmds.push_back($psprintf("dir cq DQ%0d single_hcw_per_cl=%0d cq_depth=%0d gpa=sm cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=[0x400000:0x4fffff,0x455555,0x4aaaaa] ats_resp_errinj=%0d ",pp,cfg.sparse_cq_mode_dir,cfg.cq_depth,cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq, cfg.dir_atsresp_errtype));
         end else begin
            //--skip gpa=sm when dir_cq_addr_ctrl=1 (traffic seq will program cq_gpa/cq_hpa/cq_pagesize/pasid)
            cfg_cmds.push_back($psprintf("dir cq DQ%0d single_hcw_per_cl=%0d cq_depth=%0d  cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=[0x400000:0x4fffff,0x455555,0x4aaaaa] ats_resp_errinj=%0d ",pp,cfg.sparse_cq_mode_dir,cfg.cq_depth,cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq, cfg.dir_atsresp_errtype));
         end
      else  begin
         //--HQMV25: pasid rnd -- cfg_cmds.push_back($psprintf("dir cq DQ%0d single_hcw_per_cl=%0d cq_depth=%0d gpa=sm cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=[0x400000,0x4fffff,0x455555,0x4aaaaa,0x000000:0x4fffff]",pp,cfg.sparse_cq_mode_dir,cfg.cq_depth,cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq));
         //--HQMV30: pasid programming set to pasid=0, because HQM DUT running with PF mode, the SCHED QE pasid is 0
         if(dir_cq_addr_ctrl==0) begin
         cfg_cmds.push_back($psprintf("dir cq DQ%0d single_hcw_per_cl=%0d cq_depth=%0d gpa=sm cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=0 ats_resp_errinj=%0d ",pp,cfg.sparse_cq_mode_dir,cfg.cq_depth,cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq, cfg.dir_atsresp_errtype));
         end else begin
            //--skip gpa=sm when dir_cq_addr_ctrl=1 (traffic seq will program cq_gpa/cq_hpa/cq_pagesize/pasid)
            cfg_cmds.push_back($psprintf("dir cq DQ%0d single_hcw_per_cl=%0d cq_depth=%0d  cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=0 ats_resp_errinj=%0d ",pp,cfg.sparse_cq_mode_dir,cfg.cq_depth,cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq, cfg.dir_atsresp_errtype));
         end 
      end
    end

    for (int pp = 0 ; pp < cfg.num_ldb_pp ; pp++) begin
      ldb_cl_rob = $urandom_range(cfg.ldb_pp_rob_min, cfg.ldb_pp_rob_max);
      if(ldb_cl_rob) begin
         cfg_cmds.push_back($psprintf("ldb pp LPP%0d:* vas=VAS0 rob=%0d",pp, ldb_cl_rob));
      end else begin
         cfg_cmds.push_back($psprintf("ldb pp LPP%0d:* vas=VAS0",pp));
      end
      if(ldb_cq_addr_ctrl==0) begin
      cfg_cmd = $psprintf("ldb cq LPP%0d single_hcw_per_cl=%0d cq_depth=%0d gpa=sm ",pp,cfg.sparse_cq_mode_ldb,cfg.sparse_cq_mode_ldb ? 256 : cfg.cq_depth);
      end else begin
         //--skip gpa=sm when ldb_cq_addr_ctrl=1 (traffic seq will program cq_gpa/cq_hpa/cq_pagesize/pasid)
         cfg_cmd = $psprintf("ldb cq LPP%0d single_hcw_per_cl=%0d cq_depth=%0d  ",pp,cfg.sparse_cq_mode_ldb,cfg.sparse_cq_mode_ldb ? 256 : cfg.cq_depth);
      end

      if(cfg.enable_ims_poll)
         cfg_cmd = {cfg_cmd,$psprintf("cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=[0x400000:0x4fffff,0x455555,0x4aaaaa] ats_resp_errinj=%0d ",cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq, cfg.ldb_atsresp_errtype)};
      else begin
         //--HQMV25: pasid rnd -- cfg_cmd = {cfg_cmd,$psprintf("cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=[0x4fffff,0x455555,0x4aaaaa,0x000000:0x4fffff] ",cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq)};
         //--HQMV30: pasid programming set to pasid=0, because HQM DUT running with PF mode, the SCHED QE pasid is 0
         cfg_cmd = {cfg_cmd,$psprintf("cq_timer_intr_thresh=2 cq_timer_intr_ena=%0d cq_depth_intr_thresh=%0d cq_depth_intr_ena=1 cq_cwdt_intr_ena=%0d pasid=0 ats_resp_errinj=%0d ",cfg.cq_timer_intr_ena,cfg.cq_depth_intr_thresh,cfg.enable_wdog_cq, cfg.ldb_atsresp_errtype)};
      end
      
      cq_hlexp = (cfg.cq_hlexp_rnd)? ($urandom_range(0,1)) : cfg.cq_hlexp;

      ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("LDBCQPROG: ldb_qid_sn_map_on=%0d ord_mode_prog=%0d -> ldb_cq_inflights_val=%0d ", ldb_qid_sn_map_on, ord_mode_prog, ldb_cq_inflights_val), OVM_LOW);
      ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("LDBCQPROG: cfg.ldb_cq_inflights=%0d ", cfg.ldb_cq_inflights), OVM_LOW);
      if(cfg.ldb_cq_inflights > 0) begin
         cfg_cmd = {cfg_cmd,$psprintf("cq_hl_exp_mode=%0d hist_list_base=%0d hist_list_limit=%0d ", cq_hlexp,  pp * (cfg.ldb_cq_inflights), ((pp + 1) * (cfg.ldb_cq_inflights)) - 1) };
      //end else if(ldb_qid_sn_map_on==1) begin
      //   //--LDB QID has ord_mode programmed, to aligned with sn/qid 
      //   cfg_cmd = {cfg_cmd,$psprintf("cq_hl_exp_mode=%0d hist_list_base=%0d hist_list_limit=%0d ", cq_hlexp,  pp * (ldb_cq_inflights_val), ((pp + 1) * (ldb_cq_inflights_val)) - 1) };
      end else begin
         cfg_cmd = {cfg_cmd,$psprintf("cq_hl_exp_mode=%0d hist_list_base=%0d hist_list_limit=%0d ", cq_hlexp,  pp * (2048/cfg.num_ldb_pp), ((pp + 1) * (2048/cfg.num_ldb_pp)) - 1) };
      end 

      palb_on_thrsh  = $urandom_range(cfg.palb_on_thrsh_min,  cfg.palb_on_thrsh_max);
      palb_off_thrsh = $urandom_range(cfg.palb_off_thrsh_min, cfg.palb_off_thrsh_max);
      cfg_cmd = {cfg_cmd,$psprintf("palb_on_thrsh=%0d palb_off_thrsh=%0d  ", palb_on_thrsh, palb_off_thrsh)};
 
      if (cfg.wu_limit >= 0) begin
        if (cfg.wu_limit <= hqm_pkg::NUM_CREDITS) begin
          cfg_cmd = {cfg_cmd,$psprintf("wu_limit=%0d ",cfg.wu_limit)};
        end else begin
          `ovm_error(get_full_name(),$psprintf("wu_limit=%0d exceeds maximum value of value of %0d",cfg.wu_limit,hqm_pkg::NUM_CREDITS))
        end
      end
      if(pp==cq_pick) begin
          cfg_cmd = {cfg_cmd,$psprintf(" lsp_ldb_wrr_count_cq=LPP%0d ", cq_pick)};
      end
      qid_avail.delete();


      if (cfg.ldb_cqqid_slotctrl==1) begin
        //----------------------------------------------------------
        //-- qid  
        //----------------------------------------------------------
        for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
            qid_avail.push_back(qid);
        end

        for (int qidix = 0 ; qidix < 8  ; qidix++) begin
          if (qid_avail.size() > 0) begin
            int lqid;
            int qid_index;

            qid_index = 0; 
            lqid = qid_avail[qid_index];
            qid_avail.delete(qid_index);
            cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d pri%0d=%0d ",qidix,qidix,lqid, qidix, ldb_prio[qidix])};
          end
        end
      end else if (cfg.ldb_cqqid_slotctrl==2) begin
        //----------------------------------------------------------
        //--rotating prio mappting
        //----------------------------------------------------------
        for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
            qid_avail.push_back(qid);
        end

        for (int qidix = 0 ; qidix < 8  ; qidix++) begin
          if (qid_avail.size() > 0) begin
            int lqid;
            int qid_index;

            qid_index = 0; 
            lqid = qid_avail[qid_index];
            qid_avail.delete(qid_index);
            qidix_tmp=pp+qidix;
            cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d pri%0d=%0d ",qidix,qidix,lqid, qidix, ldb_prio[qidix_tmp])};
          end
        end
      end else if (cfg.ldb_cqqid_slotctrl==3) begin
        //----------------------------------------------------------
        //--prio assigned to the same CQ are same
        //----------------------------------------------------------
        for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
            qid_avail.push_back(qid);
        end

        for (int qidix = 0 ; qidix < 8  ; qidix++) begin
          if (qid_avail.size() > 0) begin
            int lqid;
            int qid_index;

            qid_index = 0; 
            lqid = qid_avail[qid_index];
            qid_avail.delete(qid_index);
            qidix_tmp=pp;
            cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d pri%0d=%0d ",qidix,qidix,lqid, qidix, ldb_prio[qidix_tmp])};
          end
        end
      end else if (cfg.ldb_cqqid_slotctrl==4) begin
        //----------------------------------------------------------
        //--one-slot taken, one QID is assigned to one CQ
        //----------------------------------------------------------
            cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d pri%0d=%0d ", 0, 0, pp, 0, ldb_prio[pp])};
      end else if (cfg.ldb_cqqid_slotctrl==5) begin
        //----------------------------------------------------------
        //-- two-slot taken, 
        //----------------------------------------------------------
        //-- two-slot taken, 
        //-- CQ0 one slot prio0, one slot prio2
        //-- CQ1 one slot prio2, one slot prio0
        //-- CQ2 one slot prio0, one slot prio2
        //-- CQ3 one slot prio2, one slot prio0
        for (int qid = 0 ; qid < 2 ; qid++) begin
           if(pp==0 ||pp==1)
            qid_avail.push_back(qid);
           else
            qid_avail.push_back(qid+2);
        end

        for (int qidix = 0 ; qidix < 2  ; qidix++) begin
          if (qid_avail.size() > 0) begin
            int lqid;
            int qid_index;

            qid_index = 0; 
            lqid = qid_avail[qid_index];
            qid_avail.delete(qid_index);
            qidix_tmp=pp*2+qidix;
            cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d pri%0d=%0d ",qidix,qidix,lqid, qidix, ldb_prio[qidix_tmp])};
            //ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("LDB_CQQIDPRIO_qidix%0d:qidix_tmp=%0d:  cfg_cmd=%0s", qidix, qidix_tmp, cfg_cmd), OVM_LOW);
          end
        end

      end else begin
        //----------------------------------------------------------
        //-- regular  
        //----------------------------------------------------------
        if(cfg.num_ldb_pp < hqm_pkg::NUM_LDB_QID) begin  
           for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
             if (qid != pp) begin
               qid_avail.push_back(qid);
             end
           end
           cfg_cmd = {cfg_cmd,$psprintf("qidv0=1 qidix0=LQ%0d pri0=%0d ",pp, ldb_prio[0])};

           if(!$test$plusargs("HQM_CFG_USE_QIDSLOT_0")) begin
              for (int qidix = 1 ; qidix < 8  ; qidix++) begin
                if (qid_avail.size() > 0) begin
                  int lqid;
                  int qid_index;

                  qid_index = $urandom_range(qid_avail.size() - 1, 0);
                  lqid = qid_avail[qid_index];
                  qid_avail.delete(qid_index);
                  cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d pri%0d=%0d ",qidix,qidix,lqid, qidix, ldb_prio[qidix])};
                end
              end
           end

        end else begin
           if(pp < hqm_pkg::NUM_LDB_QID) begin 
              cfg_cmd = {cfg_cmd,$psprintf("qidv0=1 qidix0=LQ%0d pri0=%0d ",pp, ldb_prio[0])};
           end else begin
              cfg_cmd = {cfg_cmd,$psprintf("qidv0=1 qidix0=LQ%0d pri0=%0d ",(pp - hqm_pkg::NUM_LDB_QID), ldb_prio[0])};
           end
           ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("LDB_CQQIDPRIO_CQ[%0d] cfg_cmd=%0s", pp, cfg_cmd), OVM_LOW);
        end
      end 

      //----------------

      cfg_cmds.push_back(cfg_cmd);
    end

    cfg_cmds.push_back($psprintf("cfg_pad_write_dir %0d", cfg.pad_write_dir));
    cfg_cmds.push_back($psprintf("cfg_pad_write_ldb %0d", cfg.pad_write_ldb));

    cfg_cmds.push_back($psprintf("cfg_pad_first_write_dir %0d", cfg.pad_first_write_dir));
    cfg_cmds.push_back($psprintf("cfg_pad_first_write_ldb %0d", cfg.pad_first_write_ldb));

    if (cfg.disable_wb_opt_cq != -1) begin
        cfg_cmds.push_back($psprintf("dir cq DQ%0d disable_wb_opt=1", cfg.disable_wb_opt_cq));
    end

    cfg_cmds.push_back($psprintf("wr hqm_system_csr.write_buffer_ctl.write_single_beats %0d", cfg.write_single_beats));
    cfg_cmds.push_back($psprintf("cfg_early_dir_int %0d", cfg.early_dir_int));

    for (int i = 0; i < hqm_pkg::NUM_DIR_PP; i++) begin
      
      bit exp_ingress_err;
      
      if ( $value$plusargs({$psprintf("DIR_PP%0d_INGRESS_ERR", i),"=%d"}, exp_ingress_err) ) begin
        cfg_cmds.push_back($psprintf("dir pp DQ%0d exp_ill_hcw_cmd=%0d", i, exp_ingress_err));
      end
    end

    for (int i = 0; i < hqm_pkg::NUM_LDB_PP; i++) begin
      
      bit exp_ingress_err;
      
      if ( $value$plusargs({$psprintf("LDB_PP%0d_INGRESS_ERR", i),"=%d"}, exp_ingress_err) ) begin
        cfg_cmds.push_back($psprintf("ldb pp LPP%0d exp_ill_hcw_cmd=%0d", i, exp_ingress_err));
      end
    end

    cfg_cmds.push_back($psprintf("wr hqm_sif_csr.dir_cq2tc_map 0x%0x",cfg.dir_cq2tc_map));
    cfg_cmds.push_back($psprintf("wr hqm_sif_csr.ldb_cq2tc_map 0x%0x",cfg.ldb_cq2tc_map));
    cfg_cmds.push_back($psprintf("wr hqm_sif_csr.int2tc_map 0x%0x",cfg.int2tc_map));

    cfg_cmds.push_back("cfg_end");

    cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");

    cfg_cmds.push_back("idle 100");

    cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable 0xffffffff");
    cfg_cmds.push_back("rd hqm_system_csr.ingress_alarm_enable 0x0000003f");
    
    if (cfg.prochot_disable) begin
      cfg_cmds.push_back("wr config_master.cfg_control_general.CFG_PROCHOT_DISABLE 1");
      ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PROCHOT_DISABLED: config_master.cfg_control_general.CFG_PROCHOT_DISABLE=1"), OVM_LOW);
    end

    if (cfg.enable_cdc_ctrl) begin
      cfg_cmds.push_back("rd config_master.cfg_hqm_cdc_control");
      cfg_cmds.push_back("rd config_master.cfg_control_general");
      cfg_cmds.push_back("idle 100");
      cfg_cmds.push_back("wr config_master.cfg_hqm_cdc_control.clkgate_disabled 1");
      cfg_cmds.push_back("wr config_master.cfg_control_general.cfg_enable_unit_idle 0");
      cfg_cmds.push_back("wr hqm_system_csr.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr list_sel_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr atm_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr aqed_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr direct_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr nalb_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr qed_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("wr reorder_pipe.cfg_patch_control.DISABLE_CLOCKOFF 1");
      cfg_cmds.push_back("idle 100");
    end

    if (cfg.enable_sys_its) begin
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[0].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[1].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[2].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[3].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[4].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[5].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[6].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[7].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[8].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[9].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[10].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[11].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[12].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[13].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[14].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[15].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[16].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[17].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[18].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[19].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[20].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[21].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[22].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[23].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[24].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[25].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[26].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[27].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[28].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[29].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[30].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.ldb_qid_its[31].qid_its 1");

      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[0].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[1].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[2].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[3].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[4].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[5].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[6].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[7].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[8].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[9].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[10].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[11].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[12].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[13].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[14].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[15].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[16].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[17].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[18].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[19].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[20].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[21].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[22].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[23].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[24].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[25].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[26].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[27].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[28].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[29].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[30].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[31].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[32].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[33].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[34].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[35].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[36].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[37].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[38].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[39].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[40].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[41].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[42].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[43].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[44].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[45].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[46].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[47].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[48].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[49].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[50].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[51].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[52].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[53].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[54].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[55].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[56].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[57].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[58].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[59].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[60].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[61].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[62].qid_its 1");
      cfg_cmds.push_back("wr hqm_system_csr.dir_qid_its[63].qid_its 1");
    end

    if (cfg.enable_wdog_cq) begin
      cfg_cmds.push_back("wr hqm_msix_mem.vector_ctrl[0].vec_mask 0");
      cfg_cmds.push_back("wr hqm_msix_mem.msg_addr_l[0] 0xbbbbbbb8");
      cfg_cmds.push_back("wr hqm_msix_mem.msg_addr_u[0] 0");
      cfg_cmds.push_back("wr hqm_msix_mem.msg_data[0] 0xc0de55aa");

      cfg_cmds.push_back("wr credit_hist_pipe.cfg_dir_wd_enb_interval.enb 1");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_dir_wd_enb_interval.sample_interval 2");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_dir_wd_threshold 5");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_dir_wd_disable0 0xffffffff");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_dir_wd_disable1 0xffffffff");

      cfg_cmds.push_back("wr credit_hist_pipe.cfg_ldb_wd_enb_interval.enb 1");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_ldb_wd_enb_interval.sample_interval 2");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_ldb_wd_threshold 5");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_ldb_wd_disable0 0xffffffff");
      cfg_cmds.push_back("wr credit_hist_pipe.cfg_ldb_wd_disable1 0xffffffff");
    end


    if (cfg.palb_enable) begin
      ovm_report_info("hcw_pf_test_hqm_cfg_seq", $psprintf("PALB_ENABLE: cfg.palb_period=0x%0x", cfg.palb_period), OVM_LOW);
      cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_chp_palb_control.PALB_ENABLE %0d", cfg.palb_enable));
      cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_chp_palb_control.PALB_PERIOD %0d", cfg.palb_period));
    end


    super.body();

    if (cfg.enable_msix || cfg.enable_ims_poll) begin
      `ovm_create(enable_msix_cfg_seq)
      enable_msix_cfg_seq.inst_suffix = inst_suffix;
      enable_msix_cfg_seq.cfg.msix_base_addr      = cfg.msix_base_addr;
      enable_msix_cfg_seq.cfg.msix_addr_q         = cfg.msix_addr_q;
      enable_msix_cfg_seq.cfg.msix_data_q         = cfg.msix_data_q;
      `ovm_rand_send(enable_msix_cfg_seq)
    end
  endtask
endclass : hcw_pf_test_hqm_cfg_seq
