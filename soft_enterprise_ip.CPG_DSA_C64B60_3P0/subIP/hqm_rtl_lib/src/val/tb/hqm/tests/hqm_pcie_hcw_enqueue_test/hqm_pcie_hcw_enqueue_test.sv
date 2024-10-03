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

`ifndef HQM_PCIE_HCW_ENQUEUE_TEST__SV
`define HQM_PCIE_HCW_ENQUEUE_TEST__SV

`include "hqm_pcie_base_test.sv"
import hqm_tb_cfg_sequences_pkg::*;

`include "mem_rd_txn_delay.svh"  

class hqm_pcie_hcw_enqueue_test extends hqm_pcie_base_test;

  `ovm_component_utils(hqm_pcie_hcw_enqueue_test)
  IosfFabricVc          iosf_pvc_tlm;
  mem_rd_txn_delay CustMem64RdTxn;
  mem_rd_txn_delay CustMem32RdTxn;

  function new(string name = "hqm_pcie_hcw_enqueue_test", ovm_component parent = null);
    super.new(name,parent);
    CustMem64RdTxn = new();
    CustMem32RdTxn = new();
  endfunction

  function void build();

    super.build();

    set_override();
    do_config();
    set_config();

  endfunction

  function void connect();
    super.connect();
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_pcie_unalloc_bar_access_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_tb_cfg_user_data_file_mode_seq");

    // -- If we stall completions for CT scenario mask the below assertion -- //
    if($test$plusargs("expect_completion_timeout")) begin 
       i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_198");
       i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_198");
       i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_198");
       i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_198");
    end

  endfunction

  function void start_of_simulation();
	if(!$cast(iosf_pvc_tlm, i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc))
	  `ovm_error(get_name(),"Config setting for 'iosf_pvc_tlm' not of type IosfFabricVc")

    iosf_pvc_tlm.registerCallBack (CustMem64RdTxn, {Iosf::MRd64});
    iosf_pvc_tlm.registerCallBack (CustMem32RdTxn, {Iosf::MRd32});
    `ovm_info(get_type_name(), "Registered callbacks for MRd64 and MRd32 Txns", OVM_MEDIUM);
  endfunction: start_of_simulation;

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
  endfunction

  virtual protected function void set_override();
  endfunction
 
   virtual task run();
    `ovm_info(get_type_name(), "Entered body of hqm_pcie_hcw_enqueue_test run phase", OVM_MEDIUM);
  endtask: run

endclass
`endif
