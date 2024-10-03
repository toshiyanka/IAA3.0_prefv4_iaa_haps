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

`ifndef hqm_pcie_error_test__SV
`define hqm_pcie_error_test__SV

`include "hqm_pcie_base_test.sv"
import hqm_tb_cfg_sequences_pkg::*;

class hqm_pcie_error_test extends hqm_pcie_base_test;

  `ovm_component_utils(hqm_pcie_error_test)
    string        seq_name = "";

  function new(string name = "hqm_pcie_error_test", ovm_component parent = null);
    super.new(name,parent);
     $value$plusargs("IOSF_PRIM_FILE=%s",seq_name);

     if (seq_name == "") begin
      `ovm_info("IOSF_PRIM_FILE_SEQ","+IOSF_PRIM_FILE=<file name> not set",OVM_LOW)
    end else begin
      `ovm_info("IOSF_PRIM_FILE_SEQ",$psprintf("+IOSF_PRIM_FILE=%s",seq_name),OVM_LOW)
    end


  endfunction

  function void build();

    super.build();

    set_override();
    do_config();
    set_config();

  endfunction

  function void connect();
    super.connect();
       if (seq_name == "hqm_sla_pcie_cfg_error_seq") begin
            i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
            i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_sla_pcie_cfg_error_seq");
             //i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_cfg_file_mode_seq");
             i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");



    end

     if (seq_name == "hqm_sla_pcie_mem_poison_seq") begin
            i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq");
           i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_sla_pcie_mem_poison_seq");
           i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");

            
    end

   if (seq_name == "hqm_sla_pcie_mem_malform_seq") begin
            i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_cfg_file_mode_seq"); 
            i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_sla_pcie_mem_malform_seq");
             i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_config_file_mode_seq");


    end

   

    endfunction

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
  endfunction

  virtual protected function void set_override();
  endfunction
 
   virtual task run();
    `ovm_info(get_type_name(), "Entered body of hqm_pcie_error_test run phase", OVM_MEDIUM);
  endtask: run

endclass
`endif
