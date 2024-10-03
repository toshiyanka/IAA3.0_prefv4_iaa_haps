//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2017 Intel Corporation All Rights Reserved.
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
//-- Prim_rst_b asserted when prim_clk is not active
//-----------------------------------------------------------------------------------------------------

import hqm_tb_sequences_pkg::*;

class hqm_prim_rst_no_clk_seq extends sla_sequence_base;

  `ovm_object_utils(hqm_prim_rst_no_clk_seq)

  hqm_tb_cfg2_file_mode_seq     i_hqm_tb_cfg2_file_mode_seq;
  test_hqm_ral_attr_seq         i_hqm_ral_attr_seq;

  //----------------------------------------------
  //-- new()
  //----------------------------------------------  
  function new(string name = "hqm_prim_rst_no_clk_seq");
    super.new(name); 
  endfunction

  //----------------------------------------------
  //-- body()
  //----------------------------------------------  
  virtual task body();
    chandle             force_async_prim_rst_b_handle;
    sla_sm_env          sm;
    sla_ral_env         ral;

    `sla_assert($cast(sm,sla_sm_env::get_ptr()), ("Unable to get handle to SM."))

    `sla_assert($cast(ral,sla_ral_env::get_ptr()), ("Unable to get handle to RAL."))

    ral.reset_regs(); 

    force_async_prim_rst_b_handle = SLA_VPI_get_handle_by_name("hqm_tb_top.force_async_prim_rst_b",0);

    hqm_seq_put_value(force_async_prim_rst_b_handle, 1'b1);

    #200ns;

    hqm_seq_put_value(force_async_prim_rst_b_handle, 1'b0);

    #100ns;

    `ovm_do(i_hqm_tb_cfg2_file_mode_seq)

    `ovm_do(i_hqm_ral_attr_seq)

  endtask : body

endclass : hqm_prim_rst_no_clk_seq
