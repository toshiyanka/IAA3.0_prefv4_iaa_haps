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
`ifndef HQM_PCIE_RNDCFG_TEST_
`define HQM_PCIE_RNDCFG_TEST_

import hqm_tb_cfg_sequences_pkg::*;

`include "rndcfg_mem_rd_txn_override.svh"  

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
// class hqm_pcie_rndcfg_test extends hqm_pcie_base_test;
 class hqm_pcie_rndcfg_test extends hqm_base_test;

   IosfFabricVc          iosf_pvc_tlm;
   rndcfg_mem_rd_txn_override CustMem64RdTxn;
   rndcfg_mem_rd_txn_override CustMem32RdTxn;

  `ovm_component_utils(hqm_pcie_rndcfg_test)

  function new(string name = "hqm_pcie_rndcfg_test", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build();
    super.build();
    set_override();
    do_config();
    set_config();
  endfunction: build;

  function void connect();
    super.connect();
//ADP to fix
//    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_sla_pcie_cfg_seq");
//    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","TRAINING_PHASE","hqm_sla_pcie_init_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_tb_cfg_user_data_file_mode_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_tb_hcw_eot_file_mode_seq");
  endfunction

  function void start_of_simulation();
	if(!$cast(iosf_pvc_tlm, i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc))
	  `ovm_error(get_name(),"Config setting for 'iosf_pvc_tlm' not of type IosfFabricVc")

    iosf_pvc_tlm.registerCallBack (CustMem64RdTxn, {Iosf::MRd64});
    iosf_pvc_tlm.registerCallBack (CustMem32RdTxn, {Iosf::MRd32});
  endfunction: start_of_simulation;



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
