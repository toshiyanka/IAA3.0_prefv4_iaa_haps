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
`ifndef HQM_IOSF_PRIM_NP_BASE_SEQ__SV
`define HQM_IOSF_PRIM_NP_BASE_SEQ__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_np_base_seq extends IosfBaseRspSeq;

  `ovm_sequence_utils(hqm_iosf_prim_np_base_seq,IosfAgtSeqr)

  rand logic [63:0]     iosf_addr;
  rand Iosf::data_t     iosf_data;
  rand logic [7:0]      iosf_sai;
  rand logic            iosf_exp_error;
  static logic [7:0]    iosf_tag = 0;

  constraint deflt {
        soft iosf_sai == 8'h03;
        soft iosf_exp_error == 1'b0;
  }

  extern                function        new(string name = "hqm_iosf_prim_np_base_seq");

endclass : hqm_iosf_prim_np_base_seq

function hqm_iosf_prim_np_base_seq::new(string name = "hqm_iosf_prim_np_base_seq");
  super.new(name);
endfunction

`endif
