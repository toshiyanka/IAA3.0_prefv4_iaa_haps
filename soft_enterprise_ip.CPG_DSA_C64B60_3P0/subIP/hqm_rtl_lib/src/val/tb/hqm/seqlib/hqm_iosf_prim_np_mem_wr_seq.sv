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
`ifndef HQM_IOSF_PRIM_NP_MEM_WR_SEQ__SV
`define HQM_IOSF_PRIM_NP_MEM_WR_SEQ__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_np_mem_wr_seq extends IosfSendTxnSeq;

  `ovm_sequence_utils(hqm_iosf_prim_np_mem_wr_seq,IosfAgtSeqr)

  rand logic [63:0]     iosf_addr;
  rand Iosf::data_t     iosf_data[];
  rand logic [7:0]      iosf_sai;
  rand logic [3:0]      iosf_first_be;
  rand logic [3:0]      iosf_last_be;
  rand logic [15:0]     iosf_reqid;
  rand logic [2:0]      iosf_tc;
  rand logic [1:0]      iosf_ph;
  rand logic [9:0]      iosf_tag_base;
  static logic [9:0]    iosf_tag = 0;
  rand logic		iosf_EP;
  rand logic [22:0]     iosf_pasidtlp;
  rand bit [31:0]       ecrc;             

  IosfTxn               iosfTxn;

  constraint deflt {
                     soft iosf_sai == 8'h03;
                     soft iosf_reqid == 16'h0000;
                     soft iosf_tc == 3'h0;
                     soft iosf_ph == 2'h0;
                     soft iosf_tag_base == 9'h000;
                     soft iosf_EP == 1'b0;
                     soft iosf_pasidtlp == 23'h00;
                     soft ecrc == 32'h0000_0000;
                   }

  constraint c_byte_en {
                         solve iosf_data before iosf_first_be, iosf_last_be;

                         soft iosf_first_be == 4'hf;
                         if (iosf_data.size() > 1)
                           soft iosf_last_be == 4'hf;
                         else
                           soft iosf_last_be == 4'h0;
                       }

  extern                function        new(string name = "hqm_iosf_prim_np_mem_wr_seq");
  extern virtual        task            body();

endclass : hqm_iosf_prim_np_mem_wr_seq

function hqm_iosf_prim_np_mem_wr_seq::new(string name = "hqm_iosf_prim_np_mem_wr_seq");
  super.new(name);

  iosf_reqid = 0;
  iosf_tc = 3'h0;
  iosf_ph = 2'h0;
  iosf_tag_base = 0;
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_prim_np_mem_wr_seq::body();
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  data_i = iosf_data;

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = (iosf_addr[63:32] == 32'h0) ? Iosf::NPMWr32 : Iosf::NPMWr64;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = iosf_tc;
  iosfTxn.reqID             = iosf_reqid;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = iosf_ph;
  iosfTxn.length            = data_i.size();
  iosfTxn.address           = iosf_addr;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i;
  iosfTxn.first_byte_en     = iosf_first_be;
  iosfTxn.last_byte_en      = iosf_last_be;
  iosfTxn.reqLocked         = 0;  
  iosfTxn.compareType       = Iosf::CMP_EQ;
  iosfTxn.compareCompletion = 0;
  iosfTxn.waitForCompletion = 0;
  iosfTxn.pollingMode       = 0;
  iosfTxn.tag               = (iosf_tag + iosf_tag_base) & 'h3ff;
  iosfTxn.expectRsp         = 0;
  iosfTxn.driveBadCmdParity =  0;
  iosfTxn.driveBadDataParity =  0;
  iosfTxn.driveBadDataParityCycle =  0;
  iosfTxn.driveBadDataParityPct   =  0;
  iosfTxn.reqGap            =  0;
  iosfTxn.chain             =  1'b0;
  iosfTxn.sai               =  iosf_sai;
  iosfTxn.errorPresent		  =  iosf_EP;
  iosfTxn.pasidtlp		      =  iosf_pasidtlp;
  iosfTxn.ecrc              =  ecrc;

  iosf_tag++;

  `ovm_send (iosfTxn)

  ovm_report_info(get_full_name(), $psprintf("MWr64 Address=0x%x SAI=0x%02x Data=0x%08x",iosf_addr,iosf_sai,data_i[0]), OVM_LOW);

endtask : body  

`endif
