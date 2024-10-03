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
// File   : hcw_sciov_test_hcw_seq.sv
//
// Description :
//
//   Sequence that supports HCW traffic for hcw_sciov_test test
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

`include "stim_config_macros.svh"

class hcw_sciov_test_hcw_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_sciov_test_hcw_seq_stim_config";

  `ovm_object_utils_begin(hcw_sciov_test_hcw_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(inst_suffix,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(hqm_pp_cq_base_seq::hcw_delay_rand_type_t, hcw_delay_type, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_num_hcw,                         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_hcw_time,                        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_hcw_delay_min,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_hcw_delay_max,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_batch_min,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_batch_max,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cacheline_max_num_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cacheline_max_num_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cacheline_max_pad_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cacheline_max_pad_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cacheline_max_shuffle_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cacheline_max_shuffle_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cl_pad,                          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(hcw_qtype,          dir_qtype,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_num_hcw,                         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_hcw_time,                        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_hcw_delay_min,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_hcw_delay_max,                   OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_batch_min,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_batch_max,                       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cacheline_max_num_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cacheline_max_num_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cacheline_max_pad_min,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cacheline_max_pad_max,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cacheline_max_shuffle_min,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cacheline_max_shuffle_max,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cl_pad,                          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_acomp_rtn_ctrl,                  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dir_cq_base_addr_ctl,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(ldb_cq_base_addr_ctl,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_enum(hcw_qtype,          ldb_qtype,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hcw_sciov_test_hcw_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(dir_num_hcw)
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
    `stimulus_config_field_rand_int(dir_cq_base_addr_ctl)
    `stimulus_config_field_rand_int(ldb_cq_base_addr_ctl)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  hqm_pp_cq_base_seq::hcw_delay_rand_type_t       hcw_delay_type;

  rand  int                     dir_num_hcw;
  rand  int                     dir_hcw_time;
  rand  int                     dir_hcw_delay_min;
  rand  int                     dir_hcw_delay_max;
  rand  int                     dir_batch_min;
  rand  int                     dir_batch_max;
  rand  hcw_qtype               dir_qtype;
  rand  int                     dir_cacheline_max_num_min;     
  rand  int                     dir_cacheline_max_num_max;     
  rand  int                     dir_cacheline_max_pad_min;     
  rand  int                     dir_cacheline_max_pad_max;     
  rand  int                     dir_cacheline_max_shuffle_min;     
  rand  int                     dir_cacheline_max_shuffle_max;     
  rand  int                     dir_cl_pad;

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

  rand int                      dir_cq_base_addr_ctl;
  rand int                      ldb_cq_base_addr_ctl;

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

  constraint c_qtype_soft {
    soft dir_qtype      == QDIR;
    soft ldb_qtype      == QUNO;
  }

  constraint c_ldb_acomp_ctrl_soft {
    soft ldb_acomp_rtn_ctrl == 0;
  }

  constraint c_cq_base_addr_ctl_soft {
    soft dir_cq_base_addr_ctl       == 0;
    soft ldb_cq_base_addr_ctl       == 0;
  }

  function new(string name = "hcw_sciov_test_hcw_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_sciov_test_hcw_seq_stim_config

import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hcw_sequences_pkg::*;

class hcw_sciov_test_hcw_seq extends hqm_base_seq; //sla_sequence_base;

  `ovm_sequence_utils(hcw_sciov_test_hcw_seq, sla_sequencer)

  rand hcw_sciov_test_hcw_seq_stim_config       cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_sciov_test_hcw_seq_stim_config);

  hcw_sciov_test_stim_dut_view  dut_view;

  hqm_cfg                       i_hqm_cfg;

  hqm_tb_hcw_scoreboard         i_hcw_scoreboard;

  hqm_pp_cq_base_seq            dir_pp_cq_seq[hqm_pkg::NUM_DIR_PP];

  hqm_pp_cq_base_seq            ldb_pp_cq_seq[hqm_pkg::NUM_LDB_PP];

  int                           dir_qid_used[*];
  int                           ldb_qid_used[*];
  int                           ldb_qid_used_2nd[*];

  //--cq_addr reprogramming
  int                           dir_cq_addr_ctrl;
  int                           ldb_cq_addr_ctrl;


  semaphore                     qid_sem;

  function new(string name = "hcw_sciov_test_hcw_seq");
    super.new(name);

    qid_sem = new(1);

    cfg = hcw_sciov_test_hcw_seq_stim_config::type_id::create("hcw_sciov_test_hcw_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    ovm_object  o_tmp;

    apply_stim_config_overrides(1);

    dut_view = hcw_sciov_test_stim_dut_view::instance(m_sequencer,cfg.inst_suffix);

    dir_qid_used.delete();
    ldb_qid_used.delete();
    ldb_qid_used_2nd.delete();

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",cfg.inst_suffix}, o_tmp)) begin
       ovm_report_info(get_full_name(), "hcw_sciov_test_hcw_seq: Unable to find i_hqm_cfg object", OVM_LOW);
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
       ovm_report_info(get_full_name(), "hcw_sciov_test_hcw_seq: Unable to find i_hcw_scoreboard object", OVM_LOW);
       i_hcw_scoreboard = null;
    end else begin
       if (!$cast(i_hcw_scoreboard, o_tmp)) begin
         ovm_report_fatal(get_full_name(), $psprintf("Config object i_hcw_scoreboard not compatible with type of i_hcw_scoreboard"));
       end
    end

    //-----------------------------
    // -- get i_hqm_pp_cq_status
    //-----------------------------
    get_hqm_pp_cq_status();

    //-----------------------------
    //-- tasks 
    //-----------------------------
    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq: num_dir_pp=%0d num_ldb_pp=%0d num_vdev=%0d ", dut_view.num_dir_pp, dut_view.num_ldb_pp, dut_view.num_vdev), OVM_LOW);

    for (int i = 0 ; i < dut_view.num_dir_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
          start_pp_cq(.is_ldb(0), .pp_cq_index_in(pp), .queue_list_size(1), .pp_cq_seq(dir_pp_cq_seq[pp]));
        end
      join_none
    end

    for (int i = 0 ; i < dut_view.num_ldb_pp ; i++) begin
      fork
        automatic int pp = i;
        begin
            start_pp_cq(.is_ldb(1), .pp_cq_index_in(pp), .queue_list_size(1), .pp_cq_seq(ldb_pp_cq_seq[pp]));
        end
      join_none
    end

    fork
       msix_0_interrupt_monitor();
    join_none

    wait fork;

    ingress_error_check();

    super.body();

  endtask

  task msix_0_interrupt_monitor();
  
      bit msix_0_seen;

      if ($test$plusargs("MSIX_0_ISR_ENABLED")) begin
         ovm_report_info(get_full_name(), $psprintf("MSIX_0_ISR_ENABLED plusargs provided, ISR for MSIX-0 interrupt will run"), OVM_LOW);
         fork
             forever begin
                 wait_for_clk(100);
                 if (i_hcw_scoreboard.hcw_scoreboard_idle()) begin
                     ovm_report_info(get_full_name(), $psprintf("Exiting the MSIX-0 ISR routine"), OVM_LOW);
                     break;
                 end
             end
             forever begin
  
                 bit [15:0] msix_data;
  
                 i_hqm_pp_cq_status.wait_for_msix_int(0, msix_data);
                 ovm_report_info(get_full_name(), $psprintf("Received MSI-X 0 interrupt, clearing the field msix_0_ack of MSIX_ACK"), OVM_LOW);
                 write_fields("msix_ack",  {"MSIX_0_ACK"}, {1'b1}, "hqm_system_csr");
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

  virtual task ingress_error_check();
    bit            exp_ingress_err;
    sla_ral_data_t rd_val;
    sla_ral_reg    reg_h;
    sla_status_t   status;
    bit [4:0]      exp_vdev;
    bit [31:0]     pf_synd0, pf_synd1, pf_synd2;
    bit [31:0]     vf_synd0, vf_synd1, vf_synd2;

    if ($test$plusargs("MULTI_INGRESS_ERR_INJ")) begin

        sla_ral_data_t rd_val[$];
        bit vf_synd_check[bit [3:0]];

        ovm_report_info(get_full_name(), $psprintf("Checking whether more and valid bits are set in vf_synd0 register"), OVM_LOW);
        for (int i = 0 ; i < dut_view.num_dir_pp; i++) begin
            if ($test$plusargs($psprintf("DIR_PP%0d_INGRESS_ERR", i))) begin

                sla_ral_reg reg_h;
                bit [3:0]   vdev;
                int         pp;

                if ( !(i_hqm_cfg.get_name_val($psprintf("DQ%0d", i), pp)) ) begin
                    `ovm_error(get_full_name(), $psprintf("Couldn't find a value for label DQ%0d", i))
                end
                reg_h = get_reg_handle($psprintf("hqm_dir_pp2vdev[%0d]", pp), {cfg.tb_env_hier,".hqm_system_csr"});
                vdev  = reg_h.get();
                vf_synd_check[vdev] = 1'b1;
            end
        end

        for (int i = 0 ; i < dut_view.num_ldb_pp; i++) begin
            if ($test$plusargs($psprintf("LDB_PP%0d_INGRESS_ERR", i))) begin

                sla_ral_reg reg_h;
                bit [3:0]   vdev;
                int         pp;

                if ( !(i_hqm_cfg.get_name_val($psprintf("LPP%0d", i), pp)) ) begin
                    `ovm_error(get_full_name(), $psprintf("Couldn't find a value for label LPP%0d", i))
                end
                reg_h = get_reg_handle($psprintf("hqm_ldb_pp2vdev[%0d]", pp), {cfg.tb_env_hier,".hqm_system_csr"});
                vdev  = reg_h.get();
                vf_synd_check[vdev] = 1'b1;
            end
        end

        foreach (vf_synd_check[vdev]) begin
            ovm_report_info(get_full_name(), $psprintf("Checking valid and more bits set in alarm_vf_synd0[%0d] register", vdev), OVM_LOW);
            compare_fields($psprintf("alarm_vf_synd0[%0d]", vdev), {"VALID", "MORE"}, {1'b1, 1'b1}, rd_val, {cfg.tb_env_hier,".hqm_system_csr"});
            write_fields($psprintf("alarm_vf_synd0[%0d]", vdev), {"VALID", "MORE"}, {1'b1, 1'b1}, {cfg.tb_env_hier,".hqm_system_csr"});
        end

    end else begin
        for (int i = 0; i < hqm_pkg::NUM_DIR_PP; i++) begin
            if ( $value$plusargs({$psprintf("DIR_PP%0d_INGRESS_ERR", i),"=%d"}, exp_ingress_err) ) begin

               int         pp;
               if ( !(i_hqm_cfg.get_name_val($psprintf("DQ%0d", i), pp)) ) begin
                   `ovm_error(get_full_name(), $psprintf("Couldn't find a value for label DQ%0d", i))
               end

               read_reg($psprintf("hqm_dir_pp2vdev[%0d]",pp), rd_val, {cfg.tb_env_hier,".hqm_system_csr"});
               exp_vdev=rd_val[4:0];

               reg_h = get_reg_handle($psprintf("alarm_vf_synd0[%0d]", exp_vdev), {cfg.tb_env_hier,".hqm_system_csr"});
               reg_h.readx(status, {24'hc000_01,pp[7:0]}, 32'hffff_e3ff, rd_val, ral_access_path, SLA_FALSE, this);
               vf_synd0 = rd_val[31:0];

               read_reg($psprintf("alarm_vf_synd1[%0d]", exp_vdev), rd_val, {cfg.tb_env_hier,".hqm_system_csr"});
               vf_synd1 = rd_val[31:0];
               read_reg($psprintf("alarm_vf_synd2[%0d]", exp_vdev), rd_val, {cfg.tb_env_hier,".hqm_system_csr"});
               vf_synd2 = rd_val[31:0];

               ovm_report_info(get_full_name(), $psprintf("exp_vdev=%0d, alarm_vf_synd0=%0h, alarm_vf_synd1=%0h, alarm_vf_synd2=%0h, actual PP = %d, TB PP = %d", exp_vdev, vf_synd0, vf_synd1, vf_synd2, pp, i), OVM_LOW);
               write_reg($psprintf("alarm_vf_synd0[%0d]", exp_vdev), 32'hc000_0000, {cfg.tb_env_hier,".hqm_system_csr"});
           end
       end
    end
  endtask


  virtual task start_pp_cq(bit is_ldb, int pp_cq_index_in, int queue_list_size, output hqm_pp_cq_base_seq pp_cq_seq);
    int                 pp_cq_num_in;
    int                 qid;
    sla_ral_env         ral;
    sla_ral_reg         my_reg;
    sla_ral_field       my_field;
    sla_ral_data_t      ral_data;
    logic [63:0]        cq_addr_val;
    logic [63:0]        ims_poll_addr_val;
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
    int                 cq_poll_int;
    int                 hcw_delay_min_in;
    int                 hcw_delay_max_in;
    int                 illegal_hcw_prob;
    int                 illegal_hcw_burst_len;
    hqm_pp_cq_base_seq::illegal_hcw_gen_mode_t      illegal_hcw_gen_mode;
    hqm_pp_cq_base_seq::illegal_hcw_type_t          illegal_hcw_type;
    string              illegal_hcw_type_str;
    int                 ingress_err;
    int                 pp_cq_mon_timeo;
    int                 vdev_val;

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
      ovm_report_fatal("CFG", "Unable to get RAL handle");
    end    
    //ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq:start_pp_cq: is_ldb=%0d pp_cq_index_in=%0d", is_ldb, pp_cq_index_in));

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
    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq:start_pp_cq: is_ldb=%0d pp_cq_index_in=%0d qtype=%0s", is_ldb, pp_cq_index_in, qtype_str), OVM_LOW);

    //-------------------------------
    //--
    if (is_ldb) begin
       if(pp_cq_index_in < hqm_pkg::NUM_LDB_QID) begin
          if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",pp_cq_index_in),pp_cq_num_in)) begin
             qid_sem.get(1);

             for (qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
                if (!(ldb_qid_used.exists(qid)) && i_hqm_cfg.is_sciov_vqid_v( 1'b1, pp_cq_num_in, ((qtype == QDIR) ? 1'b0 : 1'b1), qid)) begin
                  ldb_qid_used[qid] = 1;
                  break;
                end
             end

             qid_sem.put(1);

             if (qid >= hqm_pkg::NUM_LDB_QID) begin
               `ovm_error(get_full_name(),$psprintf("LDB PP %0d does not have a valid vqid associated with it is_ldb=1 pp_cq_index_in=%0d",pp_cq_num_in, pp_cq_index_in))
                return;
             end

             vdev_val = i_hqm_cfg.get_vdev(is_ldb, pp_cq_num_in);

             ovm_report_info(get_full_name(), $psprintf("start_pp_cq pp_cq_index_in=%0d :: pp_cq_num_in=%0d vdev=%0d vqid=%0d qid=%0d; map of ldb_pp_cq_cfg[%0d].vdev=%0d; map of vdev_cfg[%0d].ldb_vqid_cfg[%0d].qid=%0d", pp_cq_index_in, pp_cq_num_in, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid, pp_cq_num_in, vdev_val, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid));
          end else begin
             `ovm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
             return;
          end
       end else begin
          //--upper 32 PP
          if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",pp_cq_index_in),pp_cq_num_in)) begin
             qid_sem.get(1);

             for (qid = 0 ; qid < hqm_pkg::NUM_LDB_QID ; qid++) begin
                if (!(ldb_qid_used_2nd.exists(qid)) && i_hqm_cfg.is_sciov_vqid_v( 1'b1, pp_cq_num_in, ((qtype == QDIR) ? 1'b0 : 1'b1), qid)) begin
                  ldb_qid_used_2nd[qid] = 1;
                  break;
                end
             end

             qid_sem.put(1);

             if (qid >= hqm_pkg::NUM_LDB_QID) begin
               `ovm_error(get_full_name(),$psprintf("LDB PP %0d does not have a valid vqid associated with it is_ldb=1 pp_cq_index_in=%0d (upper 32 pp)",pp_cq_num_in, pp_cq_index_in))
                return;
             end

             vdev_val = i_hqm_cfg.get_vdev(is_ldb, pp_cq_num_in);

             ovm_report_info(get_full_name(), $psprintf("start_pp_cq pp_cq_index_in=%0d :: pp_cq_num_in=%0d vdev=%0d vqid=%0d qid=%0d; map of ldb_pp_cq_cfg[%0d].vdev=%0d; map of vdev_cfg[%0d].ldb_vqid_cfg[%0d].qid=%0d (upper 32 pp)", pp_cq_index_in, pp_cq_num_in, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid, pp_cq_num_in, vdev_val, vdev_val, qid, i_hqm_cfg.vdev_cfg[vdev_val].ldb_vqid_cfg[qid].qid));
          end else begin
             `ovm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
             return;
          end
       end //if(pp_cq_index_in < hqm_pkg::NUM_LDB_QID
    end else begin
      if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",pp_cq_index_in),pp_cq_num_in)) begin
        qid_sem.get(1);

        for (qid = 0 ; qid < hqm_pkg::NUM_DIR_QID ; qid++) begin
          if (!(dir_qid_used.exists(qid)) && i_hqm_cfg.is_sciov_vqid_v( 1'b0, pp_cq_num_in, ((qtype == QDIR) ? 1'b0 : 1'b1), qid)) begin
            dir_qid_used[qid] = 1;
            break;
          end
        end

        qid_sem.put(1);

        if (qid >= hqm_pkg::NUM_DIR_QID) begin
          `ovm_error(get_full_name(),$psprintf("DIR PP %0d does not have a valid vqid associated with it",pp_cq_num_in))
          return;
        end
      end else begin
        `ovm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",pp_cq_index_in))
        return;
      end
    end

    //--------------------------------------
    cq_addr_val = '0;

    //--------------------------------------
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
        ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: is_ldb=%0d pp_cq_num_in=%0d get cq_addr_val=0x%0x (physical address when i_hqm_cfg.ats_enabled==1)", is_ldb, pp_cq_num_in, cq_addr_val), OVM_LOW);
    end  

    ims_poll_addr_val = i_hqm_cfg.get_ims_poll_addr(pp_cq_num_in,is_ldb);

    hcw_delay_min_in = is_ldb ? cfg.ldb_hcw_delay_min : cfg.dir_hcw_delay_min;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_delay_min_in);

    hcw_delay_max_in = is_ldb ? cfg.ldb_hcw_delay_max : cfg.dir_hcw_delay_max;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_DELAY_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, hcw_delay_max_in);

    hcw_delay_min_in    = hcw_delay_min_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);
    hcw_delay_max_in    = hcw_delay_max_in * (is_ldb ? dut_view.num_ldb_pp : dut_view.num_dir_pp);
    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: hcw_delay_type=%s hcw_delay_min_in=%0d hcw_delay_max_in=%0d ",  cfg.hcw_delay_type.name(), hcw_delay_min_in, hcw_delay_max_in), OVM_MEDIUM);

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
    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: cacheline_max_num_min=%0d cacheline_max_num_max=%0d => cacheline_max_num=%0d", cacheline_max_num_min, cacheline_max_num_max, cacheline_max_num), OVM_LOW);

    cacheline_max_pad_min = is_ldb ? cfg.ldb_cacheline_max_pad_min : cfg.dir_cacheline_max_pad_min;
    cacheline_max_pad_max = is_ldb ? cfg.ldb_cacheline_max_pad_max : cfg.dir_cacheline_max_pad_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_pad_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLPAD_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_pad_max);
    ovm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cacheline_max_pad_min=%0d cacheline_max_pad_max=%0d", cacheline_max_pad_min, cacheline_max_pad_max), OVM_LOW);

    cacheline_max_shuffle_min = is_ldb ? cfg.ldb_cacheline_max_shuffle_min : cfg.dir_cacheline_max_shuffle_min;
    cacheline_max_shuffle_max = is_ldb ? cfg.ldb_cacheline_max_shuffle_max : cfg.dir_cacheline_max_shuffle_max;
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MIN",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_shuffle_min);
    $value$plusargs({$psprintf("%s_PP%0d_MAXCLSHUFFLE_MAX",pp_cq_prefix,pp_cq_index_in),"=%d"}, cacheline_max_shuffle_max);
    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", cacheline_max_shuffle_min, cacheline_max_shuffle_max), OVM_LOW);

    cl_pad = is_ldb ? cfg.ldb_cl_pad : cfg.dir_cl_pad;
    $value$plusargs({$psprintf("%s_PP%0d_CL_PAD",pp_cq_prefix,pp_cq_index_in),"=%d"}, cl_pad);
    ovm_report_info(get_full_name(), $psprintf("hcw_pf_test_hcw_seq_setting: cl_pad=%0d ", cl_pad), OVM_LOW);

    //-- call i_hqm_cfg.get_cl_rob to check if HQMV30 RTL has been programmed to set ROB=1 
    is_rob_enabled = i_hqm_cfg.get_cl_rob(is_ldb, pp_cq_num_in);
    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: is_rob_enabled=%0d ", is_rob_enabled), OVM_LOW);

    ldb_acomp_ctrl  = cfg.ldb_acomp_rtn_ctrl;
    $value$plusargs({$psprintf("%s_PP%0d_HCW_ACOMP_CTRL",pp_cq_prefix,pp_cq_index_in),"=%d"}, ldb_acomp_ctrl);
    ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: ldb_acomp_ctrl=%0d ", ldb_acomp_ctrl), OVM_LOW);

    //-- if ROB is not set to 1 in this PP, reset cacheline_max_num=1, cl_pad=0
    if(is_rob_enabled==0 && !$test$plusargs("HQM_PP_FORCE_CL_SHUFFLED")) begin
        cacheline_max_num = 1;
        cacheline_max_pad_min = 0;
        cacheline_max_pad_max = 0;
        cacheline_max_shuffle_min = 0;
        cacheline_max_shuffle_max = 0;
        cl_pad = 0;
        ovm_report_info(get_full_name(), $psprintf("hcw_sciov_test_hcw_seq_setting: is_rob_enabled=%0d reset cacheline_max_num=%0d cl_pad=%0d cacheline_max_shuffle_min=%0d cacheline_max_shuffle_max=%0d", is_rob_enabled, cacheline_max_num, cl_pad, cacheline_max_shuffle_min, cacheline_max_shuffle_max), OVM_LOW);
    end 


    //--------------------------
    if (dut_view.enable_msix || dut_view.enable_ims || dut_view.enable_ims_poll) begin
      cq_poll_int = 0;
      $value$plusargs({$psprintf("%s_PP%0d_CQ_POLL",pp_cq_prefix,pp_cq_index_in),"=%d"}, cq_poll_int);
    end else begin
      cq_poll_int = 1;
    end

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

    `ovm_create(pp_cq_seq)
    pp_cq_seq.inst_suffix = cfg.inst_suffix;
    pp_cq_seq.tb_env_hier = cfg.tb_env_hier;
    pp_cq_seq.set_name($psprintf("%s_PP%0d",pp_cq_prefix,pp_cq_index_in));
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

                     cq_addr                    == cq_addr_val;
                     ims_poll_addr              == ims_poll_addr_val;

                     cq_poll_interval           == cq_poll_int;
                   } ) begin
      `ovm_warning("HCW_PP_CQ_HCW_SEQ", "Randomization failed for pp_cq_seq");
    end

    if($value$plusargs("HQM_PP_CQ_MON_WATCHDOG_TIMEO=%d",pp_cq_mon_timeo)) begin
        pp_cq_seq.mon_watchdog_timeout = pp_cq_mon_timeo;
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

    ///qtype_str = is_ldb ? cfg.ldb_qtype.name() : cfg.dir_qtype.name();
    ///$value$plusargs({$psprintf("%s_PP%0d_QTYPE",pp_cq_prefix,pp_cq_index_in),"=%s"}, qtype_str);
    ///qtype_str = qtype_str.tolower();

    lock_id = 16'h4001;
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
      pp_cq_seq.queue_list[i].hcw_delay_type            = cfg.hcw_delay_type;
      pp_cq_seq.queue_list[i].hcw_delay_min             = hcw_delay_min_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_max             = hcw_delay_max_in * queue_list_size;
      pp_cq_seq.queue_list[i].hcw_delay_qe_only         = 1'b1;
      pp_cq_seq.queue_list[i].lock_id                   = lock_id;
      pp_cq_seq.queue_list[i].dsi                       = dsi;
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
          i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in] = num_hcw_gen;
      else 
          i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in] = num_hcw_gen;

      ovm_report_info(get_type_name(),$psprintf("start_pp_cq_generate__[%0d]: pp_cq_index_in=%0d/pp_cq_num_in=%0d/qtype=%0s/qid=%0d/lockid=0x%0x/delay=[%0d:%0d]/num_hcw_gen=%0d, hcw_ldb_cq_hcw_num[%0d]=%0d/hcw_dir_cq_hcw_num[%0d]=%0d", i, pp_cq_index_in, pp_cq_num_in, qtype.name(), pp_cq_seq.queue_list[i].qid, lock_id, hcw_delay_min_in, hcw_delay_max_in, num_hcw_gen, pp_cq_num_in, i_hcw_scoreboard.hcw_ldb_cq_hcw_num[pp_cq_num_in], pp_cq_num_in, i_hcw_scoreboard.hcw_dir_cq_hcw_num[pp_cq_num_in] ),  OVM_LOW);
    end

    finish_item(pp_cq_seq);
  endtask

endclass
