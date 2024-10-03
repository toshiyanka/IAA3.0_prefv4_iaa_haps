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
`ifndef HQM_HVM_TEST__SV
`define HQM_HVM_TEST__SV

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_hvm_test extends hqm_base_test;

  `ovm_component_utils(hqm_hvm_test)

  function new(string name = "hqm_hvm_test", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  function void connect();
    string user_data_seq;

    super.connect();

    user_data_seq = "hqm_tb_cfg_user_data_file_mode_seq";
    void'($value$plusargs("HQM_USER_DATA_SEQ_OVERRIDE=%0s", user_data_seq));
    `ovm_info("HQM_HVM_TEST", $psprintf("USER_DATA_SEQ=%0s", user_data_seq), OVM_LOW);

    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE",user_data_seq);
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


endclass: hqm_hvm_test
`endif //HQM_HVM_TEST__SV
