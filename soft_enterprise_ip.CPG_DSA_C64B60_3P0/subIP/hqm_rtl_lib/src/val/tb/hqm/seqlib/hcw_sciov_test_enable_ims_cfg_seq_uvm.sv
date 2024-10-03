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
// File   : hcw_sciov_test_enable_ims_cfg_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_sciov_test test with IMS interrupts
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hcw_sciov_test_enable_ims_cfg_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_sciov_test_enable_ims_cfg_seq_stim_config";

  `uvm_object_utils_begin(hcw_sciov_test_enable_ims_cfg_seq_stim_config)
    `uvm_field_string(tb_env_hier,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(file_mode_plusarg1, UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(file_mode_plusarg2, UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_ims_base_addr,     UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_ims_base_addr,     UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(dir_base_ims_data,     UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ldb_base_ims_data,     UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_ims_addr_q,  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_ims_data_q,  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(dir_ims_ctrl_q,  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_ims_addr_q,  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_ims_data_q,  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(ldb_ims_ctrl_q,  UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(ims_prog_rand,         UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_sciov_test_enable_ims_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_int(dir_ims_base_addr)
    `stimulus_config_field_int(ldb_ims_base_addr)
    `stimulus_config_field_rand_int(dir_base_ims_data)
    `stimulus_config_field_rand_int(ldb_base_ims_data)
    `stimulus_config_field_queue_int(dir_ims_addr_q)
    `stimulus_config_field_queue_int(dir_ims_data_q)
    `stimulus_config_field_queue_int(dir_ims_ctrl_q)
    `stimulus_config_field_queue_int(ldb_ims_addr_q)
    `stimulus_config_field_queue_int(ldb_ims_data_q)
    `stimulus_config_field_queue_int(ldb_ims_ctrl_q)
    `stimulus_config_field_int(ims_prog_rand)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_CFG_SEQ";
  string                        file_mode_plusarg2 = "HQM_CFG_SEQ2";

  bit [63:0]                    dir_ims_base_addr = 64'h00000000_000aaa00;
  bit [63:0]                    ldb_ims_base_addr = 64'h00000000_00055500;

  rand bit [31:0]               dir_base_ims_data;
  rand bit [31:0]               ldb_base_ims_data;

  bit [63:0]                    dir_ims_addr_q[$];
  bit [31:0]                    dir_ims_data_q[$];
  bit [31:0]                    dir_ims_ctrl_q[$];

  bit [63:0]                    ldb_ims_addr_q[$];
  bit [31:0]                    ldb_ims_data_q[$];
  bit [31:0]                    ldb_ims_ctrl_q[$];

  int                           ims_prog_rand;
  
  constraint c_base_ims_data {
    dir_base_ims_data   != ldb_base_ims_data;
  }

  function new(string name = "hcw_sciov_test_enable_ims_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_sciov_test_enable_ims_cfg_seq_stim_config

class hcw_sciov_test_enable_ims_cfg_seq extends hqm_base_cfg_seq;
  `uvm_object_utils(hcw_sciov_test_enable_ims_cfg_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

  rand hcw_sciov_test_enable_ims_cfg_seq_stim_config       cfg;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_sciov_test_enable_ims_cfg_seq_stim_config);
`endif

  function new(string name = "hcw_sciov_test_enable_ims_cfg_seq");
    super.new(name); 

    cfg = hcw_sciov_test_enable_ims_cfg_seq_stim_config::type_id::create("hcw_sciov_test_enable_ims_cfg_seq_stim_config");
`ifdef IP_OVM_STIM
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
    int         vqid_index;
    int         vqid;
    int         real_cq;
    bit [hqm_pkg::NUM_DIR_CQ-1:0]       dir_cq_intr_armed;
    bit [hqm_pkg::NUM_LDB_CQ-1:0]       ldb_cq_intr_armed;
    int                                 cq_poll_interval;
    hcw_sciov_test_stim_dut_view        dut_view;
    bit [63:0]                          ims_addr;
    bit [31:0]                          ims_data;
    bit [31:0]                          ims_ctrl;

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    dut_view = hcw_sciov_test_stim_dut_view::instance(m_sequencer,inst_suffix);

    dir_cq_intr_armed = '0;
    ldb_cq_intr_armed = '0;

    uvm_report_info(get_full_name(), $psprintf("hcw_sciov_test_enable_ims_cfg_seq: Starting IMS Config with num_dir_pp=%0d num_ldb_pp=%0d; ims_prog_rand=%0d", dut_view.num_dir_pp, dut_view.num_ldb_pp, cfg.ims_prog_rand), UVM_NONE);

    cfg_cmds.push_back("cfg_begin");

    //------------
    //-- LDB
    for (int qid = 0 ; qid < dut_view.num_ldb_pp ; qid++) begin
      cq_poll_interval = 0;
      if ($value$plusargs({$psprintf("LDB_PP%0d_CQ_POLL",qid),"=%d"}, cq_poll_interval) == 0) begin
        $value$plusargs("LDB_CQ_POLL=%d", cq_poll_interval);
      end 

      if (cq_poll_interval > 0) begin
        cfg_cmds.push_back($psprintf("ldb ims LPP%0d enable=0 addr=0x%0x data=0x%0x",qid,'h00055500 + (qid*4),~cfg.ldb_base_ims_data));
      end else begin
        if (qid < cfg.ldb_ims_addr_q.size()) begin
          ims_addr = cfg.ldb_ims_addr_q[qid];
        end else begin
          ims_addr = cfg.ldb_ims_base_addr + (qid*4);
        end 

        if (qid < cfg.ldb_ims_data_q.size()) begin
          ims_data = cfg.ldb_ims_data_q[qid];
        end else begin
          ims_data = cfg.ldb_base_ims_data + qid;
        end 

        if (qid < cfg.ldb_ims_ctrl_q.size()) begin
          ims_ctrl = cfg.ldb_ims_ctrl_q[qid];
        end else begin
          ims_ctrl = 0; 
        end 

        if (dut_view.enable_ims_poll) begin
          cfg_cmds.push_back($psprintf("ldb ims LPP%0d poll_mode=1 addr=sm data=0x%0x ctrl=0x%0x",qid,cfg.dir_base_ims_data + qid,ims_ctrl));
        end else begin
          if (cfg.ims_prog_rand) begin
             cfg_cmds.push_back($psprintf("ldb ims LPP%0d addr=0x%0x data=0x%0x ctrl=0x%0x ims_idx=%0d",qid,ims_addr,ims_data,ims_ctrl, qid));
          end else begin
             cfg_cmds.push_back($psprintf("ldb ims LPP%0d addr=0x%0x data=0x%0x ctrl=0x%0x",qid,ims_addr,ims_data,ims_ctrl));
          end 
        end 
      end 

      if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",qid),real_cq)) begin
        ldb_cq_intr_armed[real_cq] = 1'b1;
      end else begin
        `uvm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",qid))
      end 
    end 

    //------------
    //--DIR
    for (int qid = 0 ; qid < dut_view.num_dir_pp ; qid++) begin
      cq_poll_interval = 0;
      if ($value$plusargs({$psprintf("DIR_PP%0d_CQ_POLL",qid),"=%d"}, cq_poll_interval) == 0) begin
        $value$plusargs("DIR_CQ_POLL=%d", cq_poll_interval);
      end 

      if (cq_poll_interval > 0) begin
        cfg_cmds.push_back($psprintf("dir ims DQ%0d enable=0 addr=0x%0x data=0x%0x",qid,'h00055500 + (qid*4),~cfg.dir_base_ims_data));
      end else begin
        if (qid < cfg.dir_ims_addr_q.size()) begin
          ims_addr = cfg.dir_ims_addr_q[qid];
        end else begin
          ims_addr = cfg.dir_ims_base_addr + (qid*4);
        end 

        if (qid < cfg.dir_ims_data_q.size()) begin
          ims_data = cfg.dir_ims_data_q[qid];
        end else begin
          ims_data = cfg.dir_base_ims_data + qid;
        end 

        if (qid < cfg.dir_ims_ctrl_q.size()) begin
          ims_ctrl = cfg.dir_ims_ctrl_q[qid];
        end else begin
          ims_ctrl = 0; 
        end 

        if (dut_view.enable_ims_poll) begin
          cfg_cmds.push_back($psprintf("dir ims DQ%0d poll_mode=1 addr=sm data=0x%0x ctrl=0x%0x",qid,cfg.dir_base_ims_data + qid, ims_ctrl));
        end else begin
          if (cfg.ims_prog_rand) begin
             cfg_cmds.push_back($psprintf("dir ims DQ%0d addr=0x%0x data=0x%0x ctrl=0x%0x ims_idx=%0d",qid,ims_addr,ims_data, ims_ctrl, (qid+dut_view.num_ldb_pp)));
          end else begin
             cfg_cmds.push_back($psprintf("dir ims DQ%0d addr=0x%0x data=0x%0x ctrl=0x%0x",qid,ims_addr,ims_data, ims_ctrl));
          end 
        end 

        if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",qid),real_cq)) begin
          dir_cq_intr_armed[real_cq] = 1'b1;
        end else begin
          `uvm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",qid))
        end 
      end 
    end 

    //------------
    cfg_cmds.push_back("cfg_end");

    //------------
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

    super.body();
  endtask
endclass : hcw_sciov_test_enable_ims_cfg_seq
