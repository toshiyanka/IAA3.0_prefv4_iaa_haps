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
// File   : hcw_pf_test_enable_msix_cfg_seq.sv
//
// Description :
//
//   Sequence that supports configuration for hcw_pf_test test with IMS interrupts
//
//   Variables within stim_config class
//     * 
// -----------------------------------------------------------------------------

`ifdef IP_OVM_STIM
`include "stim_config_macros.svh"
`endif

class hcw_pf_test_enable_msix_cfg_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_pf_test_enable_msix_cfg_seq_stim_config";

  `uvm_object_utils_begin(hcw_pf_test_enable_msix_cfg_seq_stim_config)
    `uvm_field_string(tb_env_hier,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(msix_base_addr,              UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(msix_addr_q,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(msix_data_q,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_pf_test_enable_msix_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_int(msix_base_addr)
    `stimulus_config_field_queue_int(msix_addr_q)
    `stimulus_config_field_queue_int(msix_data_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";

  bit [63:0]                    msix_base_addr = 64'h00000000_fee00000;

  bit [63:0]                    msix_addr_q[$];
  bit [31:0]                    msix_data_q[$];

  function new(string name = "hcw_pf_test_enable_msix_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_pf_test_enable_msix_cfg_seq_stim_config

class hcw_pf_test_enable_msix_cfg_seq extends hqm_base_cfg_seq;
  `uvm_object_utils(hcw_pf_test_enable_msix_cfg_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

  rand hcw_pf_test_enable_msix_cfg_seq_stim_config       cfg;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_pf_test_enable_msix_cfg_seq_stim_config);
`endif

  function new(string name = "hcw_pf_test_enable_msix_cfg_seq");
    super.new(name); 

    cfg = hcw_pf_test_enable_msix_cfg_seq_stim_config::type_id::create("hcw_pf_test_enable_msix_cfg_seq_stim_config");
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
    bit [hqm_pkg::NUM_DIR_CQ-1:0]       dir_cq_intr_armed;
    bit [hqm_pkg::NUM_LDB_CQ-1:0]       ldb_cq_intr_armed;
    int                                 real_cq;
    hcw_pf_test_stim_dut_view           dut_view;
    bit [63:0]                          msix_addr;
    bit [31:0]                          msix_data;

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    dut_view = hcw_pf_test_stim_dut_view::instance(m_sequencer,inst_suffix);

    dir_cq_intr_armed = '0;
    ldb_cq_intr_armed = '0;

    cfg_cmds.push_back("cfg_begin");

    for (int qid = 0 ; qid < dut_view.num_dir_pp ; qid++) begin
      if (qid < cfg.msix_addr_q.size()) begin
        msix_addr = cfg.msix_addr_q[qid];
      end else begin
        msix_addr = cfg.msix_base_addr + (qid*4);
      end 

      if (qid < cfg.msix_data_q.size()) begin
        msix_data = cfg.msix_data_q[qid];
      end else begin
        msix_data = qid + 1;
      end 

      if (dut_view.enable_ims_poll) begin
        cfg_cmds.push_back($psprintf("dir ims DQ%0d poll_mode=1 addr=sm data=0x%0x",qid,qid + 1));
      end else begin
        cfg_cmds.push_back($psprintf("msix_cq %0d addr=0x%0x data=0x%0x is_ldb=0 cq=DQ%0d",qid + 1,msix_addr,msix_data,qid));
      end 

      if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",qid),real_cq)) begin
        dir_cq_intr_armed[real_cq] = 1'b1;
      end else begin
        `uvm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",qid))
      end 
    end 


    for (int qid = 0 ; qid < dut_view.num_ldb_pp ; qid++) begin
      if ((dut_view.num_dir_pp + qid) < cfg.msix_addr_q.size()) begin
        msix_addr = cfg.msix_addr_q[dut_view.num_dir_pp + qid];
      end else begin
        msix_addr = cfg.msix_base_addr + ((dut_view.num_dir_pp + qid) * 4);
      end 

      if (qid < cfg.msix_data_q.size()) begin
        msix_data = cfg.msix_data_q[dut_view.num_dir_pp + qid];
      end else begin
        msix_data = 'h00000801 + qid;
      end 

      if (dut_view.enable_ims_poll) begin
        cfg_cmds.push_back($psprintf("ldb ims LPP%0d poll_mode=1 addr=sm data=0x%0x",qid,dut_view.num_dir_pp + qid + 1));
      end else begin
        cfg_cmds.push_back($psprintf("msix_cq %0d addr=0x%0x data=0x%0x is_ldb=1 cq=LPP%0d",dut_view.num_dir_pp + qid + 1,msix_addr,msix_data,qid));
      end 


      if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",qid),real_cq)) begin
        ldb_cq_intr_armed[real_cq] = 1'b1;
      end else begin
        `uvm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",qid))
      end 
    end 

    cfg_cmds.push_back("cfg_end");

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

    cfg_cmds.push_back("rd hqm_pf_cfg_i.vendor_id");

    cfg_cmds.push_back("idle 100");

    super.body();
  endtask
endclass : hcw_pf_test_enable_msix_cfg_seq
