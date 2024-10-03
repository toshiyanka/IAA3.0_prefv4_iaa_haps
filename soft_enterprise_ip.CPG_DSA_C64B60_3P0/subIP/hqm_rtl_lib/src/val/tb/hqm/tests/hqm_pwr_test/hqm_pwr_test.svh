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
// File   : hqm_pwr_test.svh
// Author : rsshekha
//-- Test
//-----------------------------------------------------------------------------------------------------
`ifndef HQM_PWR_TEST__SV
`define HQM_PWR_TEST__SV

import hqm_tb_cfg_sequences_pkg::*;
import hqm_tap_rtdr_common_val_seq_pkg::*;
import hqm_tap_rtdr_common_val_tb_pkg::*;



//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_pwr_test extends hqm_pwr_base_test;
    hqm_tap_rtdr_common_val_sim_component tap_rtdr_sim_comp;


  `ovm_component_utils(hqm_pwr_test)

  function new(string name = "hqm_pwr_test", ovm_component parent = null);
    super.new(name,parent);

    tap_rtdr_sim_comp = hqm_tap_rtdr_common_val_sim_component::type_id::create("hqm_tap_rtdr_val_sim_comp", this);
    `ovm_info("HQM_PWR_TEST", "Completed HQM_TAP_RTDR_TEST test constructor function", OVM_NONE)
  endfunction

  function void build();
  super.build();
     set_global_timeout(6000ms);
  endfunction

  function void connect();
    string target_phase;  
    string user_data_seq;

    
    target_phase = "WARM_RESET_PHASE";
    $value$plusargs("HW_FORCE_PWR_TEST_PHASE=%s", target_phase);

    user_data_seq = "hcw_ldb_test_hcw_smoke_seq";
    void'($value$plusargs("HQM_USER_DATA_SEQ_OVERRIDE=%0s", user_data_seq));
    ovm_report_info("HQM_PWR_TEST", $psprintf("USER_DATA_SEQ=%0s", user_data_seq), OVM_LOW);

    super.connect();
   
   //-- HW_RESET_FORCE_PWR_TEST_PHASE     
   if ($test$plusargs("HAS_HW_RESET_FORCE_PWR_ON_RTDR_PHASE")) begin 
       //--1: HW_RTDR_TEST_PHASE: hw_reset_force_pwr_on  (0 -> 1)
       i_hqm_tb_env.add_test_phase("HW_RTDR_TEST_PHASE", target_phase, "BEFORE");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "HW_RTDR_TEST_PHASE", "hqm_tap_rtdr_val_init_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:HW_RTDR_TEST_PHASE before %0s for hqm_tap_rtdr_val_init_seq", target_phase), OVM_NONE)

       //--2: CONFIG_PHASE runs hqm_tb_hcw_cfg_seq
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:CONFIG_PHASE for hqm_tb_hcw_cfg_seq"), OVM_NONE)
       
       //--3: USER_DATA_PHASE runs hqm_hw_reset_force_pwr_seq2 to check PM state 
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_hw_reset_force_pwr_seq2");   
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:USER_DATA_PHASE for hqm_hw_reset_force_pwr_seq2"), OVM_NONE)

       //--4: EXTRA_DATA_PHASE  runs hqm_tap_rtdr_val_init_seq  (2nd time)      
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_tap_rtdr_val_init_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:EXTRA_DATA_PHASE for hqm_tap_rtdr_val_init_seq"), OVM_NONE)           
   end

   //-- HW_RESET_FORCE_PWR_TEST_PHASE     
   if ($test$plusargs("HAS_HW_RESET_TEST_PHASE")) begin 
       i_hqm_tb_env.add_test_phase("HW_RESET_FORCE_PWR_TEST_PHASE", target_phase, "BEFORE");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "HW_RESET_FORCE_PWR_TEST_PHASE", "hqm_hw_reset_force_pwr_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:HW_RESET_FORCE_PWR_TEST_PHASE before %0s for hqm_hw_reset_force_pwr_seq", target_phase), OVM_NONE)

       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:CONFIG_PHASE for hqm_tb_hcw_cfg_seq"), OVM_NONE)
       
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_hw_reset_force_pwr_seq2");   
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:USER_DATA_PHASE for hqm_hw_reset_force_pwr_seq2"), OVM_NONE)           
   end
   
   //-- RTDR_TEST_PHASE     
   if ($test$plusargs("HAS_RTDR_TEST_PHASE")) begin 
       i_hqm_tb_env.add_test_phase("HW_RTDR_TEST_PHASE", target_phase, "BEFORE");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "HW_RTDR_TEST_PHASE", "hqm_tap_rtdr_val_init_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:HW_RTDR_TEST_PHASE before %0s for hqm_tap_rtdr_val_init_seq", target_phase), OVM_NONE)
   end
       
   if (!($test$plusargs("HQM_SKIP_HCW_TRAFFIC"))) begin  
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:CONFIG_PHASE for hqm_tb_hcw_cfg_seq"), OVM_NONE)           

      if(($test$plusargs("HQM_HCW_SMK_TRAFFIC"))) begin
         i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE", user_data_seq);
         `ovm_info("HQM_PWR_TEST", $psprintf("Use:USER_DATA_PHASE for %0s", user_data_seq), OVM_NONE)           
      end else begin
         i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hcw_perf_dir_ldb_test1_hcw_seq");
         `ovm_info("HQM_PWR_TEST", $psprintf("Use:USER_DATA_PHASE for hcw_perf_dir_ldb_test1_hcw_seq"), OVM_NONE)           
      end 
   end

   if (!($test$plusargs("HQM_SKIP_EXTRA_DATA_PHASE"))) begin  
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_pwr_extra_data_phase_seq");
       `ovm_info("HQM_PWR_TEST", $psprintf("Use:EXTRA_DATA_PHASE for hqm_pwr_extra_data_phase_seq"), OVM_NONE)           
   end

   if (!($test$plusargs("HQM_SKIP_EOT_SEQ"))) begin  
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
   end

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
