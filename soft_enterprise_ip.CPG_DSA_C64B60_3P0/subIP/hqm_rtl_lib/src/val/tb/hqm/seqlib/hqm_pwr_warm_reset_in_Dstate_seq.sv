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
// File   : hqm_pwr_warm_reset_in_Dstate_seq.sv
// Author : rsshekha
// Description :
//
//   Sequence that will cause a base pwr seq.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"
//import "DPI-C" context SLA_VPI_put_value =
//  function void hqm_seq_put_value(input chandle handle, input logic [0:0] value);

class hqm_pwr_warm_reset_in_Dstate_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_warm_reset_in_Dstate_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_warm_reset_in_Dstate_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(Dstate,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_warm_reset_in_Dstate_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(Dstate)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";
  rand int                      Dstate;
  constraint soft_Dstate {soft Dstate == `HQM_D0STATE;}

  function new(string name = "hqm_pwr_warm_reset_in_Dstate_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_warm_reset_in_Dstate_seq_stim_config

class hqm_pwr_warm_reset_in_Dstate_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_warm_reset_in_Dstate_seq)

  rand hqm_pwr_warm_reset_in_Dstate_seq_stim_config        cfg;

  hqm_pwr_check_cfg_pm_status_for_D0_seq   cfg_pm_status_for_D0;
  hqm_sla_pcie_flr_sequence                D3_to_D0_by_flr;
  hqm_sla_pcie_init_seq                    pcie_init;
  hqm_reset_init_sequence                  reset_init_sequence;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_warm_reset_in_Dstate_seq_stim_config);

  function new(string name = "hqm_pwr_warm_reset_in_Dstate_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_warm_reset_in_Dstate_seq_stim_config::type_id::create("hqm_pwr_warm_reset_in_Dstate_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

endclass : hqm_pwr_warm_reset_in_Dstate_seq

task hqm_pwr_warm_reset_in_Dstate_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;
  sla_ral_field         fields[$];
  bit [63:0] D3toD0_event_cnt = 64'h0;
  //chandle force_async_warm_rst_hqm_handle;
  

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_warm_reset_in_Dstate_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;

  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))
  //force_async_warm_rst_hqm_handle = SLA_VPI_get_handle_by_name("hqm_tb_top.force_async_warm_rst_hqm",0);
  // D0active->Dstate->D0uninit (using PMCSR.ps) 
  // D0active->Dstate->D0uninit (using Using FLR) 
  // Entered in D0active, hqm_idle;
  // check hqm is idle or wait;  
  D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
  `ovm_info(get_full_name(),$sformatf("poll cfg_pm_status.pgcb_hqm_idle start \n"),OVM_LOW)
  poll("config_master","cfg_pm_status","pgcb_hqm_idle",SLA_FALSE,1'b1);
  `ovm_info(get_full_name(),$sformatf("poll cfg_pm_status.pgcb_hqm_idle completed \n"),OVM_LOW)
  // read the list of the registers to update them in ral mirror
  update_mirror_val();
  `ovm_info(get_full_name(),$sformatf("\n Dstate is %d \n", cfg.Dstate),OVM_LOW)
  //if (cfg.Dstate == "D0act") begin 
  if (cfg.Dstate == `HQM_D0STATE) begin 
     // generate the warm_reset
     `ovm_info(get_full_name(),$sformatf("\n generating warm reset in D0act \n"),OVM_LOW)
     `ovm_do(reset_init_sequence)
     //hqm_seq_put_value(force_async_warm_rst_hqm_handle, 1'b1);
     //#200ns;
     //hqm_seq_put_value(force_async_warm_rst_hqm_handle, 1'b0);
     //#100ns;
     // { 
     //  }
     ral.reset_regs(); // warm_reset is equivalent to cold_reset
     reset_tb(); // After warm_reset scoreboard and prim_mon need to be reset
     D3toD0_event_cnt = 0;
    `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
    `ovm_do(pcie_init)
    D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
    check_power_reg();
    update_mirror_val();
  end     
  // PMCSR.ps = 2'b11;
  pmcsr_ps_cfg(`HQM_D3STATE);
  // reset the power gated domain registers in ral mirror.
  ral.reset_regs("D3HOT","vcccfn_gated",0);
  reset_tb("D3HOT"); // After D3hot scoreboard and prim_mon need to be reset
  // check always on registers are uneffected by power off; 
  check_pcie_cfg_space();
  //if (cfg.Dstate == "D3hot") begin 
  if (cfg.Dstate == `HQM_D3STATE) begin 
     // generate the warm_reset
     `ovm_info(get_full_name(),$sformatf("\n generating warm reset in D3hot \n"),OVM_LOW)
     `ovm_do(reset_init_sequence)
     //hqm_seq_put_value(force_async_warm_rst_hqm_handle, 1'b1);
     //#200ns;
     //hqm_seq_put_value(force_async_warm_rst_hqm_handle, 1'b0);
     //#100ns;
     // { 
     //  }
     //ral.reset_regs("WARM_RESET"); 
     ral.reset_regs(); // warm_reset is equivalent to cold_reset
     reset_tb(); // After warm_reset scoreboard and prim_mon need to be reset
     D3toD0_event_cnt = 0;
    `ovm_info(get_full_name(),$sformatf("\n calling pcie_init \n"),OVM_LOW)
    `ovm_do(pcie_init)
     check_power_reg();
  end
  else begin  
    pmcsr_ps_cfg(`HQM_D0STATE);
    //`ovm_info(get_full_name(),$sformatf("\n calling pcie_init with skip_pmcsr_disable==1\n"),OVM_LOW)
    //`ovm_do_with(pcie_init, {pcie_init.cfg.skip_pmcsr_disable==1;})
  end   
  D3toD0_event_cnt = D3toD0_event_cnt + 1'h1;
  

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_warm_reset_in_Dstate_seq poll hqm_proc_reset_done \n"),OVM_LOW)
  poll("config_master","cfg_diagnostic_reset_status","hqm_proc_reset_done",SLA_FALSE,1'b1);

  // check power gated registers are at reset value;
  //polling for reset compelted [diagnostic_reset_status]
  poll_rst_done();
  check_powergated_mmio_cfg_space();
  // compare the cfg_pm_status values for power on;
  `ovm_do(cfg_pm_status_for_D0)
  compare("config_master","cfg_d3tod0_event_cnt_l","count",SLA_FALSE,D3toD0_event_cnt[31:0]);
  compare("config_master","cfg_d3tod0_event_cnt_h","count",SLA_FALSE,D3toD0_event_cnt[63:32]);
  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_warm_reset_in_Dstate_seq ended \n"),OVM_LOW)
     
endtask : body
