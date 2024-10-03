`include "stim_config_macros.svh"

class hqm_idle_test_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_idle_test_seq_stim_config";

  `ovm_object_utils_begin(hqm_idle_test_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(do_sm_pf_cfg,                OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(idle_test_type,                  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_idle_test_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(do_sm_pf_cfg)
    `stimulus_config_field_rand_int(idle_test_type)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";

  rand  bit                     do_sm_pf_cfg;
  rand  bit                     idle_test_type;

  constraint c_do_sm_pf_cfg {
    soft do_sm_pf_cfg           == 1'b1;
  }

  constraint c_idle_test_type {
    soft idle_test_type == 1'b1;
  }

  function new(string name = "hqm_idle_test_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_idle_test_seq_stim_config

class hqm_idle_test_seq extends ovm_sequence;
  `ovm_sequence_utils(hqm_idle_test_seq,sla_sequencer)

  rand hqm_idle_test_seq_stim_config       cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_idle_test_seq_stim_config);

  hqm_integ_seq_pkg::hqm_sm_pf_cfg_seq                          sm_pf_cfg_seq;
  hqm_integ_seq_pkg::hqm_wait_for_reset_done_seq                wait_for_reset_done_seq;
  hqm_integ_seq_pkg::hqm_idle_test_idle_seq                     idle_seq;
  hqm_integ_seq_pkg::hqm_idle_test_pmcs_disable_seq             pmcs_disable_seq;

  function new(string name = "hqm_idle_test_seq");
    super.new(name); 

    cfg = hqm_idle_test_seq_stim_config::type_id::create("hqm_idle_test_seq_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task pre_body();
    //ovm_test_done.raise_objection(this);
  endtask
  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  task post_body();
    //ovm_test_done.drop_objection(this);
  endtask

  //-------------------------------------------------------------------------
  //
  //-------------------------------------------------------------------------
  virtual task body();
    apply_stim_config_overrides(1);

    if (cfg.do_sm_pf_cfg) begin
      `ovm_do(sm_pf_cfg_seq)
    end

    if (cfg.idle_test_type == 1) begin
      `ovm_do(wait_for_reset_done_seq)

      `ovm_info(get_full_name(),"hqm_idle_test_seq Start Idle Test",OVM_NONE)

      `ovm_do(idle_seq)

      `ovm_info(get_full_name(),"hqm_idle_test_seq End Idle Test",OVM_NONE)
    end else begin
      `ovm_info(get_full_name(),"hqm_idle_test_seq Start PMCS Disable Idle Test",OVM_NONE)

      `ovm_do(pmcs_disable_seq)

      `ovm_info(get_full_name(),"hqm_idle_test_seq End PMCS Disable Idle Test",OVM_NONE)
    end

  endtask : body
endclass : hqm_idle_test_seq
