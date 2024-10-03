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
`ifndef hqm_iosf_prim_msg_seq__SV
`define hqm_iosf_prim_msg_seq__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_msg_seq extends IosfSendTxnSeq;

  `ovm_sequence_utils(hqm_iosf_prim_msg_seq,IosfAgtSeqr)

  rand logic [63:0]     iosf_addr;
  rand Iosf::data_t     iosf_data[];
  rand logic [7:0]      iosf_sai;
       logic [7:0]      iosf_sai_set;
  static logic [7:0]    iosf_tag = 0;
  rand Iosf::iosf_cmd_t  iosf_cmd;
  constraint deflt { soft iosf_sai == 8'h00; }
  //all posted messge
  constraint cmd_c {iosf_cmd inside 
{ Iosf::Msg0, Iosf::Msg1, Iosf::Msg2,Iosf::Msg3, Iosf::Msg4, Iosf::Msg5, Iosf::Msg6, Iosf::Msg7,
  Iosf::MsgD0, Iosf::MsgD1,Iosf::MsgD2, Iosf::MsgD3, Iosf::MsgD4,Iosf::MsgD5, Iosf::MsgD6,Iosf::MsgD7};}


  extern                function        new(string name = "hqm_iosf_prim_msg_seq");
  extern virtual        task            body();

endclass : hqm_iosf_prim_msg_seq

function hqm_iosf_prim_msg_seq::new(string name = "hqm_iosf_prim_msg_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_prim_msg_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  data_i = iosf_data;

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = iosf_cmd;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = 0;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.length            = data_i.size();
  iosfTxn.address           = iosf_addr;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i;
  if($test$plusargs("TYPE0"))begin
  iosfTxn.first_byte_en     = 4'hE;
end 
 
  if($test$plusargs("TYPE1"))begin
  iosfTxn.first_byte_en     = 4'hf;
end 
  iosfTxn.last_byte_en      = 4'h7;
  iosfTxn.reqLocked         = 0;  
  iosfTxn.compareType       = Iosf::CMP_EQ;
  iosfTxn.compareCompletion = 0;
  iosfTxn.waitForCompletion = 0;
  iosfTxn.pollingMode       = 0;
  iosfTxn.tag               = iosf_tag;
  iosfTxn.expectRsp         = 0;
  iosfTxn.driveBadCmdParity =  0;
  iosfTxn.driveBadDataParity =  0;
  iosfTxn.driveBadDataParityCycle =  0;
  iosfTxn.driveBadDataParityPct   =  0;
  iosfTxn.reqGap            =  0;
  iosfTxn.chain             =  1'b0;
  iosfTxn.sai               =  iosf_sai;

  iosf_tag++;

  ovm_report_info(get_full_name(), $psprintf("Msg4_Send iosf_cmd=%0s Address=0x%x Data=0x%08x iosf_sai=%0d/%0d", iosf_cmd.name(), iosf_addr, data_i[0], iosf_sai, iosfTxn.sai), OVM_LOW);
  `ovm_send (iosfTxn)


endtask : body  

`endif
