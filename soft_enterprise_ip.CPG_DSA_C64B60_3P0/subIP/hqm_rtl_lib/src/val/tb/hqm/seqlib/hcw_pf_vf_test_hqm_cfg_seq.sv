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
// File   : hcw_pf_vf_test_hqm_cfg_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_pf_vf_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hcw_pf_vf_test_hqm_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_pf_vf_test_hqm_cfg_seq_stim_config";

  `ovm_object_utils_begin(hcw_pf_vf_test_hqm_cfg_seq_stim_config)
    `ovm_field_string(tb_env_hier,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_ldb_pp,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_dir_pp,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_vf,                  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_vf_ldb_pp,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_vf_dir_pp,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_msi,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_msix,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(enable_ims_poll,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_write_dir,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_write_ldb,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_first_write_dir, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cfg_pad_first_write_ldb, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(disable_wb_opt_cq,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(write_single_beats,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(use_sequential_names,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(early_dir_int,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_depth,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_depth,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(msix_base_addr,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_addr_q,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_data_q,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(vf_msi_base_addr,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(vf_msi_multi_msg_set,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(vf_msi_multi_msg_en_q,   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(vf_msi_addr_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(vf_msi_data_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hcw_pf_vf_test_hqm_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(num_ldb_pp)
    `stimulus_config_field_rand_int(num_dir_pp)
    `stimulus_config_field_rand_int(num_vf)
    `stimulus_config_field_rand_int(num_vf_ldb_pp)
    `stimulus_config_field_rand_int(num_vf_dir_pp)
    `stimulus_config_field_rand_int(enable_msi)
    `stimulus_config_field_rand_int(enable_msix)
    `stimulus_config_field_rand_int(enable_ims_poll)
    `stimulus_config_field_rand_int(cfg_pad_write_dir)
    `stimulus_config_field_rand_int(cfg_pad_write_ldb)
    `stimulus_config_field_rand_int(cfg_pad_first_write_dir)
    `stimulus_config_field_rand_int(cfg_pad_first_write_ldb)
    `stimulus_config_field_rand_int(disable_wb_opt_cq)
    `stimulus_config_field_rand_int(write_single_beats)
    `stimulus_config_field_rand_int(use_sequential_names)
    `stimulus_config_field_rand_int(early_dir_int)
    `stimulus_config_field_rand_int(dir_cq_depth)
    `stimulus_config_field_rand_int(ldb_cq_depth)
    `stimulus_config_field_int(msix_base_addr)
    `stimulus_config_field_queue_int(msix_addr_q)
    `stimulus_config_field_queue_int(msix_data_q)
    `stimulus_config_field_int(vf_msi_base_addr)
    `stimulus_config_field_int(vf_msi_multi_msg_set)
    `stimulus_config_field_queue_int(vf_msi_multi_msg_en_q)
    `stimulus_config_field_queue_int(vf_msi_addr_q)
    `stimulus_config_field_queue_int(vf_msi_data_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";

  rand  int                     num_vf;
  rand  int                     num_vf_ldb_pp;
  rand  int                     num_vf_dir_pp;
  rand  int                     num_ldb_pp;
  rand  int                     num_dir_pp;
  rand  bit                     enable_msi;
  rand  bit                     enable_msix;
  rand  bit                     enable_ims_poll;
  rand  bit                     cfg_pad_write_dir;
  rand  bit                     cfg_pad_write_ldb;
  rand  bit                     cfg_pad_first_write_dir;
  rand  bit                     cfg_pad_first_write_ldb;
  rand  int                     disable_wb_opt_cq;
  rand  int                     early_dir_int;
  rand  int                     dir_cq_depth;
  rand  int                     ldb_cq_depth;
  rand  bit                     write_single_beats;
  rand  bit                     use_sequential_names;

  bit [63:0]                    msix_base_addr = 64'h00000000_eef00000;

  bit [63:0]                    msix_addr_q[$];
  bit [31:0]                    msix_data_q[$];

  bit [63:0]                    vf_msi_base_addr = 64'h00000000_fee00000;

  bit [2:0]                     vf_msi_multi_msg_set = 5;
  bit [2:0]                     vf_msi_multi_msg_en_q[$];

  bit [63:0]                    vf_msi_addr_q[$];
  bit [31:0]                    vf_msi_data_q[$];

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

  constraint c_num_pp {
    num_ldb_pp                  >= 0;
    num_ldb_pp                  <= hqm_pkg::NUM_LDB_PP;
    num_ldb_pp                  <= hqm_pkg::NUM_LDB_QID;
    num_dir_pp                  >= 0;
    num_dir_pp                  <= hqm_pkg::NUM_DIR_PP;
    num_dir_pp                  <= hqm_pkg::NUM_DIR_QID;
    (num_ldb_pp + num_dir_pp)   >  0;
    (num_ldb_pp + num_dir_pp)   <= 64;
  }

  constraint c_cq_depth {
    dir_cq_depth        inside {  4, 8, 16, 32, 64, 128, 256, 512, 1024 };
    ldb_cq_depth        inside {  4, 8, 16, 32, 64, 128, 256, 512, 1024 };
  }

  constraint c_cq_depth_soft {
    dir_cq_depth        inside {  1024 };
    ldb_cq_depth        inside {  1024 };
  }

  constraint c_num_pp_soft {
    soft num_ldb_pp     inside { 0,1,2,4,8 };
    soft num_dir_pp     inside { 0,1,2,4,8 };
  }

  constraint c_num_vf_pp {
    solve num_ldb_pp before num_vf_ldb_pp;
    solve num_dir_pp before num_vf_ldb_pp;
    solve num_ldb_pp before num_vf_dir_pp;
    solve num_dir_pp before num_vf_dir_pp;

    num_vf_ldb_pp               >= 0;
    num_vf_ldb_pp               <= num_ldb_pp;
    num_vf_dir_pp               >= 0;
    num_vf_dir_pp               <= num_dir_pp;
  }

  constraint c_num_vf {
    solve num_vf_ldb_pp before num_vf;
    solve num_vf_dir_pp before num_vf;

    num_vf                      >= 1;
    num_vf                      <= 16;
    num_vf                      <= num_vf_dir_pp;
    num_vf                      <= num_vf_ldb_pp;

    (num_vf * 31)               >= (num_vf_dir_pp + num_vf_ldb_pp);
  }

  function new(string name = "hcw_pf_vf_test_hqm_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_vf_test_hqm_cfg_seq_stim_config

class hcw_pf_vf_test_hqm_cfg_seq extends hqm_base_cfg_seq;
  `ovm_sequence_utils(hcw_pf_vf_test_hqm_cfg_seq,sla_sequencer)

  rand hcw_pf_vf_test_hqm_cfg_seq_stim_config       cfg;

  hqm_integ_seq_pkg::hcw_pf_vf_test_enable_int_cfg_seq     enable_int_cfg_seq;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_vf_test_hqm_cfg_seq_stim_config);
`endif

  function new(string name = "hcw_pf_vf_test_hqm_cfg_seq");
    super.new(name); 

    cfg = hcw_pf_vf_test_hqm_cfg_seq_stim_config::type_id::create("hcw_pf_vf_test_hqm_cfg_seq_stim_config");
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
    int         dir_vpp_avail[$];
    int         ldb_vpp_avail[$];
    int         ldb_vqid_avail[$];
    int         lqid_avail[$];
    int         vpp_index;
    int         vpp;
    int         vqid_index;
    int         vqid;
    int         pp;
    int         qid;
    bit [hqm_pkg::NUM_DIR_CQ-1:0]       dir_cq_intr_armed;
    bit [hqm_pkg::NUM_LDB_CQ-1:0]       ldb_cq_intr_armed;
    int         dir_pp_for_pf;
    int         ldb_pp_for_pf;
    int         dir_pp_per_vf;
    int         ldb_pp_per_vf;
    hcw_pf_vf_test_stim_dut_view           dut_view;

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    if (cfg.use_sequential_names) begin
      i_hqm_cfg.set_sequential_names(1);
    end

    dut_view = hcw_pf_vf_test_stim_dut_view::instance(m_sequencer,inst_suffix);

    dut_view.num_dir_pp         = cfg.num_dir_pp;
    dut_view.num_ldb_pp         = cfg.num_ldb_pp;
    dut_view.num_vf             = cfg.num_vf;
    dut_view.num_vf_dir_pp      = cfg.num_vf_dir_pp;
    dut_view.num_vf_ldb_pp      = cfg.num_vf_ldb_pp;
    dut_view.enable_msi         = cfg.enable_msi;
    dut_view.enable_msix        = cfg.enable_msix;
    dut_view.enable_ims_poll    = cfg.enable_ims_poll;

    dir_pp_for_pf = cfg.num_dir_pp - cfg.num_vf_dir_pp;
    ldb_pp_for_pf = cfg.num_ldb_pp - cfg.num_vf_ldb_pp;

    dir_pp_per_vf = (cfg.num_vf_dir_pp + cfg.num_vf - 1) / cfg.num_vf;
    ldb_pp_per_vf = (cfg.num_vf_ldb_pp + cfg.num_vf - 1) / cfg.num_vf;

    //TODO  cfg_cmds.push_back("mem_update      # initialize memories to hqm_cfg defaults using backdoor access");

    cfg_cmds.push_back("cfg_begin");

    for (int qid = 0 ; qid < cfg.num_dir_pp ; qid++) begin
      cfg_cmds.push_back($psprintf("dir qid DQ%0d:*",qid));
    end

    for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
      cfg_cmds.push_back($psprintf("ldb qid LQ%0d:* qid_ldb_inflight_limit=%0d fid_cfg_v=1",qid,2048/cfg.num_ldb_pp));
    end

    cfg_cmd = "vas VAS0:* credit_cnt=16384 ";

    for (int qid = 0 ; qid < cfg.num_dir_pp ; qid++) begin
      cfg_cmd = {cfg_cmd,$psprintf("dir_qidv:DQ%0d=1 ",qid)};
    end

    for (int qid = 0 ; qid < cfg.num_ldb_pp ; qid++) begin
      cfg_cmd = {cfg_cmd,$psprintf("ldb_qidv:LQ%0d=1 ",qid)};
    end

    cfg_cmds.push_back(cfg_cmd);

    for (int pp = 0 ; pp < cfg.num_dir_pp ; pp++) begin
      cfg_cmds.push_back($psprintf("dir pp DQ%0d vas=VAS0",pp));
      cfg_cmds.push_back($psprintf("dir cq DQ%0d cq_depth=%0d cq_timer_intr_thresh=2 cq_timer_intr_ena=1 cq_depth_intr_thresh=1 cq_depth_intr_ena=1 pasid=[0x400000,0x4fffff,0x455555,0x4aaaaa,0x000000:0x4fffff]",pp,cfg.dir_cq_depth));
    end

    for (int pp = 0 ; pp < cfg.num_ldb_pp ; pp++) begin
      cfg_cmds.push_back($psprintf("ldb pp LPP%0d:* vas=VAS0",pp));
      cfg_cmd = $psprintf("ldb cq LPP%0d cq_depth=%0d ",pp,cfg.ldb_cq_depth);
      cfg_cmd = {cfg_cmd,"cq_timer_intr_thresh=2 cq_timer_intr_ena=1 cq_depth_intr_thresh=1 cq_depth_intr_ena=1 pasid=[0x4fffff,0x455555,0x4aaaaa,0x000000:0x4fffff] "};
      cfg_cmd = {cfg_cmd,$psprintf("hist_list_base=%0d hist_list_limit=%0d ",pp * (2048/cfg.num_ldb_pp),((pp + 1) * (2048/cfg.num_ldb_pp)) - 1)};

      lqid_avail.delete();
      if (pp < cfg.num_vf_ldb_pp) begin
        for (int qid = ((pp/ldb_pp_per_vf) * ldb_pp_per_vf) ; (qid < (((pp/ldb_pp_per_vf) + 1) * ldb_pp_per_vf)) && (qid < cfg.num_vf_ldb_pp) ; qid++) begin
          if (qid != pp) begin
            lqid_avail.push_back(qid);
          end
        end
      end else begin
        for (int qid = cfg.num_vf_ldb_pp ; qid < cfg.num_ldb_pp ; qid++) begin
          if (qid != pp) begin
            lqid_avail.push_back(qid);
          end
        end
      end

      cfg_cmd = {cfg_cmd,$psprintf("qidv0=1 qidix0=LQ%0d ",pp)};

      for (int qidix = 1 ; qidix < 8  ; qidix++) begin
        if (lqid_avail.size() > 0) begin
          int lqid;
          int qid_index;

          qid_index = $urandom_range(lqid_avail.size() - 1, 0);
          lqid = lqid_avail[qid_index];
          lqid_avail.delete(qid_index);

          cfg_cmd = {cfg_cmd,$psprintf("qidv%0d=1 qidix%0d=LQ%0d ",qidix,qidix,lqid)};
        end
      end

      cfg_cmds.push_back(cfg_cmd);
    end

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

    for (int vf = 0 ; vf < cfg.num_vf ; vf++) begin
      dir_vpp_avail.delete();

      for (int vpp = 0 ; vpp < hqm_pkg::NUM_DIR_PP ; vpp++) begin
        dir_vpp_avail.push_back(vpp);
      end

      ldb_vpp_avail.delete();

      for (int vpp = 0 ; vpp < hqm_pkg::NUM_LDB_PP ; vpp++) begin
        ldb_vpp_avail.push_back(vpp);
      end

      ldb_vqid_avail.delete();

      for (int qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
        ldb_vqid_avail.push_back(qid);
      end

      cfg_cmd = $psprintf("vf VF%0d:* ",vf);

      for (int pp = (vf * dir_pp_per_vf) ; (pp < ((vf + 1) * dir_pp_per_vf)) && (pp < cfg.num_vf_dir_pp) ; pp++) begin
        vpp_index = $urandom_range(dir_vpp_avail.size()-1,0);
        vpp = dir_vpp_avail[vpp_index];
        dir_vpp_avail.delete(vpp_index);
        cfg_cmd = {cfg_cmd,$psprintf("dir_vpp%0d_v=1 ",vpp)};
        cfg_cmd = {cfg_cmd,$psprintf("dir_vpp%0d_pp=DQ%0d ",vpp,pp)};

        cfg_cmd = {cfg_cmd,$psprintf("dir_vqid%0d_v=1 ",vpp)};
        cfg_cmd = {cfg_cmd,$psprintf("dir_vqid%0d_qid=DQ%0d ",vpp,pp)};
      end

      for (int pp = (vf * ldb_pp_per_vf) ; (pp < ((vf + 1) * ldb_pp_per_vf)) && (pp < cfg.num_vf_ldb_pp) ; pp++) begin
        vpp_index = $urandom_range(ldb_vpp_avail.size()-1,0);
        vpp = ldb_vpp_avail[vpp_index];
        ldb_vpp_avail.delete(vpp_index);
        cfg_cmd = {cfg_cmd,$psprintf("ldb_vpp%0d_v=1 ",vpp)};
        cfg_cmd = {cfg_cmd,$psprintf("ldb_vpp%0d_pp=LPP%0d ",vpp,pp)};

        vqid_index = $urandom_range(ldb_vqid_avail.size()-1,0);
        vqid = ldb_vqid_avail[vqid_index];
        ldb_vqid_avail.delete(vqid_index);
        cfg_cmd = {cfg_cmd,$psprintf("ldb_vqid%0d_v=1 ",vqid)};
        cfg_cmd = {cfg_cmd,$psprintf("ldb_vqid%0d_qid=LQ%0d ",vqid,pp)};
      end

      cfg_cmds.push_back(cfg_cmd);
    end

    for (int pp = 0 ; pp < cfg.num_dir_pp ; pp++) begin
      cfg_cmds.push_back($psprintf("dir cq DQ%0d gpa=sm",pp));
    end
    
    for (int pp = 0 ; pp < cfg.num_ldb_pp ; pp++) begin
      cfg_cmds.push_back($psprintf("ldb cq LPP%0d gpa=sm",pp));
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

    cfg_cmds.push_back("cfg_end");

    cfg_cmds.push_back("idle 100");

    cfg_cmds.push_back("wr hqm_system_csr.ingress_alarm_enable 0xffffffff");
    cfg_cmds.push_back("rd hqm_system_csr.ingress_alarm_enable 0x0000003f");

    super.body();

    if (cfg.enable_msi || cfg.enable_msix || cfg.enable_ims_poll) begin
      `ovm_create(enable_int_cfg_seq)
      enable_int_cfg_seq.inst_suffix            = inst_suffix;
      enable_int_cfg_seq.cfg.msix_base_addr     = cfg.msix_base_addr;
      enable_int_cfg_seq.cfg.msix_addr_q        = cfg.msix_addr_q;
      enable_int_cfg_seq.cfg.msix_data_q        = cfg.msix_data_q;
      enable_int_cfg_seq.cfg.vf_msi_base_addr   = cfg.vf_msi_base_addr;
      enable_int_cfg_seq.cfg.vf_msi_multi_msg_set  = cfg.vf_msi_multi_msg_set;
      enable_int_cfg_seq.cfg.vf_msi_multi_msg_en_q = cfg.vf_msi_multi_msg_en_q;
      enable_int_cfg_seq.cfg.vf_msi_addr_q         = cfg.vf_msi_addr_q;
      enable_int_cfg_seq.cfg.vf_msi_data_q         = cfg.vf_msi_data_q;
      `ovm_rand_send(enable_int_cfg_seq)
    end
  endtask
endclass : hcw_pf_vf_test_hqm_cfg_seq
