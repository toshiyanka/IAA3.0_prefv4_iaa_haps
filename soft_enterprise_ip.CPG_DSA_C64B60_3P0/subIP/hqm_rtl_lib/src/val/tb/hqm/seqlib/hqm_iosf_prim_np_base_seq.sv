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

  rand   logic [63:0]   iosf_addr;
  rand   int            reg_size;
  rand   Iosf::data_t   iosf_data;
  rand   logic [7:0]    iosf_sai;
  rand   logic          iosf_exp_error;
  rand int              iosf_wait_for_completion;
  rand   logic [22:0]   iosf_pasidtlp;
  rand bit [31:0]       ecrc;             
  static logic [9:0]    iosf_tag = 0;
  static bit            ten_bit_tag_en = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));
  static bit            first_call = 1;

  logic [2:0]			iosf_cpl_status;
  rand logic			iosf_EP;

  constraint deflt {
        soft reg_size == 32;
        soft iosf_sai == 8'h03;
        soft iosf_exp_error == 1'b0;
        soft iosf_EP		== 1'b0;
        soft iosf_pasidtlp == 23'h00;
        soft iosf_wait_for_completion   == 1;
        soft ecrc == 32'h0000_0000;
  }

  extern                function        new(string name = "hqm_iosf_prim_np_base_seq");
  extern                task            pre_body();
  extern                task            post_body();
  extern                task            pre_do(bit is_item);
  extern                function   void post_do(ovm_sequence_item this_item);
  extern                function   void get_next_tag();

endclass : hqm_iosf_prim_np_base_seq

function hqm_iosf_prim_np_base_seq::new(string name = "hqm_iosf_prim_np_base_seq");
  super.new(name);
  `ovm_info(get_full_name(), $psprintf("Called new of hqm_iosf_prim_np_base_seq :: ten_bit_tag_en (0x%0x) and current tag (0x%0x), first_call (0x%0x)", ten_bit_tag_en, iosf_tag, first_call), OVM_DEBUG);
  if(ten_bit_tag_en && (iosf_tag == 0) && first_call ) begin 
    // -- As per IOSF_ECN https://sharepoint.amr.ith.intel.com/sites/MDGArchMain/Converged/SIGA/IOSF%20Specs/ECN/1.2%20ECNs/IOSF_1.3_10bitTagSupport.docx -- //
    // -- Which states that 9:8 bits should be non-zero in NP request if 10 bit tags are supported -- //

    `ovm_info(get_full_name(), $psprintf("Fixing 9:8 bits of tag per IOSF ECN, since ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_LOW);
    iosf_tag[9:8] = 2'b_01; 
    `ovm_info(get_full_name(), $psprintf("Fixed 9:8 bits of tag per IOSF ECN, next tag (0x%0x)", iosf_tag), OVM_LOW);
    first_call = 1'b_0;
  end
  else if (iosf_tag == 0) begin
    `ovm_info(get_full_name(), $psprintf("Not fixing 9:8 bits of tag per IOSF ECN, since ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_LOW);
  end

endfunction

task hqm_iosf_prim_np_base_seq::pre_body();
  `ovm_info(get_full_name(), $psprintf("Called pre_body of hqm_iosf_prim_np_base_seq :: ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_DEBUG);
endtask

task hqm_iosf_prim_np_base_seq::post_body();
  `ovm_info(get_full_name(), $psprintf("Called post_body of hqm_iosf_prim_np_base_seq :: ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_DEBUG);
endtask

task hqm_iosf_prim_np_base_seq::pre_do(bit is_item);
  `ovm_info(get_full_name(), $psprintf("Called pre_do of hqm_iosf_prim_np_base_seq :: ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_DEBUG);
endtask

function void hqm_iosf_prim_np_base_seq::post_do(ovm_sequence_item this_item);
  `ovm_info(get_full_name(), $psprintf("Called post_do of hqm_iosf_prim_np_base_seq :: ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_DEBUG);
endfunction

function void hqm_iosf_prim_np_base_seq::get_next_tag();
  
  iosf_tag++;
  if(iosf_tag == 0 && ten_bit_tag_en) begin 
    iosf_tag[9:8] = 2'b_01;
    `ovm_info(get_full_name(), $psprintf("Tag Rollover: ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_LOW)
  end
  else if(iosf_tag == 'h_100 && ten_bit_tag_en == 0) begin
    iosf_tag[9:8] = 2'b_00;
    `ovm_info(get_full_name(), $psprintf("Tag Rollover: ten_bit_tag_en (0x%0x) and current tag (0x%0x)", ten_bit_tag_en, iosf_tag), OVM_LOW)
  end

endfunction

`endif
