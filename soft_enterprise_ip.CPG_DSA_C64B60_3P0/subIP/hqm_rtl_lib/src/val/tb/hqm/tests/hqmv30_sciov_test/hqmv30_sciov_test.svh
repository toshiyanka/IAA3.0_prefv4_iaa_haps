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
//-- Test
//-----------------------------------------------------------------------------------------------------

import hqm_tb_cfg_sequences_pkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqmv30_sciov_test extends hqm_base_test;

  `ovm_component_utils(hqmv30_sciov_test)

  function new(string name = "hqmv30_sciov_test", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  function void connect();
    string target_phase;  
    
    target_phase = "WARM_RESET_PHASE";
    $value$plusargs("HW_FORCE_PWR_TEST_PHASE=%s", target_phase);	
	    
    super.connect();
 
    `ifdef IP_TYP_TE
      //-- HW_RESET_FORCE_PWR_TEST_PHASE     
      if ($test$plusargs("HAS_HW_RESET_TEST_PHASE")) begin 
       i_hqm_tb_env.add_test_phase("HW_RESET_FORCE_PWR_TEST_PHASE", target_phase, "BEFORE");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "HW_RESET_FORCE_PWR_TEST_PHASE", "hqm_hw_reset_force_pwr_seq");
       `ovm_info("i_hqm_tb_env", $psprintf("Use:HW_RESET_FORCE_PWR_TEST_PHASE before %0s for hqm_hw_reset_force_pwr_seq", target_phase), OVM_NONE)
      end
    `endif
        
    //-- CONFIG_PHASE
    //i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hcw_pf_test_cfg_seq");
    
    //-- USER_DATA_PHASE 
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqmv30_sciov_test_seq");
    
    `ifdef IP_TYP_TE    
      if (!$test$plusargs("HQM_FLUSH_PHASE_EOT_CHECK_SEQ")) begin 
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");   
      end else begin
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_eot_check_seq");   
      end
    `endif           
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
