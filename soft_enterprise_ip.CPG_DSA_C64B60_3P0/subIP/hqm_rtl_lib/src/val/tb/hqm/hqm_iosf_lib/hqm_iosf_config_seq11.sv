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
`ifndef hqm_iosf_config_seq11__SV
`define hqm_iosf_config_seq11__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_config_seq11 extends hqm_iosf_prim_np_base_seq;

  `ovm_sequence_utils(hqm_iosf_config_seq11,IosfAgtSeqr)

  rand logic [63:0]     iosf_addr;
  rand Iosf::data_t     iosf_data[];
  rand logic [7:0]      iosf_sai;
  rand int unsigned iosf_length ;


  constraint deflt { soft iosf_sai == 8'h03; }

  extern                function        new(string name = "hqm_iosf_config_seq11");
  extern virtual        task            body();

endclass : hqm_iosf_config_seq11

function hqm_iosf_config_seq11::new(string name = "hqm_iosf_config_seq11");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_config_seq11::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  data_i = iosf_data;
  data_i[0] = 32'hFF;

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = Iosf::CfgWr0;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = 0;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.length            = iosf_length;
  iosfTxn.errorPresent      = 0; 
  iosfTxn.address           = iosf_addr;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i; 
  iosfTxn.first_byte_en     = 4'hf;
  iosfTxn.last_byte_en      = (data_i.size() > 1) ? 4'hf : 4'h0;
  iosfTxn.reqLocked         = 0;  
  iosfTxn.compareType       = Iosf::CMP_EQ;
  iosfTxn.compareCompletion = 0;
  iosfTxn.waitForCompletion = 0;
  iosfTxn.pollingMode       = 0;
  get_next_tag();
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

  iosfTxn.waitForComplete();

 

endtask : body  

`endif
