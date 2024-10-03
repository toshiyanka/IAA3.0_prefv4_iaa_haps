`ifndef HQM_RESET_INIT_SEQUENCE__SV 
`define HQM_RESET_INIT_SEQUENCE__SV


import pcie_seqlib_pkg::*;
`include "stim_config_macros.svh"

class hqm_reset_init_sequence_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_reset_init_sequence_stim_config";

  `ovm_object_utils_begin(hqm_reset_init_sequence_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(skip_pcie_init,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_reset_init_sequence_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(skip_pcie_init)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path     ="primary";
  string                        tb_env_hier     = "*";
  rand int skip_pcie_init;

  constraint default_skip_pcie_init {soft skip_pcie_init == 1;}

  function new(string name = "hqm_reset_init_sequence_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_reset_init_sequence_stim_config

// Reset Init Sequence
class hqm_reset_init_sequence extends ovm_sequence;

  `ovm_sequence_utils(hqm_reset_init_sequence, sla_sequencer);
  rand hqm_reset_init_sequence_stim_config        cfg;
  rand bit[15:0]                early_fuses_val;
  hqm_warm_reset_sequence       warm_reset_seq;
  hqm_boot_sequence             reset_deassert_seq;
  hqm_sla_pcie_init_seq         pcie_init_seq;
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_reset_init_sequence_stim_config);

  constraint dflt_early_fuses_val {
      soft early_fuses_val == 16'h0;
  }

  function new(string name = "hqm_reset_init_sequence", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_reset_init_sequence_stim_config::type_id::create("hqm_reset_init_sequence_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();

    super.body();

    `ovm_info(get_type_name(),$psprintf("Starting hqm_reset_init_sequence with early_fuses_val=0x%0x", early_fuses_val), OVM_LOW);

    `ovm_do(warm_reset_seq); 
    `ovm_info(get_type_name(),"completed warm_reset_seq", OVM_MEDIUM);

    apply_stim_config_overrides(1);
    // Deassert Resets
    `ovm_info(get_type_name(),$psprintf("Starting reset_deassert_seq with early_fuses_val=0x%0x", early_fuses_val), OVM_LOW);
    //`ovm_do(reset_deassert_seq); 
    `ovm_do_with(reset_deassert_seq, {early_fuses_load == early_fuses_val; });
    `ovm_info(get_type_name(),$psprintf("Completed reset_deassert_seq with early_fuses_val=0x%0x", early_fuses_val), OVM_LOW);

    if (!cfg.skip_pcie_init) begin 
      `ovm_do(pcie_init_seq); 
      `ovm_info(get_type_name(),"Completed pcie_init_seq", OVM_MEDIUM);
    end 

    `ovm_info(get_type_name(),"Done with hqm_reset_init_sequence", OVM_LOW);

  endtask: body

endclass:hqm_reset_init_sequence

`endif

