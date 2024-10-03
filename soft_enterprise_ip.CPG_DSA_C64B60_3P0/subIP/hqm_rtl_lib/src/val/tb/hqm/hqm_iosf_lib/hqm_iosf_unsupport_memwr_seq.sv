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
`ifndef hqm_iosf_unsupport_memwr_seq__SV
`define hqm_iosf_unsupport_memwr_seq__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_unsupport_memwr_seq extends IosfSendTxnSeq;

  `ovm_sequence_utils(hqm_iosf_unsupport_memwr_seq,IosfAgtSeqr)

   rand Iosf::iosf_cmd_t  iosf_cmd32;
  rand Iosf::iosf_cmd_t  iosf_cmd64;
  rand logic [7:0]    UR_sai;


  rand logic [63:0]     iosf_addr;
  rand Iosf::data_t     iosf_data[];
  rand logic [7:0]      iosf_sai;
  static logic [7:0]    iosf_tag = 0;

  constraint deflt { soft iosf_sai == 8'h03; }
  constraint cmd_c {iosf_cmd32 inside {Iosf::NPMWr32, Iosf::IOWr, Iosf::LTMWr32};}
constraint cmd_d {iosf_cmd64 inside {Iosf::NPMWr64, Iosf::LTMWr64};}


  extern                function        new(string name = "hqm_iosf_unsupport_memwr_seq");
  extern virtual        task            body();

endclass : hqm_iosf_unsupport_memwr_seq

function hqm_iosf_unsupport_memwr_seq::new(string name = "hqm_iosf_unsupport_memwr_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_unsupport_memwr_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  data_i = iosf_data;

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = (iosf_addr[63:32] == 32'h0) ? iosf_cmd32 : iosf_cmd64;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = 0;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.length            = data_i.size();
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
  iosfTxn.tag               = iosf_tag;
  iosfTxn.expectRsp         = 0;
  iosfTxn.driveBadCmdParity =  0;
  iosfTxn.driveBadDataParity =  0;
  iosfTxn.driveBadDataParityCycle =  0;
  iosfTxn.driveBadDataParityPct   =  0;
  iosfTxn.reqGap            =  0;
  iosfTxn.chain             =  1'b0;

  if($test$plusargs("UR_SAI_TXN"))begin
     iosfTxn.sai               =  UR_sai;
  end 
  else begin
  iosfTxn.sai               =  iosf_sai;
   end 
  iosf_tag++;

  `ovm_send (iosfTxn)

  ovm_report_info(get_full_name(), $psprintf("MWr64 Address=0x%x SAI=0x%02x Data=0x%08x",iosf_addr,iosf_sai,data_i[0]), OVM_LOW);

  if($test$plusargs("UR_TXN"))begin
              //unsupported ompletion check
      iosfTxn.waitForComplete();
  if (iosfTxn.cplStatus == 3'b001) //expect unsupported request Completion
    ovm_report_info(get_full_name(), $psprintf("Wr0 Address=0x%x   completed successfully",iosf_addr), OVM_LOW);
  else
    ovm_report_error(get_full_name(), $psprintf("Wr0 Address=0x%x   error completion (0x%x)",iosf_addr,iosfTxn.cplStatus), OVM_LOW);

  end

endtask : body  

`endif
