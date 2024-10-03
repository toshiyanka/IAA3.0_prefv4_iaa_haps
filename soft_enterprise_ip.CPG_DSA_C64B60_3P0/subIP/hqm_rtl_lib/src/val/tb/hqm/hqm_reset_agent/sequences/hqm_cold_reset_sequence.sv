`ifndef HQM_COLD_RESET_SEQUENCE__SV 
`define HQM_COLD_RESET_SEQUENCE__SV

import pcie_seqlib_pkg::*;
`include "stim_config_macros.svh"

class hqm_cold_reset_sequence_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_cold_reset_sequence_stim_config";

  `ovm_object_utils_begin(hqm_cold_reset_sequence_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(skip_pcie_init,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_cold_reset_sequence_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(skip_pcie_init)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path     ="primary";
  string                        tb_env_hier     = "*";
  rand int skip_pcie_init;

  constraint default_skip_pcie_init {soft skip_pcie_init == 1;}

  function new(string name = "hqm_cold_reset_sequence_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_cold_reset_sequence_stim_config

// Cold Reset Sequence
class hqm_cold_reset_sequence extends ovm_sequence;

  `ovm_sequence_utils(hqm_cold_reset_sequence, sla_sequencer);

  rand bit en_lcp_shift_in_l;
  rand bit [(`LCP_DEPTH - 1):0] lcp_shift_in_data_l;
  rand bit[15:0]                early_fuses_val;
  constraint dflt_val {
      soft en_lcp_shift_in_l == 1'b0;
      soft lcp_shift_in_data_l == 'h0;
      soft early_fuses_val == 16'h0;
  }

  rand hqm_cold_reset_sequence_stim_config        cfg;
  hqm_warm_reset_sequence       cold_reset_assert_seq;
  hqm_reset_unit_sequence       cold_reset_pwrgd_assert_seq;
  hqm_boot_sequence             cold_reset_boot_up_seq;
  hqm_sla_pcie_init_seq         pcie_init_seq;
  hqm_power_down_sequence       power_down_seq;
  hqm_power_up_sequence         power_up_seq; 
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_cold_reset_sequence_stim_config);

  function new(string name = "hqm_cold_reset_sequence", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_cold_reset_sequence_stim_config::type_id::create("hqm_cold_reset_sequence_stim_config");
    apply_stim_config_overrides(0);
  endfunction

  virtual task body();

    super.body();

    `ovm_info(get_type_name(),$psprintf("Starting hqm_cold_reset_sequence with early_fuses_val=0x%0x", early_fuses_val), OVM_LOW);

    apply_stim_config_overrides(1);
    // assert reset
    `ovm_info(get_type_name(),"Starting cold reset assert", OVM_MEDIUM);
    `ovm_do(cold_reset_assert_seq); 
    `ovm_info(get_type_name(),"Completed cold reset assert", OVM_MEDIUM);

    // assert Powergood Reset
    `ovm_do_on_with(cold_reset_pwrgd_assert_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==POWER_GOOD_ASSERT;}); 
    `ovm_info(get_type_name(),"completed cold_reset_pwrgd_assert_seq", OVM_MEDIUM);
    `ovm_do(power_down_seq);

    `ovm_do(power_up_seq); 

    // Deassert all resets
   `ovm_info(get_type_name(),$psprintf("Starting cold_reset_boot_up_seq with early_fuses_val=0x%0x", early_fuses_val), OVM_LOW);
    if (en_lcp_shift_in_l) begin
        `ovm_do_with(cold_reset_boot_up_seq, {en_lcp_shift_in == en_lcp_shift_in_l; lcp_shift_in_data == lcp_shift_in_data_l; early_fuses_load == early_fuses_val;});
    end
    else begin 
        //`ovm_do(cold_reset_boot_up_seq); 
        `ovm_do_with(cold_reset_boot_up_seq, {early_fuses_load == early_fuses_val;});
    end
    `ovm_info(get_type_name(),$psprintf("Completed cold_reset_boot_up_seq with early_fuses_val=0x%0x", early_fuses_val), OVM_LOW);
    
    if (!cfg.skip_pcie_init) begin 
      `ovm_do(pcie_init_seq); 
      `ovm_info(get_type_name(),"Completed pcie_init_seq", OVM_MEDIUM);
    end 

    `ovm_info(get_type_name(),"Done with hqm_cold_reset_sequence", OVM_LOW);

  endtask: body

endclass:hqm_cold_reset_sequence

`endif

