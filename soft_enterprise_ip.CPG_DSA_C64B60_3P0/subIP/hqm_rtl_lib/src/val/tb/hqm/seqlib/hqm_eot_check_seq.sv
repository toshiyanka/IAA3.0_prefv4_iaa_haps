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
// File   : hqm_eot_check_seq.sv
//
// Description :
//
//   Sequence that supports clock control tests with optional warm reset.
//
//   Variables within stim_config class
//     * tb_env_hier                    - name of HQM sla_ral_env class instance within the testbench (default is "*")
//     * do_eot_rd_seq                  - run hqm_eot_rd_seq sequence
//     * do_eot_status_w_override_seq   - run hqm_eot_status_w_override_seq sequence
// -----------------------------------------------------------------------------

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hqm_eot_check_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_eot_check_seq_stim_config";

  `ovm_object_utils_begin(hqm_eot_check_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(inst_suffix,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_eot_rd_seq,               OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_eot_status_seq,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hqm_eot_check_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(inst_suffix)
    `stimulus_config_field_rand_int(do_eot_rd_seq)
    `stimulus_config_field_rand_int(do_eot_status_seq)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix     = "";

  rand  bit                     do_eot_rd_seq;
  rand  bit                     do_eot_status_seq;

  constraint c_do_eot_rd_seq_soft {
    soft do_eot_rd_seq       == 1'b1;
  }

  constraint c_do_eot_status_seq_soft {
    soft do_eot_status_seq   == 1'b1;
  }

  function new(string name = "hqm_eot_check_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_eot_check_seq_stim_config

class hqm_eot_check_seq extends sla_sequence_base;
  `ovm_sequence_utils(hqm_eot_check_seq,sla_sequencer)

  rand hqm_eot_check_seq_stim_config        cfg;

  hqm_eot_rd_seq                                        i_eot_rd_seq;
  hqm_eot_status_w_override_seq                         i_eot_status_seq;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_eot_check_seq_stim_config);
`endif

  function new(string name = "hqm_eot_check_seq");
    super.new(name);

    cfg = hqm_eot_check_seq_stim_config::type_id::create("hqm_eot_check_seq_stim_config");
`ifdef IP_TYP_TE
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif

  endfunction

  virtual task body();

`ifdef IP_TYP_TE
    apply_stim_config_overrides(1);

`endif

    ovm_report_info("HQM_EOT_CHECK_SEQ", $psprintf("Start inst=%0s with cfg.do_eot_rd_seq=%0d cfg.do_eot_status_seq=%0d", cfg.inst_suffix, cfg.do_eot_rd_seq, cfg.do_eot_status_seq), OVM_LOW);

    if (cfg.do_eot_rd_seq) begin
       ovm_report_info("HQM_EOT_CHECK_SEQ", $psprintf("Start inst=%0s hqm_eot_rd_seq", cfg.inst_suffix), OVM_LOW);
      `ovm_create(i_eot_rd_seq)
      i_eot_rd_seq.inst_suffix = cfg.inst_suffix;
      `ovm_rand_send(i_eot_rd_seq)
      //`ovm_do(i_eot_rd_seq)
    end

    if (cfg.do_eot_status_seq) begin
       ovm_report_info("HQM_EOT_CHECK_SEQ", $psprintf("Start inst=%0s hqm_eot_status_w_override_seq", cfg.inst_suffix), OVM_LOW);
      `ovm_create(i_eot_status_seq)
      i_eot_status_seq.inst_suffix = cfg.inst_suffix;
      `ovm_rand_send(i_eot_status_seq)
      //`ovm_do(i_eot_status_seq)
    end

    ovm_report_info("HQM_EOT_CHECK_SEQ", $psprintf("Completed inst=%0s", cfg.inst_suffix), OVM_LOW);
  endtask

endclass : hqm_eot_check_seq
