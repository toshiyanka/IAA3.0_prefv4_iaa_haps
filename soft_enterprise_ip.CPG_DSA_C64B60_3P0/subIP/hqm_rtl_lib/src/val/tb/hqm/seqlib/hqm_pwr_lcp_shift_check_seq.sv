// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
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
// File   : hqm_pwr_lcp_shift_check_seq.sv
// Author : rsshekha
//
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_pwr_lcp_shift_check_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_lcp_shift_check_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_lcp_shift_check_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_lcp_shift_check_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_pwr_lcp_shift_check_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_lcp_shift_check_seq_stim_config

class hqm_pwr_lcp_shift_check_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_lcp_shift_check_seq)

  logic [(`LCP_DEPTH - 1):0] lcpdatain = 'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
  rand hqm_pwr_lcp_shift_check_seq_stim_config        cfg;

  hqm_sla_pcie_flr_sequence                flr_seq;
  hqm_sla_pcie_init_seq                    pcie_init;
  hqm_cold_reset_sequence                  cold_reset_sequence;
  hqm_reset_unit_sequence                  lcp_seq;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_lcp_shift_check_seq_stim_config);

  function new(string name = "hqm_pwr_lcp_shift_check_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_lcp_shift_check_seq_stim_config::type_id::create("hqm_pwr_lcp_shift_check_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  extern virtual task shift_lcp_chain_out(input bit [(`LCP_DEPTH - 1):0] lcpdatain = 'h0);

  extern virtual task shift_lcp_in_cold_reset();

endclass : hqm_pwr_lcp_shift_check_seq

task hqm_pwr_lcp_shift_check_seq::shift_lcp_in_cold_reset();
     lcpdatain = {$urandom, $urandom, $urandom};
     `ovm_info(get_full_name(),$sformatf("shift_lcp_in_cold_reset: lcpdatain = %b", lcpdatain),OVM_LOW)
     `ovm_do_with(cold_reset_sequence, {en_lcp_shift_in_l == 1'b1; lcp_shift_in_data_l == lcpdatain;})
     ral.reset_regs();
     reset_tb(); // After D3hot scoreboard and prim_mon need to be reset
     `ovm_info(get_full_name(),$sformatf("\n completed shift_lcp_in_cold_reset \n"),OVM_LOW)
endtask: shift_lcp_in_cold_reset 


task hqm_pwr_lcp_shift_check_seq::shift_lcp_chain_out(input bit [(`LCP_DEPTH - 1):0] lcpdatain = 'h0);
     // As per Bill's comment 
     // lcp_shift_done cannot be done outside of a COLD or WARM reset sequence. 
     // For WARM reset, shift_done drops concurrent with prim_rst_b and asserts after side_rst_b is released and before prim_rst_b Is released.
     `ovm_info(get_full_name(),$sformatf("starting shift_lcp_chain_out: lcpdatain = %b", lcpdatain),OVM_LOW)
     sla_vpi_put_value_by_name("hqm_tb_top.force_flcp_clk_en", 1'b1);
     `ovm_do_on_with(lcp_seq, p_sequencer.pick_sequencer("reset_sequencer"), {reset_flow_typ==hqm_reset_pkg::LCP_SHIFT_OUT; LcpDatIn_l==lcpdatain;})
     sla_vpi_put_value_by_name("hqm_tb_top.force_flcp_clk_en", 1'b0);
endtask: shift_lcp_chain_out 

task hqm_pwr_lcp_shift_check_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;
  sla_ral_field         fields[$];
  

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_lcp_shift_check_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;
  
 `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
 `ovm_info(get_full_name(),$sformatf("\n executing steps of hqm_pwr_lcp_shift_check_seq \n"),OVM_LOW)
 
 shift_lcp_in_cold_reset();

 `ovm_do(pcie_init)
 `ovm_info(get_full_name(),$sformatf("\n completed pcie_init \n"),OVM_LOW)

 pmcsr_ps_cfg(`HQM_D3STATE);
 // reset the power gated domain registers in ral mirror.
 ral.reset_regs("D3HOT","vcccfn_gated",0);
 reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
 `ovm_info(get_full_name(),$sformatf("\n completed program_to_D3 \n"),OVM_LOW)

 pmcsr_ps_cfg(`HQM_D0STATE);
 `ovm_info(get_full_name(),$sformatf("\n completed program_to_D0 \n"),OVM_LOW)

 shift_lcp_chain_out(lcpdatain);

 shift_lcp_in_cold_reset();

 `ovm_do(pcie_init)
 `ovm_info(get_full_name(),$sformatf("\n completed pcie_init \n"),OVM_LOW)

 `ovm_do(flr_seq) 
 `ovm_info(get_full_name(),$sformatf("\n completed flr \n"),OVM_LOW)

 shift_lcp_chain_out(lcpdatain);

 shift_lcp_in_cold_reset();

 `ovm_do_with(flr_seq, {no_sys_init;}) 
 `ovm_info(get_full_name(),$sformatf("\n completed flr \n"),OVM_LOW)

 `ovm_do(pcie_init)
 `ovm_info(get_full_name(),$sformatf("\n completed pcie_init \n"),OVM_LOW)

 shift_lcp_chain_out(lcpdatain);

 `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_lcp_shift_check_seq ended \n"),OVM_LOW)
     
endtask : body
