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

`ifndef HQM_TLP_LENGTH_TEST__SV
`define HQM_TLP_LENGTH_TEST__SV

`include "hqm_pcie_base_test.sv"
import hqm_tb_cfg_sequences_pkg::*;

class hqm_tlp_length_test extends hqm_pcie_base_test;

  `ovm_component_utils(hqm_tlp_length_test)
  function new(string name = "hqm_tlp_length_test", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build();

    super.build();

    set_override();
    do_config();
    set_config();

  endfunction

  function void connect();
    super.connect();
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_tlp_length_seq");
   
    // -- Masking error for Max read request size surpassed by MRd request length. Since, test sends -- //
    // -- lengths varying from 1-1024 DW and checks response for same.                               -- //
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_136");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_136");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_136");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_136");

    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_078");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_078");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_078");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_078");

  endfunction

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
  endfunction

  virtual protected function void set_override();
  endfunction
 
   virtual task run();
    `ovm_info(get_type_name(), "Entered body of hqm_tlp_length_test run phase", OVM_MEDIUM);
  endtask: run

endclass
`endif
