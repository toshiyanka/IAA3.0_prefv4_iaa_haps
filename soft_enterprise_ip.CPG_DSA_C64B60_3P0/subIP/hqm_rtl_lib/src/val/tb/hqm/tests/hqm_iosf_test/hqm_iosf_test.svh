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
// File   : hqm_iosf_test.svh
// Author : rsshekha
//-- Test
//-----------------------------------------------------------------------------------------------------
`ifndef HQM_IOSF_TEST__SV
`define HQM_IOSF_TEST__SV

import hqm_tb_cfg_sequences_pkg::*;


//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------

typedef enum bit [7:0] {
  REGIO_EPSPEC = 8'b0001_1111,
  MSGD_EPSPEC  = 8'b0110_1111,
  SIMPLE_EPSPEC = 8'b1010_0000
} hqm_ep_opcodes_e; 

class hqm_iosf_test extends hqm_iosf_base_test;

  `ovm_component_utils(hqm_iosf_test)

  function new(string name = "hqm_iosf_test", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build();
  super.build();
     set_global_timeout(6000ms);
  endfunction

  function void connect();
   bit skip_hcw_cfg_seq, skip_eot_seq, epspec_seq, has_trf_on;
   has_trf_on=0;
   $value$plusargs("HQM_IOSF_USR_TRF=%d", has_trf_on);

   super.connect();

   if (!$value$plusargs("HQM_SKIP_HCW_CFG_SEQ=%b",skip_hcw_cfg_seq) || has_trf_on)
       skip_hcw_cfg_seq = 1'b0;
   if (!$value$plusargs("HQM_SKIP_EOT_SEQ=%b",skip_eot_seq) || has_trf_on)
       skip_eot_seq = 1'b0;
   
    
   if (!skip_hcw_cfg_seq)    
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");

   i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_iosf_user_data_phase_seq");

   if (!skip_eot_seq) begin
      i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_iosf_eot_seq"); 
   end

   if($value$plusargs("HQM_EPSPEC_SEQ=%b",epspec_seq))
       epspec_seq = 1'b1;
   
   if(epspec_seq) begin
     i_hqm_tb_env.iosf_svc.common_cfg_i.add_opcode_map(8'h21, {REGIO_EPSPEC}); 
     i_hqm_tb_env.iosf_svc.common_cfg_i.add_opcode_map(8'h21, {MSGD_EPSPEC}); 
     i_hqm_tb_env.iosf_svc.common_cfg_i.add_opcode_map(8'h21, {SIMPLE_EPSPEC}); 
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
