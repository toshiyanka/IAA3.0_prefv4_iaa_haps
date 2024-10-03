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
`ifndef mix_test__SV
`define mix_test__SV

import IosfPkg::*;
import hqm_tb_sequences_pkg::*;
//ns: deprecated import hcw_raw_sequences_pkg::*;
import hqm_saola_pkg::*;
import sla_pkg::*;
//import hqm_core_saola_pkg::*; 
//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class mix_test extends hqm_base_test;

  `ovm_component_utils(mix_test)

    string        seq_name = "";


  function new(string name = "mix_test", ovm_component parent = null);
    super.new(name,parent);
    $value$plusargs("IOSF_PRI_FILE=%s",seq_name);

     if (seq_name == "") begin
      `ovm_info("IOSF_PRI_FILE_SEQ","+IOSF_PRI_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("IOSF_PRI_FILE_SEQ",$psprintf("+IOSF_PRI_FILE=%s",seq_name),OVM_LOW)
    end

  endfunction

  function void connect();
    super.connect();
  // i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","cfg_common_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");

  
   if (seq_name == "mix_cfg_mem_seq") begin
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","mix_cfg_mem_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");

       end

   if (seq_name == "mix_mem_cfg_seq") begin
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","mix_mem_cfg_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");

       end


     if (seq_name == "mix_generic_seq") begin
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","mix_generic_seq");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");

       end

        if (seq_name == "mix_generic_seq1") begin
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","mix_generic_seq1");
       i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");

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
