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
// File   : hcw_pf_vf_test_enable_int_cfg_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_pf_vf_test test with MSI interrupts
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hcw_pf_vf_test_enable_int_cfg_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hcw_pf_vf_test_enable_int_cfg_seq_stim_config";

  `ovm_object_utils_begin(hcw_pf_vf_test_enable_int_cfg_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(msix_base_addr,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_addr_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(msix_data_q,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(vf_msi_multi_msg_en_q, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(vf_msi_multi_msg_set,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(vf_msi_base_addr,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(vf_msi_addr_q,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(vf_msi_data_q,         OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hcw_pf_vf_test_enable_int_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_int(msix_base_addr)
    `stimulus_config_field_queue_int(msix_addr_q)
    `stimulus_config_field_queue_int(msix_data_q)
    `stimulus_config_field_queue_int(vf_msi_multi_msg_en_q)
    `stimulus_config_field_int(vf_msi_multi_msg_set)
    `stimulus_config_field_int(vf_msi_base_addr)
    `stimulus_config_field_queue_int(vf_msi_addr_q)
    `stimulus_config_field_queue_int(vf_msi_data_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";

  bit [63:0]                    msix_base_addr = 64'h00000000_eef00000;

  bit [63:0]                    msix_addr_q[$];
  bit [31:0]                    msix_data_q[$];

  bit [2:0]                     vf_msi_multi_msg_set;
  bit [2:0]                     vf_msi_multi_msg_en_q[$];
  bit [63:0]                    vf_msi_base_addr = 64'h00000000_fee00000;

  bit [63:0]                    vf_msi_addr_q[$];
  bit [31:0]                    vf_msi_data_q[$];

  function new(string name = "hcw_pf_vf_test_enable_int_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_vf_test_enable_int_cfg_seq_stim_config

class hcw_pf_vf_test_enable_int_cfg_seq extends hqm_base_cfg_seq;
  `ovm_sequence_utils(hcw_pf_vf_test_enable_int_cfg_seq,sla_sequencer)

  rand hcw_pf_vf_test_enable_int_cfg_seq_stim_config       cfg;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_vf_test_enable_int_cfg_seq_stim_config);
`endif

  function new(string name = "hcw_pf_vf_test_enable_int_cfg_seq");
    super.new(name); 

    cfg = hcw_pf_vf_test_enable_int_cfg_seq_stim_config::type_id::create("hcw_pf_vf_test_enable_int_cfg_seq_stim_config");
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
    bit [hqm_pkg::NUM_DIR_CQ-1:0]       dir_cq_intr_armed;
    bit [hqm_pkg::NUM_LDB_CQ-1:0]       ldb_cq_intr_armed;
    int                                 real_cq;
    int                                 vcq;
    int                                 avail_msi[$];
    int                                 msi;
    int                                 msi_index;
    int                                 dir_pp_per_vf;
    int                                 ldb_pp_per_vf;
    hcw_pf_vf_test_stim_dut_view        dut_view;
    bit [63:0]                          int_addr;
    bit [31:0]                          int_data;
    bit [2:0]                           vf_msi_multi_msg;

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);
`endif

    dut_view = hcw_pf_vf_test_stim_dut_view::instance(m_sequencer,inst_suffix);

    dir_pp_per_vf = (dut_view.num_vf_dir_pp + dut_view.num_vf - 1) / dut_view.num_vf;
    ldb_pp_per_vf = (dut_view.num_vf_ldb_pp + dut_view.num_vf - 1) / dut_view.num_vf;

    dir_cq_intr_armed = '0;
    ldb_cq_intr_armed = '0;

    cfg_cmds.push_back("cfg_begin");

    if (dut_view.enable_ims_poll) begin
      for (int cq = 0 ; cq < dut_view.num_dir_pp ; cq++) begin
        if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",cq),real_cq)) begin
          dir_cq_intr_armed[real_cq] = 1'b1;
        end else begin
          `ovm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",cq))
        end

        cfg_cmds.push_back($psprintf("dir ims DQ%0d poll_mode=1 addr=sm data=0x%0x",cq,cq + 1));
      end

      for (int cq = 0 ; cq < dut_view.num_ldb_pp ; cq++) begin
        if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",cq),real_cq)) begin
          ldb_cq_intr_armed[real_cq] = 1'b1;
        end else begin
          `ovm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",cq))
        end

        cfg_cmds.push_back($psprintf("ldb ims LPP%0d poll_mode=1 addr=sm data=0x%0x",cq,dut_view.num_dir_pp + cq + 1));
      end
    end else begin
      if (dut_view.enable_msi) begin
        for (int vf = 0 ; vf < dut_view.num_vf ; vf++) begin
          int real_vf;

          avail_msi.delete();

          for (int msi_num = 0 ; msi_num < 31 ; msi_num++) begin
            avail_msi.push_back(msi_num);
          end

          if (!i_hqm_cfg.get_name_val($psprintf("VF%0d",vf),real_vf)) begin
              `ovm_error(get_full_name(),$psprintf("VF%0d not a defined hqm_cfg.sv name",vf))
          end

          if (vf < cfg.vf_msi_multi_msg_en_q.size()) begin
             vf_msi_multi_msg = cfg.vf_msi_multi_msg_en_q[vf];
             ovm_report_info(get_full_name(), $psprintf("vf_msi_multi_msg get from cfg.vf_msi_multi_msg_en_q.size=%0d", vf_msi_multi_msg, cfg.vf_msi_multi_msg_en_q.size()), OVM_LOW);
          end else begin
             vf_msi_multi_msg = cfg.vf_msi_multi_msg_set;
          end

          if (vf < cfg.vf_msi_addr_q.size()) begin
            int_addr = cfg.vf_msi_addr_q[vf];
          end else begin
            int_addr = cfg.vf_msi_base_addr + (real_vf * 4);
          end

          if (vf < cfg.vf_msi_addr_q.size()) begin
            int_addr = cfg.vf_msi_addr_q[vf];
          end else begin
            int_addr = cfg.vf_msi_base_addr + (real_vf * 4);
          end

          if (vf < cfg.vf_msi_data_q.size()) begin
            int_data = cfg.vf_msi_data_q[vf];
          end else begin
            int_data = (real_vf + 1) << 5;
          end

          cfg_cmd = $psprintf("vf VF%0d msi_addr=0x%0x msi_data=0x%0x msi_multi_msg_en=%0d ",vf,int_addr,int_data, vf_msi_multi_msg);

          for (int cq = (vf * dir_pp_per_vf) ; (cq < ((vf + 1) * dir_pp_per_vf)) && (cq < dut_view.num_vf_dir_pp) ; cq++) begin
            if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",cq),real_cq)) begin
              dir_cq_intr_armed[real_cq] = 1'b1;
            end else begin
              `ovm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",cq))
            end

            vcq =  i_hqm_cfg.get_vcq(real_cq, real_vf, 1'b0);

            if ($test$plusargs("HQM_MSI_IDX_USE_SEQUENTIAL_NAMES")) begin
               msi_index = 0; 
            end else begin
               msi_index = $urandom_range(avail_msi.size() - 1, 0);
            end
            msi = avail_msi[msi_index];
            avail_msi.delete(msi_index);
            ovm_report_info(get_full_name(), $psprintf("DIR msi_index=%0d get msi=%0d vcq=%0d", msi_index, msi, vcq), OVM_LOW);

            cfg_cmd = {cfg_cmd,$psprintf("msi%0d_dir_vcq=%0d ",msi,vcq)};
          end

          for (int cq = (vf * ldb_pp_per_vf) ; (cq < ((vf + 1) * ldb_pp_per_vf)) && (cq < dut_view.num_vf_ldb_pp) ; cq++) begin
            if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",cq),real_cq)) begin
              ldb_cq_intr_armed[real_cq] = 1'b1;
            end else begin
              `ovm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",cq))
            end

            vcq =  i_hqm_cfg.get_vcq(real_cq, real_vf, 1'b1);

            if ($test$plusargs("HQM_MSI_IDX_USE_SEQUENTIAL_NAMES")) begin
               msi_index = 0; 
            end else begin
               msi_index = $urandom_range(avail_msi.size() - 1, 0);
            end

            msi = avail_msi[msi_index];
            avail_msi.delete(msi_index);
            ovm_report_info(get_full_name(), $psprintf("LDB msi_index=%0d get msi=%0d vcq=%0d", msi_index, msi, vcq), OVM_LOW);

            cfg_cmd = {cfg_cmd,$psprintf("msi%0d_ldb_vcq=%0d ",msi,vcq)};
          end

          cfg_cmds.push_back(cfg_cmd);
        end
      end

      if (dut_view.enable_msix) begin
        for (int qid = dut_view.num_vf_dir_pp ; qid < dut_view.num_dir_pp ; qid++) begin
          if ((qid - dut_view.num_vf_dir_pp) < cfg.msix_addr_q.size()) begin
            int_addr = cfg.msix_addr_q[qid - dut_view.num_vf_dir_pp];
          end else begin
            int_addr = cfg.msix_base_addr + (qid*4);
          end

          if ((qid - dut_view.num_vf_dir_pp) < cfg.msix_data_q.size()) begin
            int_data = cfg.msix_data_q[qid - dut_view.num_vf_dir_pp];
          end else begin
            int_data = qid + 1;
          end

          cfg_cmds.push_back($psprintf("msix_cq %0d addr=0x%0x data=0x%0x is_ldb=0 cq=DQ%0d",(qid - dut_view.num_vf_dir_pp) + 1,int_addr,int_data,qid));

          if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",qid),real_cq)) begin
            dir_cq_intr_armed[real_cq] = 1'b1;
          end else begin
            `ovm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",qid))
          end
        end

        for (int qid = dut_view.num_vf_ldb_pp ; qid < dut_view.num_ldb_pp ; qid++) begin
          if (((dut_view.num_dir_pp - dut_view.num_vf_dir_pp) + qid - dut_view.num_vf_ldb_pp) < cfg.msix_addr_q.size()) begin
            int_addr = cfg.msix_addr_q[(dut_view.num_dir_pp - dut_view.num_vf_dir_pp) + qid - dut_view.num_vf_ldb_pp];
          end else begin
            int_addr = cfg.msix_base_addr + ((dut_view.num_dir_pp + qid) * 4);
          end

          if (((dut_view.num_dir_pp - dut_view.num_vf_dir_pp) + qid - dut_view.num_vf_ldb_pp) < cfg.msix_data_q.size()) begin
            int_data = cfg.msix_data_q[(dut_view.num_dir_pp - dut_view.num_vf_dir_pp) + qid - dut_view.num_vf_ldb_pp];
          end else begin
            int_data = 'h00000801 + qid;
          end

          cfg_cmds.push_back($psprintf("msix_cq %0d addr=0x%0x data=0x%0x is_ldb=1 cq=LPP%0d",(dut_view.num_dir_pp - dut_view.num_vf_dir_pp) + (qid - dut_view.num_vf_ldb_pp) + 1,int_addr,int_data,qid));

          if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",qid),real_cq)) begin
            ldb_cq_intr_armed[real_cq] = 1'b1;
          end else begin
            `ovm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",qid))
          end
        end
      end
    end

    cfg_cmds.push_back("cfg_end");

    if (dut_view.enable_msi || dut_view.enable_msix || dut_view.enable_ims_poll) begin
      real_cq = 0;
      while (real_cq < hqm_pkg::NUM_DIR_CQ) begin
        cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_dir_cq_intr_armed%0d 0x%08x",real_cq/32,dir_cq_intr_armed[real_cq +: 32]));
        real_cq += 32;
      end

      cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_dir_cq_timer_ctl.enb 1"));
      cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_dir_cq_timer_ctl.sample_interval 1"));

      real_cq = 0;
      while (real_cq < hqm_pkg::NUM_LDB_CQ) begin
        cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_ldb_cq_intr_armed%0d 0x%08x",real_cq/32,ldb_cq_intr_armed[real_cq +: 32]));
        real_cq += 32;
      end

      cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_ldb_cq_timer_ctl.enb 1"));
      cfg_cmds.push_back($psprintf("wr credit_hist_pipe.cfg_ldb_cq_timer_ctl.sample_interval 1"));

      cfg_cmds.push_back("idle 100");
    end

    super.body();
  endtask
endclass : hcw_pf_vf_test_enable_int_cfg_seq
