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
`ifndef HQM_UE_CPL_SEQ__SV
`define HQM_UE_CPL_SEQ__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_ue_cpl_seq extends IosfSendTxnSeq;

  `ovm_sequence_utils(hqm_ue_cpl_seq,IosfAgtSeqr)

  rand Iosf::data_t     iosf_data[];
  rand logic [7:0]      iosf_sai;
  rand logic [15:0]     iosf_req_id;
  rand logic [9:0]      iosf_tag;
  rand bit [3:0]       iosf_cpl_status;
  rand bit errorpresent = 1'b0; 
  constraint deflt_ep { soft errorpresent == 1'b0; }

  extern                function        new(string name = "hqm_ue_cpl_seq");
  extern virtual        task            body();

endclass : hqm_ue_cpl_seq

function hqm_ue_cpl_seq::new(string name = "hqm_ue_cpl_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_ue_cpl_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  data_i = iosf_data;

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = Iosf::Cpl;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = iosf_req_id;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.length            = 0;
  iosfTxn.errorPresent      = errorpresent;
  iosfTxn.address           = 0;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i;
  iosfTxn.first_byte_en     = iosf_cpl_status; //-- sending  completion 
  iosfTxn.last_byte_en      = 4'h4;
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

  `ovm_send (iosfTxn)

  ovm_report_info(get_full_name(), $psprintf("cpl reqId=0x%x SAI=0x%02x Data=0x%08x",iosf_req_id,iosf_sai,data_i[0]), OVM_LOW);

endtask : body  

`endif
