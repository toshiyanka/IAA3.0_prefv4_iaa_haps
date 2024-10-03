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
// File   : hqm_unimp_addr_user_data_seq.sv
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

class hqm_unimp_addr_user_data_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_unimp_addr_user_data_seq_stim_config";

  `ovm_object_utils_begin(hqm_unimp_addr_user_data_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1,       OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(ral_file_name,            OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(num_rand_addr,               OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_unimp_addr_user_data_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(ral_file_name)
    `stimulus_config_field_rand_int(num_rand_addr)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_DATA_SEQ";
  string                        ral_file_name = "";

  rand int      num_rand_addr;

  constraint c_num_rand_addr {
    num_rand_addr       >= 0;
    soft num_rand_addr  == 1000;
  }

  function new(string name = "hqm_unimp_addr_user_data_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_unimp_addr_user_data_seq_stim_config

class hqm_unimp_addr_user_data_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_unimp_addr_user_data_seq, sla_sequencer)

  rand hqm_unimp_addr_user_data_seq_stim_config        cfg;

  sla_ral_env                   ral;
  hqm_ral_env                   hqm_ral;
  sla_ral_data_t                ral_data;

  string file_name;

  hqm_tb_cfg_file_mode_seq      i_file_mode_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_unimp_addr_user_data_seq_stim_config);

  function new(string name = "hqm_unimp_addr_user_data_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name);

    cfg = hqm_unimp_addr_user_data_seq_stim_config::type_id::create("hqm_unimp_addr_user_data_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    ovm_object          o_tmp;
    string              file_space;
    bit [63:0]          file_size;
    sla_ral_addr_t      addr_q[$];
    int                 reg_width_q[$];
    string              reg_cases;
    sla_ral_file        rfile;

    $cast(ral, sla_ral_env::get_ptr());

    if (ral == null) begin
      ovm_report_fatal(get_full_name(), "Unable to get RAL handle");
    end    

    rfile = ral.find_file("aqed_pipe");
      
    $cast(hqm_ral,rfile.get_ral_env());

    apply_stim_config_overrides(1);

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());

    file_name = cfg.ral_file_name.tolower();

    if (hqm_ral.gen_unimp_addresses(file_name, cfg.num_rand_addr, addr_q, reg_width_q) == 0) begin
      reg_cases = $psprintf("\n%s Unimplemented Address Test List - %0d addresses\n",cfg.ral_file_name,addr_q.size());

      foreach (addr_q[i]) begin
        reg_cases = {reg_cases,$psprintf("  0x%08x REG_WIDTH=%0d\n",addr_q[i],reg_width_q[i])};
      end

      `ovm_info(get_full_name(),reg_cases,OVM_LOW)
    end
  endtask

endclass : hqm_unimp_addr_user_data_seq
