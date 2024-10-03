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
// File   : hqm_pwr_hold_vret_seq.sv
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

class hqm_pwr_hold_vret_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_hold_vret_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_hold_vret_seq_stim_config)
    `ovm_field_string(tb_env_hier,        OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg1, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(file_mode_plusarg2, OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_goto_vret,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_goto_von,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_wait_no_clkreq,     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_hold_vret_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_string(file_mode_plusarg1)
    `stimulus_config_field_string(file_mode_plusarg2)
    `stimulus_config_field_rand_int(do_goto_vret)
    `stimulus_config_field_rand_int(do_goto_von)
    `stimulus_config_field_rand_int(do_wait_no_clkreq)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";
  string                        file_mode_plusarg1 = "HQM_USER_DATA_SEQ";
  string                        file_mode_plusarg2 = "HQM_USER_DATA_SEQ2";

  rand  bit                     do_goto_vret;
  rand  bit                     do_goto_von;
  rand  bit                     do_wait_no_clkreq;

  constraint c_do_goto_vret_soft {
    do_goto_vret        == 1'b1;
  }

  constraint c_do_goto_von_soft {
    do_goto_von         == 1'b1;
  }

  constraint c_do_wait_no_clkreq_soft {
    do_wait_no_clkreq       == 1'b0;
  }

  function new(string name = "hqm_pwr_hold_vret_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_hold_vret_seq_stim_config


class hqm_pwr_hold_vret_seq extends sla_sequence_base;

  `ovm_sequence_utils(hqm_pwr_hold_vret_seq, sla_sequencer)

  bit hcw_traffic_ended  = 1'b0;
  bit watchdog_timer_ended = 1'b0;

  rand hqm_pwr_hold_vret_seq_stim_config        cfg;

  hqm_reset_sequences_pkg::hqm_reset_unit_sequence      i_wait_no_clkreq_seq;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq;
  hqm_tb_cfg_file_mode_seq                              i_file_mode_seq2;
  hqm_power_retention_sequence                          vret_seq;
  hqm_power_up_sequence                                 von_seq;
  hcw_perf_dir_ldb_test1_hcw_seq                        hcw_perf_dir_ldb_test1_hcw;
  hqm_reset_unit_sequence                               drive_clk_halt_seq;

  hqm_tb_hcw_scoreboard                                 i_hcw_scoreboard;
  hqm_iosf_prim_mon                                     i_hqm_iosf_prim_mon_obj;
  ovm_object                                            o_tmp, tmp_obj;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_hold_vret_seq_stim_config);

  function new(string name = "hqm_pwr_hold_vret_seq");
    super.new(name);

    cfg = hqm_pwr_hold_vret_seq_stim_config::type_id::create("hqm_pwr_hold_vret_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();
    super.body();

    apply_stim_config_overrides(1);

    i_file_mode_seq = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq");
    i_file_mode_seq.set_cfg(cfg.file_mode_plusarg1, 1'b0);
    i_file_mode_seq.start(get_sequencer());
    `ovm_info(get_type_name(),"hqm cfg complete", OVM_LOW);

    if (cfg.do_wait_no_clkreq) begin
      // Wait for prim_clkreq and side_clreq to deassert
      `ovm_do_on_with(i_wait_no_clkreq_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::PRIM_SIDE_CLKREQ_DEASSERT;});
      `ovm_info(get_type_name(),"Completed i_wait_no_clkreq_seq", OVM_LOW);
    end

    if (cfg.do_goto_vret) begin
      #100ns;
      `ovm_do(vret_seq);
      #1000ns;
      `ovm_info(get_type_name(),"voltage set to Vret", OVM_LOW);
      `ovm_do_on_with(drive_clk_halt_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::DRIVE_CLK_HALT_B_1;}); 
    end


    if (cfg.do_goto_von) begin
      #100ns;
      `ovm_do(von_seq);
      #100ns;
      `ovm_info(get_type_name(),"voltage set to Von", OVM_LOW);
      `ovm_do(hcw_perf_dir_ldb_test1_hcw);
      `ovm_info(get_type_name(),"hcw traffic seq complete", OVM_LOW);
    end
    else begin

       `ovm_info(get_type_name(),"Branch for Vret", OVM_LOW);

       fork: hcw_traffic_in_vret

       begin 
          `ovm_info(get_type_name(),"Started thread for hcw traffic", OVM_LOW);
          `ovm_do(hcw_perf_dir_ldb_test1_hcw);
          hcw_traffic_ended = 1'b1;
       end 

       begin 
          `ovm_info(get_type_name(),"Started thread for watchdog", OVM_LOW);
          #15000ns; // wait for time period which is more than hqm takes for hcw traffic processing. 
          watchdog_timer_ended = 1'b1;
       end 

       join_any: hcw_traffic_in_vret

       disable hcw_traffic_in_vret;

       if (hcw_traffic_ended == 1'b1) begin 
          `ovm_error(get_full_name(),$sformatf("In vret voltage hqm is procissing hcw traffic, not expected"));
       end
       else if (watchdog_timer_ended == 1'b1) begin
          `ovm_info(get_type_name(),"Watchdog timer expired as expected for hcw traffic in vret voltage", OVM_LOW);
          //-----------------------------
          //-- get i_hcw_scoreboard
          //-----------------------------
          if (!p_sequencer.get_config_object("i_hcw_scoreboard", o_tmp)) begin
              ovm_report_fatal(get_full_name(), "Unable to find i_hcw_scoreboard object");
          end

          if (!$cast(i_hcw_scoreboard, o_tmp)) begin
            ovm_report_fatal(get_full_name(), $psprintf("Config_i_hcw_scoreboard %s associated with config %s is not same type", o_tmp.sprint(), i_hcw_scoreboard.sprint()));
          end else begin
            ovm_report_info(get_full_name(), $psprintf("i_hcw_scoreboard retrieved"), OVM_LOW);
          end
          if (p_sequencer.get_config_object("i_hqm_iosf_prim_mon", tmp_obj,0))  begin
              $cast(i_hqm_iosf_prim_mon_obj, tmp_obj);
          end else begin
              `ovm_fatal(get_full_name(), "Unable to get config object hqm_iosf_prim_mon_obj");
          end
          `ovm_info(get_type_name(),"Reset prim monitor and hcw scoreboard", OVM_LOW);
          //CQ_reset
          i_hqm_iosf_prim_mon_obj.cq_gen_reset(); 
          i_hcw_scoreboard.hcw_scoreboard_reset();
          `ovm_info(get_type_name(),"Reset of tb components done", OVM_LOW);
       end     
    end 

    i_file_mode_seq2 = hqm_tb_cfg_file_mode_seq::type_id::create("i_file_mode_seq2");
    i_file_mode_seq2.set_cfg(cfg.file_mode_plusarg2, 1'b0);
    i_file_mode_seq2.start(get_sequencer());
  endtask: body
endclass: hqm_pwr_hold_vret_seq   

