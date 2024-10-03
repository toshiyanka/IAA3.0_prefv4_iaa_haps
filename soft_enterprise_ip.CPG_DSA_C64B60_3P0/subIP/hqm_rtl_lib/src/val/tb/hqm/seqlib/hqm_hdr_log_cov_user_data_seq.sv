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
// File   : hqm_hdr_log_cov_user_data_seq.sv
//
// Description :
//
//   Sequence that supports clock control tests with optional warm reset.
//
//   Variables within stim_config class
//     * do_warm_reset - do a warm reset (default is 0)
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_hdr_log_cov_user_data_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_hdr_log_cov_user_data_seq_stim_config";

  `ovm_object_utils_begin(hqm_hdr_log_cov_user_data_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_loops, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(iosf_tc, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(iosf_ph, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_hdr_log_cov_user_data_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_rand_int(num_loops)
    `stimulus_config_field_rand_int(iosf_tc)
    `stimulus_config_field_rand_int(iosf_ph)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_DATA_SEQ";
  string                        file_mode_plusarg2 = "HQM_DATA_SEQ2";

  rand  int                     num_loops;
  rand  bit [2:0]               iosf_tc;
  rand  bit [1:0]               iosf_ph;

  constraint c_defaults {
    soft iosf_tc        == 3'h0;
    soft iosf_ph        == 2'h0;
  }

  constraint c_num_loops {
         num_loops >= 1;
    soft num_loops <= 1;
  }

  function new(string name = "hqm_hdr_log_cov_user_data_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_hdr_log_cov_user_data_seq_stim_config

class hqm_hdr_log_cov_user_data_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_hdr_log_cov_user_data_seq, sla_sequencer)

  rand hqm_hdr_log_cov_user_data_seq_stim_config        cfg;

  bit [63:0] start_pf_func_bar  = 64'haaaaaaaa_fc000000;
  bit [63:0] start_pf_csr_bar   = 64'h55555555_00000000;

  sla_ral_env                   ral;
  sla_ral_data_t                ral_data;

  hqm_pp_cq_status              i_hqm_pp_cq_status;     // common HQM PP/CQ status class - updated when sequence is completed

  hqm_tb_cfg_file_mode_seq      i_file_mode_seq;
  hqm_tb_cfg_file_mode_seq      i_file_mode_seq2;

  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_rd_seq        mem_read_seq;
  hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

  sla_ral_reg   pf_cfg_func_bar_l_reg;
  sla_ral_reg   pf_cfg_func_bar_u_reg;
  sla_ral_reg   pf_cfg_csr_bar_l_reg;
  sla_ral_reg   pf_cfg_csr_bar_u_reg;

  bit [63:0]    pf_func_bar;
  bit [63:0]    pf_csr_bar;

  sla_ral_reg   pf_cfg_pcie_cap_device_status_reg;

  sla_ral_reg   pf_cfg_aer_cap_control_reg;

  sla_ral_reg   pf_cfg_aer_cap_uncorr_err_status_reg;

  sla_ral_reg   pf_cfg_aer_cap_header_log_reg[4];

  sla_ral_reg   pf_cfg_aer_cap_tlp_prefix_log_reg[4];

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_hdr_log_cov_user_data_seq_stim_config);

  function new(string name = "hqm_hdr_log_cov_user_data_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name);

    cfg = hqm_hdr_log_cov_user_data_seq_stim_config::type_id::create("hqm_hdr_log_cov_user_data_seq_stim_config");

    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    ovm_object o_tmp;
    byte_t      rd_data[$];
    addr_t      rd_addr;


    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal(get_full_name(), "Unable to get RAL handle");
    end    

    //-----------------------------
    //-- get i_hqm_pp_cq_status
    //-----------------------------
    if (!p_sequencer.get_config_object("i_hqm_pp_cq_status", o_tmp)) begin
      ovm_report_fatal(get_full_name(), "Unable to find i_hqm_pp_cq_status object");
    end

    if (!$cast(i_hqm_pp_cq_status, o_tmp)) begin
      ovm_report_fatal(get_full_name(), $psprintf("Config object i_hqm_pp_cq_status not compatible with type of i_hqm_pp_cq_status"));
    end

    apply_stim_config_overrides(1);

    populate_regs();
    update_bar_values();

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());

    start_bar_regs();

    for (int i = 0 ; i < cfg.num_loops ; i++) begin
      do_pf_hdr_log_err();

      invert_pf_bar_regs();

      do_pf_hdr_log_err();

      start_bar_regs();

    end

    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());
  endtask

  virtual task do_pf_hdr_log_err();
    Iosf::address_t     addr;
    sla_ral_data_t      ral_data;
    sla_status_t        status;
    hqm_tb_sequences_pkg::hqm_iosf_prim_mem_wr_seq        mem_write_seq;

    addr = 64'hffffffff_fffffffc;

    ral_data = $urandom_range(32'hffffffff,32'h00000000);

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {
                                                                                                           iosf_addr == addr;
                                                                                                           iosf_data.size() == 1;
                                                                                                           iosf_data[0] == ral_data[31:0];
                                                                                                           iosf_first_be == 4'h1;
                                                                                                           iosf_last_be == 4'hf;
                                                                                                           iosf_reqid == 16'h5555;
                                                                                                           iosf_tc == cfg.iosf_tc;
                                                                                                           iosf_ph == cfg.iosf_ph;
                                                                                                           iosf_tag_base == 10'h055;
                                                                                                           iosf_pasidtlp == 23'h7fffff;
                                                                                                         })

    pf_cfg_pcie_cap_device_status_reg.readx(status, 0, 0, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h000a, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00100000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_control_reg.readx(status, 'h00000800, 'h00000800, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    pf_cfg_aer_cap_header_log_reg[0].readx(status, 'h60000001, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[1].readx(status, 'h555500f1, 'hffff00ff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[2].readx(status, 'hffffffff, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[3].readx(status, 'hfffffffc, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_tlp_prefix_log_reg[0].readx(status, {8'h91,8'hcf,8'hff,8'hff}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    ral_data = 'h0000000f;
    pf_cfg_pcie_cap_device_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    ral_data = 'hffffffff;
    pf_cfg_aer_cap_uncorr_err_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h0000, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    addr = 64'h00000000_00000000;

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {
                                                                                                           iosf_addr == addr;
                                                                                                           iosf_data.size() == 1;
                                                                                                           iosf_data[0] == ral_data[31:0];
                                                                                                           iosf_first_be == 4'he;
                                                                                                           iosf_last_be == 4'h0;
                                                                                                           iosf_reqid == 16'haaaa;
                                                                                                           iosf_tc == 3'h0;
                                                                                                           iosf_ph == 2'h0;
                                                                                                           iosf_tag_base == 10'h0aa;
                                                                                                           iosf_pasidtlp == 23'h400000;
                                                                                                         })

    pf_cfg_pcie_cap_device_status_reg.readx(status, 0, 0, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h000a, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00100000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_control_reg.readx(status, 'h00000800, 'h00000800, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    pf_cfg_aer_cap_header_log_reg[0].readx(status, 'h40000001, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[1].readx(status, 'haaaa000e, 'hffff00ff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[2].readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[3].readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_tlp_prefix_log_reg[0].readx(status, {8'h91,8'h00,8'h00,8'h00}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    ral_data = 'h0000000f;
    pf_cfg_pcie_cap_device_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    ral_data = 'hffffffff;
    pf_cfg_aer_cap_uncorr_err_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h0000, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    addr = pf_func_bar;

    ral_data = $urandom_range(32'hffffffff,32'h00000000);

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {
                                                                                                           iosf_addr == addr;
                                                                                                           iosf_data.size() == 126;
                                                                                                           iosf_data[0] == ral_data[31:0];
                                                                                                           iosf_first_be == 4'hf;
                                                                                                           iosf_last_be == 4'hf;
                                                                                                           iosf_reqid == 16'h5555;
                                                                                                           iosf_tc == cfg.iosf_tc;
                                                                                                           iosf_ph == cfg.iosf_ph;
                                                                                                           iosf_tag_base == 10'h055;
                                                                                                           iosf_pasidtlp == 23'h7fffff;
                                                                                                         })

    pf_cfg_pcie_cap_device_status_reg.readx(status, 0, 0, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h000a, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00100000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_control_reg.readx(status, 'h00000800, 'h00000800, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    pf_cfg_aer_cap_header_log_reg[0].readx(status, 'h6000007e, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[1].readx(status, 'h555500ff, 'hffff00ff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[2].readx(status, {pf_func_bar[63:32]}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[3].readx(status, {pf_func_bar[31:26],2'b00,8'h00,8'h00,8'h00}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_tlp_prefix_log_reg[0].readx(status, {8'h91,8'hcf,8'hff,8'hff}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    ral_data = 'h0000000f;
    pf_cfg_pcie_cap_device_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    ral_data = 'hffffffff;
    pf_cfg_aer_cap_uncorr_err_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h0000, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    addr = pf_func_bar + 64'h00000000_03fffffc;

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {
                                                                                                           iosf_addr == addr;
                                                                                                           iosf_data.size() == 1;
                                                                                                           iosf_data[0] == ral_data[31:0];
                                                                                                           iosf_first_be == 4'h1;
                                                                                                           iosf_last_be == 4'h0;
                                                                                                           iosf_reqid == 16'haaaa;
                                                                                                           iosf_tc == 3'h0;
                                                                                                           iosf_ph == 2'h0;
                                                                                                           iosf_tag_base == 10'h0aa;
                                                                                                           iosf_pasidtlp == 23'h000000;
                                                                                                         })

    pf_cfg_pcie_cap_device_status_reg.readx(status, 0, 0, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h000a, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00100000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_control_reg.readx(status, 'h00000000, 'h00000800, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    pf_cfg_aer_cap_header_log_reg[0].readx(status, 'h60000001, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[1].readx(status, 'haaaa0001, 'hffff00ff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[2].readx(status, {pf_func_bar[63:32]}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[3].readx(status, {pf_func_bar[31:26],2'b11,8'hff,8'hff,8'hfc}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    ral_data = 'h0000000f;
    pf_cfg_pcie_cap_device_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    ral_data = 'hffffffff;
    pf_cfg_aer_cap_uncorr_err_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h0000, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    addr = pf_csr_bar;

    ral_data = $urandom_range(32'hffffffff,32'h00000000);

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {
                                                                                                           iosf_addr == addr;
                                                                                                           iosf_data.size() == 126;
                                                                                                           iosf_data[0] == ral_data[31:0];
                                                                                                           iosf_first_be == 4'hf;
                                                                                                           iosf_last_be == 4'hf;
                                                                                                           iosf_reqid == 16'h5555;
                                                                                                           iosf_tc == cfg.iosf_tc;
                                                                                                           iosf_ph == cfg.iosf_ph;
                                                                                                           iosf_tag_base == 10'h055;
                                                                                                           iosf_pasidtlp == 23'h400000;
                                                                                                         })

    pf_cfg_pcie_cap_device_status_reg.readx(status, 0, 0, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h000a, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00100000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_control_reg.readx(status, 'h00000800, 'h00000800, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    pf_cfg_aer_cap_header_log_reg[0].readx(status, 'h6000007e, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[1].readx(status, 'h555500ff, 'hffff00ff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[2].readx(status, {pf_csr_bar[63:32]}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[3].readx(status, {8'h00,8'h00,8'h00,8'h00}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_tlp_prefix_log_reg[0].readx(status, {8'h91,8'h00,8'h00,8'h00}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    ral_data = 'h0000000f;
    pf_cfg_pcie_cap_device_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    ral_data = 'hffffffff;
    pf_cfg_aer_cap_uncorr_err_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h0000, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    addr = pf_csr_bar + 64'h00000000_fffffffc;

    `ovm_do_on_with(mem_write_seq, p_sequencer.pick_sequencer(sla_iosf_pri_reg_lib_pkg::get_src_type()), {
                                                                                                           iosf_addr == addr;
                                                                                                           iosf_data.size() == 1;
                                                                                                           iosf_data[0] == ral_data[31:0];
                                                                                                           iosf_first_be == 4'h1;
                                                                                                           iosf_last_be == 4'h0;
                                                                                                           iosf_reqid == 16'haaaa;
                                                                                                           iosf_tc == 3'h0;
                                                                                                           iosf_ph == 2'h0;
                                                                                                           iosf_tag_base == 10'h0aa;
                                                                                                           iosf_pasidtlp == 23'h555555;
                                                                                                         })

    pf_cfg_pcie_cap_device_status_reg.readx(status, 0, 0, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h000a, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00100000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_control_reg.readx(status, 'h00000800, 'h00000800, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    pf_cfg_aer_cap_header_log_reg[0].readx(status, 'h60000001, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[1].readx(status, 'haaaa0001, 'hffff00ff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[2].readx(status, {pf_csr_bar[63:32]}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_header_log_reg[3].readx(status, {8'hff,8'hff,8'hff,8'hfc}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_tlp_prefix_log_reg[0].readx(status, {8'h91,8'h45,8'h55,8'h55}, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);

    ral_data = 'h0000000f;
    pf_cfg_pcie_cap_device_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    ral_data = 'hffffffff;
    pf_cfg_aer_cap_uncorr_err_status_reg.write(status, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    pf_cfg_pcie_cap_device_status_reg.readx(status, 'h0000, 'h000f, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
    pf_cfg_aer_cap_uncorr_err_status_reg.readx(status, 'h00000000, 'hffffffff, ral_data, sla_iosf_pri_reg_lib_pkg::get_src_type(), SLA_FALSE, this);
  endtask

  virtual task populate_regs();
    pf_cfg_func_bar_l_reg                       = ral.find_reg_by_file_name("func_bar_l", "hqm_pf_cfg_i");
    pf_cfg_func_bar_u_reg                       = ral.find_reg_by_file_name("func_bar_u", "hqm_pf_cfg_i");
    pf_cfg_csr_bar_l_reg                        = ral.find_reg_by_file_name("csr_bar_l", "hqm_pf_cfg_i");
    pf_cfg_csr_bar_u_reg                        = ral.find_reg_by_file_name("csr_bar_u", "hqm_pf_cfg_i");

    pf_cfg_pcie_cap_device_status_reg           = ral.find_reg_by_file_name("pcie_cap_device_status", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_control_reg                  = ral.find_reg_by_file_name("aer_cap_control", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_uncorr_err_status_reg        = ral.find_reg_by_file_name("aer_cap_uncorr_err_status", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_header_log_reg[0]            = ral.find_reg_by_file_name("aer_cap_header_log_0", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_header_log_reg[1]            = ral.find_reg_by_file_name("aer_cap_header_log_1", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_header_log_reg[2]            = ral.find_reg_by_file_name("aer_cap_header_log_2", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_header_log_reg[3]            = ral.find_reg_by_file_name("aer_cap_header_log_3", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_tlp_prefix_log_reg[0]        = ral.find_reg_by_file_name("aer_cap_tlp_prefix_log_0", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_tlp_prefix_log_reg[1]        = ral.find_reg_by_file_name("aer_cap_tlp_prefix_log_1", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_tlp_prefix_log_reg[2]        = ral.find_reg_by_file_name("aer_cap_tlp_prefix_log_2", "hqm_pf_cfg_i");
    pf_cfg_aer_cap_tlp_prefix_log_reg[3]        = ral.find_reg_by_file_name("aer_cap_tlp_prefix_log_3", "hqm_pf_cfg_i");
  endtask

  task invert_pf_bar_regs();
    sla_status_t        status;

    pf_func_bar[63:32] = ~pf_func_bar[63:32];
    pf_func_bar[31:0]  = pf_cfg_func_bar_l_reg.get() ^ 32'hfc000000;
    pf_cfg_func_bar_u_reg.write(status, pf_func_bar[63:32], sla_iosf_pri_reg_lib_pkg::get_src_type(), this);
    pf_cfg_func_bar_l_reg.write(status, pf_func_bar[31:0], sla_iosf_pri_reg_lib_pkg::get_src_type(), this);
    pf_func_bar[31:0]  = pf_func_bar[31:0] & 32'hfc000000;

    pf_csr_bar[63:32] = ~pf_csr_bar[63:32];
    pf_cfg_csr_bar_u_reg.write(status, pf_csr_bar[63:32], sla_iosf_pri_reg_lib_pkg::get_src_type(), this);
  endtask

  task start_bar_regs();
    sla_ral_data_t      ral_data;
    sla_status_t        status;

    pf_cfg_func_bar_u_reg.write(status, start_pf_func_bar[63:32], sla_iosf_pri_reg_lib_pkg::get_src_type(), this);
    pf_cfg_func_bar_l_reg.write(status, start_pf_func_bar[31:0], sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    pf_cfg_csr_bar_u_reg.write(status, start_pf_csr_bar[63:32], sla_iosf_pri_reg_lib_pkg::get_src_type(), this);

    update_bar_values();
  endtask

  function void update_bar_values();
    pf_func_bar[63:32] = pf_cfg_func_bar_u_reg.get();
    pf_func_bar[31:0]  = pf_cfg_func_bar_l_reg.get() & 32'hfc000000;

    pf_csr_bar[63:32] = pf_cfg_csr_bar_u_reg.get();
    pf_csr_bar[31:0] = '0;
  endfunction

endclass : hqm_hdr_log_cov_user_data_seq
