//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------
// File   : hqm_trigger_test.svh
// Author : dsuvvari 
//-- Test
//-----------------------------------------------------------------------------------------------------
`ifndef HQM_TRIGGER_TEST__SV
`define HQM_TRIGGER_TEST__SV

import hqm_tb_cfg_sequences_pkg::*;


//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_trigger_test extends hqm_iosf_base_test;

   hqm_tap_rtdr_common_val_sim_component tap_rtdr_sim_comp;

  `ovm_component_utils(hqm_trigger_test)

  function new(string name = "hqm_trigger_test", ovm_component parent = null);
    super.new(name,parent);

    tap_rtdr_sim_comp = hqm_tap_rtdr_common_val_sim_component::type_id::create("hqm_tap_rtdr_val_sim_comp", this);
    `ovm_info("HQM_TRIGGER_TEST", "Completed HQM_TAP_RTDR_TEST test constructor function", OVM_NONE)
  endfunction

  function void connect();
    string target_phase;  

    target_phase = "WARM_RESET_PHASE";
    $value$plusargs("HQM_RTDR_TRIGGER_PHASE_BEFORE=%s", target_phase);

    super.connect();


    //-- RTDR_TRIGGER_PHASE     
    if ($test$plusargs("HAS_RTDR_TRIGGER_PHASE")) begin 
       i_hqm_tb_env.add_test_phase("RTDR_TRIGGER_PHASE", target_phase, "BEFORE");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "RTDR_TRIGGER_PHASE", "hqm_tap_rtdr_val_init_seq");
       `ovm_info("HQM_TRIGGER_TEST", $psprintf("Use:RTDR_TRIGGER_PHASE before %0s for hqm_tap_rtdr_val_init_seq", target_phase), OVM_NONE)
    end

   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_trigger_seq");
   `ovm_info("HQM_TRIGGER_TEST", $psprintf("Use:USER_DATA_PHASE for hqm_trigger_seq"), OVM_NONE)
  endfunction


  //------------------
  //-- doConfig() 
  //------------------
  function void do_config();
 
  endfunction

  function void set_config();  

  endfunction

  function void set_override();
  endfunction


endclass
`endif
