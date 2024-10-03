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
// File   : hqm_pwr_check_cfg_pm_status_for_D0_seq.sv
// Author : rsshekha
//
// Description :
//
//   Sequence that will cause a pwr dwn.
//
//   Variables within stim_config class
//     * access_path   - access_path value used with Saola RAL read()/write() calls (default is "primary")
//     * tb_env_hier   - name of HQM sla_ral_env class instance within the testbench (default is "*")
// -----------------------------------------------------------------------------

`include "stim_config_macros.svh"

class hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config";

  `ovm_object_utils_begin(hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config)
    `ovm_field_string(access_path,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_string(tb_env_hier,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config)
    `stimulus_config_field_string(access_path)
    `stimulus_config_field_string(tb_env_hier)
  `stimulus_config_object_utils_end

  sla_ral_access_path_t         access_path;
  string                        tb_env_hier     = "*";

  function new(string name = "hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config

class hqm_pwr_check_cfg_pm_status_for_D0_seq extends hqm_pwr_base_seq;
  `ovm_object_utils(hqm_pwr_check_cfg_pm_status_for_D0_seq)

  rand hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config        cfg;


  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config);

  function new(string name = "hqm_pwr_check_cfg_pm_status_for_D0_seq", ovm_sequencer_base sequencer=null, ovm_sequence parent_seq=null);
    super.new(name, sequencer, parent_seq); 

    cfg = hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config::type_id::create("hqm_pwr_check_cfg_pm_status_for_D0_seq_stim_config");
    cfg.access_path = sla_iosf_pri_reg_lib_pkg::get_src_type();
    apply_stim_config_overrides(0);
  endfunction

  extern virtual task body();

  
endclass : hqm_pwr_check_cfg_pm_status_for_D0_seq

task hqm_pwr_check_cfg_pm_status_for_D0_seq::body();
  sla_ral_data_t        wr_data;
  sla_ral_data_t        rd_data;

  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_check_cfg_pm_status_for_D0_seq started \n"),OVM_LOW)
  apply_stim_config_overrides(1);
  ral_access_path = cfg.access_path;
  base_tb_env_hier = cfg.tb_env_hier;

  `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

  // 2.	[HQM] Request Power-Off by setting pgcb_pmc_pg_req_b to 1'b1. 
  // compare for 1
  compare("config_master","cfg_pm_status","pmsm_pgcb_req_b",SLA_FALSE,1'b1);
  // 3.	[HQM] Clocks in the PGD are gated off.
  // Currently no register to read this? 
  // 4.	[PGCB] PGCB requests a Power-Off from SAPMA.
  // compare for 1
   compare("config_master","cfg_pm_status","pgbc_pmc_pg_req_b",SLA_FALSE,1'b1);
  // 5.	[SAPMA] SAPMA acknowledges the request.
  // compare for 1
  compare("config_master","cfg_pm_status","pmc_pgcb_pg_ack_b",SLA_FALSE,1'b1);
  // 6.	[PGCB] PGCB isolates the PGD outputs.
  // 7.	[PGCB] PGCB puts the PGD in reset.
  // Is there any way for software to see these steps? 

  // 8.	[PGCB] PGCB requests SAPMA to physically power off the PGD
  // 9.	[SAPMA] SAPMA acknowledges the request (pmc_pgcb_pg_ack_b set to 1'b0)
  // Are these steps 8,9 copy of steps 4,5? 

  // 10.[PGCB] PGCB advances HQM PMSM state machine to PWR_OFF by setting pgcb_hqm_pg_rdy_ack_b to 1'b1.
  // compare for 1
  compare("config_master","cfg_pm_status","pgcb_hqm_pg_rdy_ack_b",SLA_FALSE,1'b1);
  // compare for 1
  // compare("config_master","cfg_pm_status","pm_fsm_d3tod0_ok",SLA_FALSE,1'b1);
  // Reason: The contents of the cfg_pm_status_r are only readable when this are power on or in one of the D0 states. 
  // In this case because you are in D0 state PM_FSM_D3TOD0_OK=1 will never be observed via. cfg read only by looking at vpd.
  // compare for 0
  compare("config_master","cfg_pm_status","hqm_in_d3",SLA_FALSE,1'b0);
  // 11.[PGCB] PGCB sets the Power FET control to "power-off."
  // compare for 1
  // The description of this register behavior is wrong. (will fix the rdl) 
  // This field reflects the inverse state of the pgcb_pg_req_b value. 
  // Meaning that when pgcb is power gating (powre down) this value is 1 and when pgcb is not power gating (power up) this value is 0.
  compare("config_master","cfg_pm_status","pmc_pgcb_fet_en_b",SLA_FALSE,1'b0);
  // compare for 1
  compare("config_master","cfg_pm_status","pgcb_fet_en_b",SLA_FALSE,1'b0);

  // 12.[FET] FET signals SAPMA when domain is powered-off.
  // 13.[SAPMA] SAPMA signals PGCB when the domain is powered-off
  // 14.[PGCB] PGCB enters IDLE state
  //compare for 2'b11 
  // What you get back is PMSM in “RUN” state (000001). Via cfg you will never see value other than in “RUN” state.
  compare("config_master","cfg_pm_status","pmsm",SLA_FALSE,2'b01);
  `ovm_info(get_full_name(),$sformatf("\n hqm_pwr_check_cfg_pm_status_for_D0_seq ended \n"),OVM_LOW)

  endtask : body

