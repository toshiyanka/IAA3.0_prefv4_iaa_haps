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
// File   : hcw_enqtrf_test_enable_msix_cfg_seq.sv
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

class hcw_enqtrf_test_enable_msix_cfg_seq_stim_config extends uvm_object;
  static string stim_cfg_name = "hcw_enqtrf_test_enable_msix_cfg_seq_stim_config";

  `uvm_object_utils_begin(hcw_enqtrf_test_enable_msix_cfg_seq_stim_config)
    `uvm_field_string(inst_suffix,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_string(tb_env_hier,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(num_ldb_pp,            UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(num_dir_pp,            UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(has_cq_intr_armed_ctl, UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(enable_msix,           UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(enable_ims_poll,       UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_int(msix_base_addr,        UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(msix_addr_q,     UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
    `uvm_field_queue_int(msix_data_q,     UVM_COPY | UVM_COMPARE | UVM_PRINT | UVM_DEC)
  `uvm_object_utils_end

`ifdef IP_OVM_STIM
  `stimulus_config_object_utils_begin(hcw_enqtrf_test_enable_msix_cfg_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(num_ldb_pp)
    `stimulus_config_field_rand_int(num_dir_pp)
    `stimulus_config_field_rand_int(has_cq_intr_armed_ctl)
    `stimulus_config_field_rand_int(enable_msix)
    `stimulus_config_field_rand_int(enable_ims_poll)
    `stimulus_config_field_int(msix_base_addr)
    `stimulus_config_field_queue_int(msix_addr_q)
    `stimulus_config_field_queue_int(msix_data_q)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  int                     num_ldb_pp;
  rand  int                     num_dir_pp;
  rand  bit                     enable_msix;
  rand  bit                     enable_ims_poll;

  int                           has_cq_intr_armed_ctl;
  bit [63:0]                    msix_base_addr = 64'h00000000_fee00000;

  bit [63:0]                    msix_addr_q[$];
  bit [31:0]                    msix_data_q[$];

  function new(string name = "hcw_enqtrf_test_enable_msix_cfg_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hcw_enqtrf_test_enable_msix_cfg_seq_stim_config

//------------------------------------------------------------
class hcw_enqtrf_test_enable_msix_cfg_seq extends hqm_base_cfg_seq;
  `uvm_object_utils(hcw_enqtrf_test_enable_msix_cfg_seq) 
  `uvm_declare_p_sequencer(slu_sequencer)

  rand hcw_enqtrf_test_enable_msix_cfg_seq_stim_config       cfg;

`ifdef IP_OVM_STIM
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hcw_enqtrf_test_enable_msix_cfg_seq_stim_config);
`endif

  hqm_cfg               i_hqm_cfg;


  function new(string name = "hcw_enqtrf_test_enable_msix_cfg_seq");
    super.new(name); 

    cfg = hcw_enqtrf_test_enable_msix_cfg_seq_stim_config::type_id::create("hcw_enqtrf_test_enable_msix_cfg_seq_stim_config");
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
    uvm_object  o_tmp;
    string      cfg_cmd;
    bit [hqm_pkg::NUM_DIR_CQ-1:0]       dir_cq_intr_armed;
    bit [hqm_pkg::NUM_LDB_CQ-1:0]       ldb_cq_intr_armed;
    int                                 real_cq;
    bit [63:0]                          msix_addr;
    bit [31:0]                          msix_data;

    super.body();       // Need to get hqm_cfg class handle, cfg_cmds[] is empty, so no commands will be issued

`ifdef IP_OVM_STIM
    apply_stim_config_overrides(1);
`endif

    //-----------------------------
    //-- get i_hqm_cfg
    //-----------------------------
    if (!p_sequencer.get_config_object({"i_hqm_cfg",cfg.inst_suffix}, o_tmp)) begin
       uvm_report_info(get_full_name(), "hcw_enqtrf_test_enable_msix_cfg_seq: Unable to find i_hqm_cfg object", UVM_LOW);
       i_hqm_cfg = null;
    end else begin
       if (!$cast(i_hqm_cfg, o_tmp)) begin
         uvm_report_fatal(get_full_name(), $psprintf("hcw_enqtrf_test_enable_msix_cfg_seq: Config object i_hqm_cfg not compatible with type of i_hqm_cfg"));
       end 
    end 

    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_enable_msix_cfg_seq_setting: cfg.num_dir_pp=%0d cfg.num_ldb_pp=%0d cfg.enable_ims_poll=%0d cfg.has_cq_intr_armed_ctl=%0d", cfg.num_dir_pp, cfg.num_ldb_pp, cfg.enable_ims_poll, cfg.has_cq_intr_armed_ctl), UVM_LOW);
    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_enable_msix_cfg_seq_setting: cfg.msix_addr_q.size=%0d cfg.msix_data_q.size=%0d cfg.msix_base_addr=0x%0x", cfg.msix_addr_q.size(), cfg.msix_data_q.size(), cfg.msix_base_addr), UVM_LOW);

    dir_cq_intr_armed = '0;
    ldb_cq_intr_armed = '0;

    cfg_cmds.push_back("cfg_begin");

    for (int index = 0 ; index < cfg.num_dir_pp ; index++) begin
      if (index < cfg.msix_addr_q.size()) begin
        msix_addr = cfg.msix_addr_q[index];
      end else begin
        msix_addr = cfg.msix_base_addr + (index*4);
      end 

      if (index < cfg.msix_data_q.size()) begin
        msix_data = cfg.msix_data_q[index];
      end else begin
        msix_data = index + 1;
      end 

      if (cfg.enable_ims_poll) begin
        cfg_cmds.push_back($psprintf("dir ims DQ%0d poll_mode=1 addr=sm data=0x%0x",index,index + 1));
      end else begin
        cfg_cmds.push_back($psprintf("msix_cq %0d addr=0x%0x data=0x%0x is_ldb=0 cq=DQ%0d",index + 1,msix_addr,msix_data,index));
      end 

      if (i_hqm_cfg.get_name_val($psprintf("DQ%0d",index),real_cq)) begin
        dir_cq_intr_armed[real_cq] = 1'b1;
      end else if(cfg.has_cq_intr_armed_ctl==1) begin
        dir_cq_intr_armed[index] = 1'b1;
      end else begin
        `uvm_error(get_full_name(),$psprintf("DQ%0d not a defined hqm_cfg.sv name",index))
      end 
    end 


    for (int index = 0 ; index < cfg.num_ldb_pp ; index++) begin
      if ((cfg.num_dir_pp + index) < cfg.msix_addr_q.size()) begin
        msix_addr = cfg.msix_addr_q[cfg.num_dir_pp + index];
      end else begin
        msix_addr = cfg.msix_base_addr + ((cfg.num_dir_pp + index) * 4);
      end 

      if (index < cfg.msix_data_q.size()) begin
        msix_data = cfg.msix_data_q[cfg.num_dir_pp + index];
      end else begin
        msix_data = 'h00000801 + index;
      end 

      if (cfg.enable_ims_poll) begin
        cfg_cmds.push_back($psprintf("ldb ims LPP%0d poll_mode=1 addr=sm data=0x%0x", index,cfg.num_dir_pp + index + 1));
      end else begin
        cfg_cmds.push_back($psprintf("msix_cq %0d addr=0x%0x data=0x%0x is_ldb=1 cq=LPP%0d",cfg.num_dir_pp + index + 1,msix_addr,msix_data,index));
      end 


      if (i_hqm_cfg.get_name_val($psprintf("LPP%0d",index),real_cq)) begin
        ldb_cq_intr_armed[real_cq] = 1'b1;
      end else if(cfg.has_cq_intr_armed_ctl==1) begin
        ldb_cq_intr_armed[index] = 1'b1;
      end else begin
        `uvm_error(get_full_name(),$psprintf("LPP%0d not a defined hqm_cfg.sv name",index))
      end 
    end 

    cfg_cmds.push_back("cfg_end");

    //--------------------------------------------------------------
    //--------------------------------------------------------------
    uvm_report_info(get_full_name(), $psprintf("hcw_enqtrf_test_enable_msix_cfg_seq: dir_cq_intr_armed=0x%0x ldb_cq_intr_armed=0x%0x", dir_cq_intr_armed, ldb_cq_intr_armed), UVM_LOW);
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
endclass : hcw_enqtrf_test_enable_msix_cfg_seq
