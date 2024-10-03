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
// File   : hcw_pf_vf_test_hcw_seq.sv
//
// Description :
//
//   Sequence that supports HCW traffic for hcw_pf_vf_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hcw_pf_vf_test_hcw_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_pf_vf_test_hcw_seq_stim_config";

  `ovm_object_utils_begin(hcw_pf_vf_test_hcw_seq_stim_config)
    `ovm_field_string(tb_env_hier,                      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(inst_suffix,                      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_num_hcw,                         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_hcw_time,                        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_hcw_delay_min,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_hcw_delay_max,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_batch_min,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_batch_max,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(hcw_qtype,          dir_qtype,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_num_hcw,                         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_hcw_time,                        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_hcw_delay_min,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_hcw_delay_max,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_batch_min,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_batch_max,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(hcw_qtype,          ldb_qtype,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ctl_cq_base_addr,                    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_base_addr,                    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_base_addr,                    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_space,                        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_space,                        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(dir_cq_addr_q,                 OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(ldb_cq_addr_q,                 OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(dir_cq_hpa_addr_q,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(ldb_cq_hpa_addr_q,             OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hcw_pf_vf_test_hcw_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(dir_num_hcw)
    `stimulus_config_field_rand_int(dir_hcw_time)
    `stimulus_config_field_rand_int(dir_hcw_delay_min)
    `stimulus_config_field_rand_int(dir_hcw_delay_max)
    `stimulus_config_field_rand_int(dir_batch_min)
    `stimulus_config_field_rand_int(dir_batch_max)
    `stimulus_config_field_rand_enum(hcw_qtype,dir_qtype)
    `stimulus_config_field_rand_int(ldb_num_hcw)
    `stimulus_config_field_rand_int(ldb_hcw_time)
    `stimulus_config_field_rand_int(ldb_hcw_delay_min)
    `stimulus_config_field_rand_int(ldb_hcw_delay_max)
    `stimulus_config_field_rand_int(ldb_batch_min)
    `stimulus_config_field_rand_int(ldb_batch_max)
    `stimulus_config_field_rand_enum(hcw_qtype,ldb_qtype)
    `stimulus_config_field_int(ctl_cq_base_addr)
    `stimulus_config_field_int(dir_cq_base_addr)
    `stimulus_config_field_int(ldb_cq_base_addr)
    `stimulus_config_field_int(dir_cq_space)
    `stimulus_config_field_int(ldb_cq_space)
    `stimulus_config_field_queue_int(dir_cq_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_addr_q)
    `stimulus_config_field_queue_int(dir_cq_hpa_addr_q)
    `stimulus_config_field_queue_int(ldb_cq_hpa_addr_q)
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
  rand  hcw_qtype               dir_qtype;

  rand  int                     ldb_num_hcw;
  rand  int                     ldb_hcw_time;
  rand  int                     ldb_hcw_delay_min;
  rand  int                     ldb_hcw_delay_max;
  rand  int                     ldb_batch_min;
  rand  int                     ldb_batch_max;
  rand  hcw_qtype               ldb_qtype;

  int                           ctl_cq_base_addr=0;
  bit [63:0]                    dir_cq_base_addr = 64'h00000001_23450000;
  bit [63:0]                    ldb_cq_base_addr = 64'h00000006_789a0000;
  bit [15:0]                    dir_cq_space = 16'h4000;
  bit [15:0]                    ldb_cq_space = 16'h4000;

  bit [63:0]                    dir_cq_addr_q[$];
  bit [63:0]                    ldb_cq_addr_q[$];

  bit [63:0]                    dir_cq_hpa_addr_q[$];
  bit [63:0]                    ldb_cq_hpa_addr_q[$];

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

  constraint c_qtype_soft {
    soft dir_qtype      == QDIR;
    soft ldb_qtype      == QUNO;
  }

  function new(string name = "hcw_pf_vf_test_hcw_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_vf_test_hcw_seq_stim_config

import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_pf_vf_test_hcw_seq extends sla_sequence_base;

  `ovm_sequence_utils(hcw_pf_vf_test_hcw_seq, sla_sequencer)
  
  rand hcw_pf_vf_test_hcw_seq_stim_config       cfg;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_vf_test_hcw_seq_stim_config);
`endif

  hcw_pf_vf_test_stim_dut_view     dut_view;

  hqm_cfg                       i_hqm_cfg;

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

  hqm_pp_cq_status              i_hqm_pp_cq_status;

  hqm_pp_cq_base_seq            dir_pp_cq_seq[64];

  hqm_pp_cq_base_seq            ldb_pp_cq_seq[64];

  int                           pf_dir_pp;
  int                           pf_ldb_pp;
  int                           dir_pp_per_vf;
  int                           ldb_pp_per_vf;

  //--cq_addr reprogramming
  int                           cq_addr_ctrl;

  semaphore                     qid_sem;

  function new(string name = "hcw_pf_vf_test_hcw_seq");
    super.new(name);

    qid_sem = new(1);

    cfg = hcw_pf_vf_test_hcw_seq_stim_config::type_id::create("hcw_pf_vf_test_hcw_seq_stim_config");
`ifdef IP_TYP_TE
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  endfunction

  virtual task body();
    ovm_object  o_tmp;

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    dut_view = hcw_pf_vf_test_stim_dut_view::instance(m_sequencer,cfg.inst_suffix);

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",cfg.inst_suffix}, o_tmp)) begin
       ovm_report_info(get_full_name(), "hcw_pf_vf_test_hcw_seq: Unable to find i_hqm_cfg object", OVM_LOW);
       i_hqm_cfg = null;
    end else begin
       if (!$cast(i_hqm_cfg, o_tmp)) begin
         ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
       end
    end

    //-----------------------------
    //-- get i_hcw_scoreboard
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hcw_scoreboard",cfg.inst_suffix}, o_tmp)) begin
       ovm_report_info(get_full_name(), "hcw_pf_vf_test_hcw_seq: Unable to find i_hcw_scoreboard object", OVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end
    end

    //-----------------------------
    // -- get hqm_pp_cq_status
    //-----------------------------
    if ( p_sequencer.get_config_object({"i_hqm_pp_cq_status",cfg.inst_suffix}, o_tmp) ) begin
        if ( ! ($cast(i_hqm_pp_cq_status, o_tmp)) ) begin
            ovm_report_fatal(get_full_name(), $psprintf("Object passed through i_hqm_pp_cq_status not compatible with class type hqm_pp_cq_status"));
        end 
    end else begin
        ovm_report_info(get_full_name(), $psprintf("No i_hqm_pp_cq_status set through set_config_object"));
        i_hqm_pp_cq_status = null;
    end

    //-----------------------------
    //-----------------------------
    cq_addr_ctrl = cfg.ctl_cq_base_addr;
    if($test$plusargs("HQM_CQ_ADDR_REPROG")) begin
       cq_addr_ctrl = 1;
    end
    ovm_report_info("hcw_pf_vf_test_hcw_seq", $psprintf("hcw_pf_vf_test_hcw_seq: Starting PFVF Traffic with num_dir_pp=%0d num_ldb_pp=%0d num_vf_dir_pp=%0d num_vf_ldb_pp=%0d num_vf=%0d enable_msix=%0d enable_msi=%0d enable_ims_poll=%0d dir_pp_per_vf=%0d, ldb_pp_per_vf=%0d; cq_addr_ctrl=%0d", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.num_vf_dir_pp, dut_view.num_vf_ldb_pp, dut_view.num_vf, dut_view.enable_msix, dut_view.enable_msi, dut_view.enable_ims_poll, dir_pp_per_vf, ldb_pp_per_vf, cq_addr_ctrl), OVM_NONE);

    //-----------------------------
    //-----------------------------
    if(cq_addr_ctrl==1) hqm_cq_addr_reporgram();


    //-----------------------------
    //-----------------------------
    pf_dir_pp = dut_view.num_dir_pp - dut_view.num_vf_dir_pp;
    pf_ldb_pp = dut_view.num_ldb_pp - dut_view.num_vf_ldb_pp;
    dir_pp_per_vf = (dut_view.num_vf_dir_pp + dut_view.num_vf - 1) / dut_view.num_vf;
    ldb_pp_per_vf = (dut_view.num_vf_ldb_pp + dut_view.num_vf - 1) / dut_view.num_vf;

    //-----------------------------
    //-- tasks 
    //-----------------------------
    //---------------------------------------------------
    //-- DIR
    //---------------------------------------------------
    for (int i = 0 ; i < dut_view.num_vf_dir_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.dir_cq_hpa_addr_q.size()>pp) begin
            ovm_report_info("hcw_pf_vf_test_hcw_seq", $psprintf("hcw_pf_vf_test_hcw_seq: Call start_pp_cq VF DIRPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.dir_cq_hpa_addr_q[pp]), OVM_NONE);
            start_pp_cq(.is_ldb(0), .is_vf_in(1), .vf_index_in(pp/dir_pp_per_vf), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.dir_cq_hpa_addr_q[pp]), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
          end else begin
            start_pp_cq(.is_ldb(0), .is_vf_in(1), .vf_index_in(pp/dir_pp_per_vf), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
          end
        end
      join_none
    end

    for (int i = dut_view.num_vf_dir_pp ; i < dut_view.num_dir_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.dir_cq_hpa_addr_q.size()>pp) begin
            ovm_report_info("hcw_pf_vf_test_hcw_seq", $psprintf("hcw_pf_vf_test_hcw_seq: Call start_pp_cq PF DIRPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.dir_cq_hpa_addr_q[pp]), OVM_NONE);
            start_pp_cq(.is_ldb(0), .is_vf_in(0), .vf_index_in(-1), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.dir_cq_hpa_addr_q[pp]), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
          end else begin
            start_pp_cq(.is_ldb(0), .is_vf_in(0), .vf_index_in(-1), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
          end
        end
      join_none
    end

    //---------------------------------------------------
    //-- LDB
    //---------------------------------------------------
    for (int i = 0 ; i < dut_view.num_vf_ldb_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.ldb_cq_hpa_addr_q.size()>pp) begin
            ovm_report_info("hcw_pf_vf_test_hcw_seq", $psprintf("hcw_pf_vf_test_hcw_seq: Call start_pp_cq VF LDBPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.ldb_cq_hpa_addr_q[pp]), OVM_NONE);
            start_pp_cq(.is_ldb(1), .is_vf_in(1), .vf_index_in(pp/ldb_pp_per_vf), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.ldb_cq_hpa_addr_q[pp]), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
          end else begin
            start_pp_cq(.is_ldb(1), .is_vf_in(1), .vf_index_in(pp/ldb_pp_per_vf), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
          end 
        end
      join_none
    end

    for (int i = dut_view.num_vf_ldb_pp ; i < dut_view.num_ldb_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          if(cfg.ldb_cq_hpa_addr_q.size()>pp) begin
            ovm_report_info("hcw_pf_vf_test_hcw_seq", $psprintf("hcw_pf_vf_test_hcw_seq: Call start_pp_cq PF LDBPP[%0d].cq_hpa_addr=0x%0x ", pp, cfg.ldb_cq_hpa_addr_q[pp]), OVM_NONE);
            start_pp_cq(.is_ldb(1), .is_vf_in(0), .vf_index_in(-1), .pp_cq_index_in(pp), .has_cq_hpa_addr(1), .cq_hpa_addr(cfg.ldb_cq_hpa_addr_q[pp]), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
          end else begin
            start_pp_cq(.is_ldb(1), .is_vf_in(0), .vf_index_in(-1), .pp_cq_index_in(pp), .has_cq_hpa_addr(0), .cq_hpa_addr(0), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
          end 
        end
      join_none
    end

    fork
        msix_0_interrupt_monitor();
    join_none

    wait fork;

    super.body();

    if ($test$plusargs("MULTI_INGRESS_ERR_INJ")) begin

        sla_ral_env           ral;
        sla_ral_reg           reg_h;
        sla_status_t          status;
        sla_ral_access_path_t ral_access_path;
        sla_ral_data_t        val[$];

        ovm_report_info(get_full_name(), $psprintf("Checking whether more and valid bits are set in pf_synd0 register"), OVM_LOW);
        ral_access_path = i_hqm_cfg.ral_access_path; //"iosf_pri";
        $cast(ral, sla_ral_env::get_ptr());

        if (ral == null) begin
            `ovm_fatal(get_full_name(), $psprintf("Unable to get RAL ptr"))
        end

        for (int i = 0 ; i < dut_view.num_vf; i++) begin

            int vf_num_val;

            if (i_hqm_cfg.get_name_val($psprintf("VF%0d", i), vf_num_val) == 0) begin
                `ovm_error(get_full_name(), $psprintf("VF%0d is not defined", i))
            end

            reg_h = ral.find_reg_by_file_name($psprintf("alarm_vf_synd0[%0d]", vf_num_val), {cfg.tb_env_hier,".hqm_system_csr"});
            if (reg_h == null) begin
                `ovm_fatal(get_full_name(), $psprintf("Couldn't get ptr to register alarm_vf_synd0"))
            end

            reg_h.readx_fields(status, {"VALID", "MORE"}, {1'b1, 1'b1}, val, ral_access_path);
            reg_h.write_fields(status, {"VALID", "MORE"}, {1'b1, 1'b1}, ral_access_path);
        end

        reg_h = ral.find_reg_by_file_name("alarm_pf_synd0", {cfg.tb_env_hier,".hqm_system_csr"});
        if (reg_h == null) begin
            `ovm_fatal(get_full_name(), $psprintf("Couldn't get ptr to register alarm_vf_synd0"))
        end

        reg_h.readx_fields(status, {"VALID", "MORE"}, {1'b1, 1'b1}, val, ral_access_path);
        reg_h.write_fields(status, {"VALID", "MORE"}, {1'b1, 1'b1}, ral_access_path);

    end

  endtask



  //---------------------------------------------
  //--  hqm_cq_addr_reporgram()
  //---------------------------------------------
  task hqm_cq_addr_reporgram();
     sla_ral_env         ral;
     sla_ral_reg         my_reg;
     sla_ral_field       my_field;
     sla_ral_data_t      ral_data;
     sla_status_t        status;
     string              pp_cq_prefix;
     sla_ral_access_path_t ral_access_path;

     bit [63:0]                    decode_cq_gpa_tmp; 
     bit [63:0]                    decode_cq_gpa_addr; 
     int                           pasid_tmp;
     int                           pp_idx;

     ral_access_path = i_hqm_cfg.ral_access_path; //"iosf_pri";
     ovm_report_info(get_full_name(), $psprintf("hcw_pf_vf_test_hcw_seq: Reprogramming CQ address with the setting of cfg.dir_cq_addr_q.size=%0d cfg.dir_cq_hpa_addr_q.size=%0d cfg.dir_cq_base_addr=0x%0x cfg.dir_cq_space=0x%0x; cfg.ldb_cq_addr_q.size=%0d cfg.ldb_cq_hpa_addr_q.size=%0d ldb_cq_base_addr=0x%0x cfg.ldb_cq_space=0x%0x; ral_access_path=%0s", cfg.dir_cq_addr_q.size(), cfg.dir_cq_hpa_addr_q.size(), cfg.dir_cq_base_addr, cfg.dir_cq_space, cfg.ldb_cq_addr_q.size(), cfg.ldb_cq_hpa_addr_q.size(), cfg.ldb_cq_base_addr, cfg.ldb_cq_space,ral_access_path), OVM_NONE);

     if ($value$plusargs("HQM_RAL_ACCESS_PATH=%s", ral_access_path)) begin
      `ovm_info(get_full_name(),$psprintf("hcw_pf_vf_test_hcw_seq: Reprogramming access_path is overrided by +HQM_RAL_ACCESS_PATH=%s", ral_access_path), OVM_LOW)
     end

     $cast(ral, sla_ral_env::get_ptr());
     if (ral == null) begin
       ovm_report_fatal("CFG", "Unable to get RAL handle in hqm_cq_addr_reporgram");
     end 


       //-- LDB
       pp_idx=0;
       if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin 
          decode_cq_gpa_tmp=i_hqm_cfg.allocate_dram("HQM_LDB_CQ_MEM_ALL", (dut_view.num_ldb_pp * cfg.ldb_cq_space), 'h3f, 0, 0, 0, 0, pasid_tmp);
       end

       foreach(i_hqm_cfg.ldb_pp_cq_cfg[pp]) begin
          if(i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned) begin
              pp_cq_prefix = "LDB";
              if(pp < cfg.ldb_cq_addr_q.size()) begin
                    decode_cq_gpa_addr = cfg.ldb_cq_addr_q[pp];  
              end else begin
                 if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin
                    decode_cq_gpa_addr = decode_cq_gpa_tmp + pp_idx * cfg.ldb_cq_space; 
                    if ($test$plusargs("HQM_CQ_HPA_ADDR")) begin
                        cfg.ldb_cq_hpa_addr_q[pp] = decode_cq_gpa_addr;
                        ovm_report_info(get_full_name(), $psprintf("hcw_pf_vf_test_hcw_seq: HPA cfg.ldb_cq_hpa_addr_q[%0d]=0x%0x, cfg.ldb_cq_hpa_addr_q.size=%0d", pp, cfg.ldb_cq_hpa_addr_q[pp], cfg.ldb_cq_hpa_addr_q.size()), OVM_LOW);
                    end      
                 end else begin 
                    decode_cq_gpa_addr = cfg.ldb_cq_base_addr + pp_idx * cfg.ldb_cq_space;
                 end
              end
              ovm_report_info(get_full_name(), $psprintf("hcw_pf_vf_test_hcw_seq: Reprogramming LDB_CQ[%0d].cq_provisioned=%0d from cq_gpa=0x%0x to ldb_cq_base_addr=0x%0x + offset=0x%0x, decode_cq_gpa_tmp=0x%0x new ldb_cq_addr=0x%0x, pp_idx=%0d", pp, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa, cfg.ldb_cq_base_addr, pp*cfg.ldb_cq_space, decode_cq_gpa_tmp, decode_cq_gpa_addr, pp_idx), OVM_LOW);

              i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;

              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, this);
              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.ldb_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, this);
              pp_idx++; 
          end
       end


       //-- DIR
       pp_idx=0;
       if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin
          decode_cq_gpa_tmp=i_hqm_cfg.allocate_dram("HQM_DIR_CQ_MEM_ALL", (dut_view.num_dir_pp * cfg.dir_cq_space), 'h3f, 0, 0, 0, 0, pasid_tmp);
       end

       foreach(i_hqm_cfg.dir_pp_cq_cfg[pp]) begin
          if(i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned) begin
              pp_cq_prefix = "DIR";
              if(pp < cfg.dir_cq_addr_q.size()) begin
                    decode_cq_gpa_addr = cfg.dir_cq_addr_q[pp];  
              end else begin
                 if ($test$plusargs("HQM_CQ_ADDR_REALLOC")) begin
                    decode_cq_gpa_addr = decode_cq_gpa_tmp + pp_idx * cfg.dir_cq_space; 
                    if ($test$plusargs("HQM_CQ_HPA_ADDR")) begin
                        cfg.dir_cq_hpa_addr_q[pp] = decode_cq_gpa_addr;
                        ovm_report_info(get_full_name(), $psprintf("hcw_pf_vf_test_hcw_seq: HPA cfg.dir_cq_hpa_addr_q[%0d]=0x%0x, cfg.dir_cq_hpa_addr_q.size=%0d", pp, cfg.dir_cq_hpa_addr_q[pp], cfg.dir_cq_hpa_addr_q.size()), OVM_LOW);
                    end       
                 end else begin 
                    decode_cq_gpa_addr = cfg.dir_cq_base_addr + pp_idx * cfg.dir_cq_space;
                 end
              end
              ovm_report_info(get_full_name(), $psprintf("hcw_pf_vf_test_hcw_seq: Reprogramming DIR_CQ[%0d].cq_provisioned=%0d from cq_gpa=0x%0x to dir_cq_base_addr=0x%0x + offset=0x%0x, decode_cq_gpa_tmp=0x%0x new dir_cq_addr=0x%0x, pp_idx=%0d", pp, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_provisioned, i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa, cfg.dir_cq_base_addr, pp*cfg.dir_cq_space, decode_cq_gpa_tmp, decode_cq_gpa_addr, pp_idx), OVM_LOW);

              i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa = decode_cq_gpa_addr;
              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[31:0]}, ral_access_path, this);
              my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,pp), {cfg.tb_env_hier,".hqm_system_csr"});
              my_reg.write(status, {i_hqm_cfg.dir_pp_cq_cfg[pp].cq_gpa[63:32]}, ral_access_path, this);
              pp_idx++; 
          end
       end

       ovm_report_info(get_full_name(), $psprintf("hcw_pf_vf_test_hcw_seq: Reprogramming CQ address done"), OVM_NONE);
  endtask


  //---------------------------------------------
  //-- msix_0_interrupt_monitor
  //---------------------------------------------
 task msix_0_interrupt_monitor();
 
      sla_ral_env           ral;
      sla_ral_reg           reg_h;
      sla_status_t          status;
      sla_ral_access_path_t ral_access_path;
      bit                   msix_0_seen;

      // -- ral access path
      ral_access_path = i_hqm_cfg.ral_access_path; //"iosf_pri";
      $cast(ral, sla_ral_env::get_ptr());

      if (ral == null) begin
          `ovm_fatal(get_full_name(), $psprintf("Unable to get RAL ptr"))
      end

      reg_h = ral.find_reg_by_file_name("msix_ack", {cfg.tb_env_hier,".hqm_system_csr"});
      if (reg_h == null) begin
          `ovm_fatal(get_full_name(), $psprintf("Unable to get ptr to msix_ack register in hqm_system_csr"))
      end

      if ($test$plusargs("MSIX_0_ISR_ENABLED")) begin
         ovm_report_info(get_full_name(), $psprintf("MSIX_0_ISR_ENABLED plusargs provided, ISR for MSIX-0 interrupt will run"), OVM_LOW);
         fork
             forever begin
                 repeat(100) begin @(sla_tb_env::sys_clk_r); end
                 if (i_hcw_scoreboard.hcw_scoreboard_idle()) begin
                     ovm_report_info(get_full_name(), $psprintf("Exiting the MSIX-0 ISR routine"), OVM_LOW);
                     break;
                 end
             end
             forever begin
  
                 bit [15:0] msix_data;
  
                 i_hqm_pp_cq_status.wait_for_msix_int(0, msix_data);
                 ovm_report_info(get_full_name(), $psprintf("Received MSI-X 0 interrupt, clearing the field msix_0_ack of MSIX_ACK"), OVM_LOW);
                 reg_h.write_fields(status, {"MSIX_0_ACK"}, {1'b1}, ral_access_path, this);
                 msix_0_seen = 1'b1;
             end
         join_any
         if (msix_0_seen) begin
             ovm_report_info(get_full_name(), $psprintf("MSIX 0 interrupt seen"), OVM_LOW);
         end else begin
            `ovm_error(get_full_name(), $psprintf("MSIX 0 interrupt not at all seen"));
         end
      end else begin
         ovm_report_info(get_full_name(), $psprintf("MSIX_0_ISR_ENABLED plusargs not provided; no ISR for MSIX-0 interrupt"), OVM_LOW);
      end
  
  endtask : msix_0_interrupt_monitor
  
  virtual task start_pp_cq(bit is_ldb, bit is_vf_in, int vf_index_in, int pp_cq_index_in, int has_cq_hpa_addr, bit[63:0] cq_hpa_addr, int queue_list_size, output hqm_pp_cq_base_seq pp_cq_seq);
    int                 phy_pp_cq_num;
    int                 vpp_cq_num;
    int                 qid;
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_field       my_field;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    logic [63:0]        trf_cq_addr_val;
    logic [63:0]        ims_poll_addr_val;
    bit [63:0]          tbcnt_offset_in;
    int                 num_hcw_gen;
    int                 hcw_time_gen;
    string              pp_cq_prefix;
    hcw_qtype           qtype;
    string              qtype_str;
    int                 vf_num_val;
    bit [15:0]          lock_id;
    bit [15:0]          dsi;
    int                 batch_min;
    int                 batch_max;
    bit                 msix_mode;
    int                 cq_poll_int;
    int                 msi_num;
    int                 hcw_delay_min_in;
    int                 hcw_delay_max_in;
    int                 illegal_hcw_prob;
    int                 illegal_hcw_burst_len;
    hqm_pp_cq_base_seq::illegal_hcw_gen_mode_t      illegal_hcw_gen_mode;
    hqm_pp_cq_base_seq::illegal_hcw_type_t          illegal_hcw_type;
    string              illegal_hcw_type_str;
    int                 ingress_err;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    

    if (is_vf_in) begin
      if (i_hqm_cfg.get_name_val($psprintf("VF%0d",vf_index_in),vf_num_val) == 0) begin
        `ovm_error(get_full_name(),$psprintf("VF%0d is not defined",vf_index_in))
        return;
      end
    end

    if (is_ldb) begin
      if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",pp_cq_index_in),phy_pp_cq_num)) begin
        if (is_vf_in) begin
          vpp_cq_num =  i_hqm_cfg.get_vcq(phy_pp_cq_num, vf_num_val, is_ldb);
        end else begin
          vpp_cq_num =  phy_pp_cq_num;
        end

        if (i_hqm_cfg.get_name_val($psprintf("LQ%0d",pp_cq_index_in),qid)) begin
          if (is_vf_in) begin
            qid = i_hqm_cfg.get_vqid(qid, .is_ldb(1'b1));
          end
        end else begin
          `ovm_error(get_full_name(),$psprintf("LQ%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
          return;
        end

        if (qid >= hqm_pkg::NUM_LDB_QID) begin
          `ovm_error(get_full_name(),$psprintf("LDB PP %0d does not have a valid vqid associated with it",phy_pp_cq_num))
          return;
        end
      end else begin
        `ovm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
        return;
      end
    end else begin
      if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",pp_cq_index_in),phy_pp_cq_num)) begin
        if (is_vf_in) begin
          vpp_cq_num    = i_hqm_cfg.get_vcq(phy_pp_cq_num, vf_num_val, is_ldb);
          qid           = i_hqm_cfg.get_vqid(phy_pp_cq_num, .is_ldb(1'b0));
        end else begin
          vpp_cq_num    = phy_pp_cq_num;
          qid           = phy_pp_cq_num;
        end

        if (qid >= hqm_pkg::NUM_DIR_QID) begin
          `ovm_error(get_full_name(),$psprintf("DIR PP %0d does not have a valid vqid associated with it",phy_pp_cq_num))
          return;
        end
      end else begin
        `ovm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
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

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_u[%0d]",pp_cq_prefix,phy_pp_cq_num), {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data = my_reg.get_actual();

    cq_addr_val[63:32] = ral_data[31:0];

    ims_poll_addr_val = i_hqm_cfg.get_ims_poll_addr(phy_pp_cq_num,is_ldb);

    my_reg   = ral.find_reg_by_file_name($psprintf("%s_cq_addr_l[%0d]",pp_cq_prefix,phy_pp_cq_num), {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data = my_reg.get_actual();

    cq_addr_val[31:6] = ral_data[31:6];

    //----------------------------------
    //----------------------------------
    if(has_cq_hpa_addr>0) trf_cq_addr_val = cq_hpa_addr;
    else                  trf_cq_addr_val = cq_addr_val;
    ovm_report_info(get_full_name(), $psprintf("hcw_pf_vf_test_hcw_seq_setting: is_ldb=%0d is_vf=%0d vf=%0d pp=%0d trf_cq_addr_val=0x%0x, cq_addr_val=0x%0x cq_hpa_addr=0x%0x with has_cq_hpa_addr=%0d", is_ldb, is_vf_in, vf_index_in, pp_cq_index_in, trf_cq_addr_val, cq_addr_val, cq_hpa_addr, has_cq_hpa_addr), OVM_LOW);


    //----------------------------------
    //----------------------------------
    my_field    = ral.find_field_by_name("MODE", "MSIX_MODE", {cfg.tb_env_hier,".hqm_system_csr"});
    ral_data    = my_field.get_actual();

    msix_mode   = ral_data[0];

    //----------------------------------
    //----------------------------------
    hcw_delay_min_in = is_ldb ? cfg.ldb_hcw_delay_min : cfg.dir_hcw_delay_min;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_delay_min_in);

    hcw_delay_max_in = is_ldb ? cfg.ldb_hcw_delay_max : cfg.dir_hcw_delay_max;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_delay_max_in);

    hcw_delay_min_in    = hcw_delay_min_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);
    hcw_delay_max_in    = hcw_delay_max_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);

    batch_min = is_ldb ? cfg.ldb_batch_min : cfg.dir_batch_min;
    batch_max = is_ldb ? cfg.ldb_batch_max : cfg.dir_batch_max;

    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, batch_min);
    $value$plusargs({$psprintf("%s_PP%0d_BATCH_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, batch_max);

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

    if (dut_view.enable_ims_poll) begin
      cq_poll_int       = 0;
      msi_num           = -1;
    end else if (is_vf_in && dut_view.enable_msi) begin
      cq_poll_int       = 0;
      msi_num           = i_hqm_cfg.get_msi_num(phy_pp_cq_num,vf_num_val,is_ldb);
    end else if (!is_vf_in && dut_view.enable_msix) begin
      cq_poll_int       = 0;
      msi_num           = -1;
    end else begin
      cq_poll_int       = 1;
      msi_num           = -1;
    end

    if ($value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_index_in),"=%d"}, cq_poll_int) == 0) begin
      $value$plusargs({$psprintf("%s_CQ_POLL",pp_cq_prefix),"=%d"}, cq_poll_int);
    end

    tbcnt_offset_in = 0;
    if ($value$plusargs({$psprintf("%s_PP%0d_TBCNT_OFFSET",pp_cq_prefix,pp_cq_index_in),"=%d"}, tbcnt_offset_in) == 0) begin
      $value$plusargs({$psprintf("%s_TBCNT_OFFSET",pp_cq_prefix),"=%d"}, tbcnt_offset_in);
    end

    `ovm_create(pp_cq_seq)
    pp_cq_seq.inst_suffix = cfg.inst_suffix;
    pp_cq_seq.tb_env_hier = cfg.tb_env_hier;
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_index_in));
    start_item(pp_cq_seq);
    if (!pp_cq_seq.randomize() with {
                     pp_cq_num                  == vpp_cq_num;      // Producer Port/Consumer Queue number
                     pp_cq_type                 == (is_ldb ? hqm_pp_cq_base_seq::IS_LDB : hqm_pp_cq_base_seq::IS_DIR);  // Producer Port/Consumer Queue type

                     is_vf                      == is_vf_in;
                     vf_num                     == vf_num_val;

                     queue_list.size()          == queue_list_size;

                     hcw_enqueue_batch_min      == batch_min;  // Minimum number of HCWs to send as a batch (1-4)
                     hcw_enqueue_batch_max      == batch_max;  // Maximum number of HCWs to send as a batch (1-4)

                     queue_list_delay_min       == hcw_delay_min_in;
                     queue_list_delay_max       == hcw_delay_max_in;

                     cq_addr                    == trf_cq_addr_val;
                     ims_poll_addr              == ims_poll_addr_val;

                     cq_poll_interval           == cq_poll_int;

                     msi_int_num                == msi_num;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
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

    for (int i = 0 ; i < queue_list_size ; i++) begin
      num_hcw_gen = is_ldb ? cfg.ldb_num_hcw : cfg.dir_num_hcw;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_NUM_HCW",pp_cq_prefix,pp_cq_index_in,i),"=%d"}, num_hcw_gen);

      hcw_time_gen = is_ldb ? cfg.ldb_hcw_time : cfg.dir_hcw_time;
      $value$plusargs({$psprintf("%s_PP%0d_Q%0d_HCW_TIME",pp_cq_prefix,pp_cq_index_in,i),"=%d"}, hcw_time_gen);

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
          i_hcw_scoreboard.hcw_ldb_cq_hcw_num[phy_pp_cq_num] = num_hcw_gen;
      else 
          i_hcw_scoreboard.hcw_dir_cq_hcw_num[phy_pp_cq_num] = num_hcw_gen;

      ovm_report_info(get_type_name(),$psprintf("start_pp_cq_generate__[%0d]: pp_cq_index_in=%0d/vpp_cq_num=%0d/phy_pp_cq_num=%0d/qtype=%0s/qid=%0d/lockid=0x%0x/delay=[%0d:%0d]/num_hcw_gen=%0d/hcw_time_gen=%0d, hcw_ldb_cq_hcw_num[%0d]=%0d/hcw_dir_cq_hcw_num[%0d]=%0d", i, pp_cq_index_in, vpp_cq_num, phy_pp_cq_num, qtype.name(), pp_cq_seq.queue_list[i].qid, lock_id, hcw_delay_min_in, hcw_delay_max_in, num_hcw_gen, hcw_time_gen, phy_pp_cq_num, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[phy_pp_cq_num], phy_pp_cq_num, i_hcw_scoreboard.hcw_dir_cq_hcw_num[phy_pp_cq_num] ),  OVM_LOW);

    end

    finish_item(pp_cq_seq);
  endtask

endclass
