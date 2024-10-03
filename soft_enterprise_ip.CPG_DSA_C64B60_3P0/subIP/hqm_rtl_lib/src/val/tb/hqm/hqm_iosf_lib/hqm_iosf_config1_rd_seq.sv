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
`ifndef hqm_iosf_config1_rd_seq__SV
`define hqm_iosf_config1_rd_seq__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_config1_rd_seq extends hqm_iosf_prim_np_base_seq;

  `ovm_sequence_utils(hqm_iosf_config1_rd_seq,IosfAgtSeqr)

  local const string  CLASSNAME  = "hqm_iosf_config1_rd_seq ";


  rand int unsigned   reqTxnId;        // req transaction id
  bit                 expectRsp;       // Expect Rsp or not
  Iosf::data_t        cmplData[];      // Response data
  IosfTgtTxn          rxRspTgtTxn;     // Rsp Transaction
  string              msg;             // debug messages
  rand logic [7:0]    UR_sai;


  extern                function        new(string name = "hqm_iosf_config1_rd_seq");
  extern virtual        task            body();

  // Task to get responze for the particular txn id.
   task getRsp (output Iosf::data_t cmplData [], input int unsigned reqTxnId); 
      ovm_pkg::ovm_sequence_item rsp;
      get_response (rsp, reqTxnId);
      
      $cast (rxRspTgtTxn, rsp);
      $sformat (msg, "RSP reqTxnId = 0x%h , %s", 
                reqTxnId, rxRspTgtTxn.convert2string ());
      `ovm_info (CLASSNAME, msg, Iosf::VERBOSITY_ALL)
      if (rxRspTgtTxn.data.size () > 0) begin
         cmplData = new [rxRspTgtTxn.data.size ()];
         foreach (rxRspTgtTxn.data [idx]) begin
           cmplData [idx] = rxRspTgtTxn.data [idx];
           $sformat (msg, "Debug:  cmplData[%0d]=%0h", idx, cmplData[idx]);
           `ovm_info (CLASSNAME, msg, Iosf::VERBOSITY_ALL)
         end //foreach  
      end // if
   endtask: getRsp


endclass : hqm_iosf_config1_rd_seq

function hqm_iosf_config1_rd_seq::new(string name = "hqm_iosf_config1_rd_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_config1_rd_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];
  bit [3:0]             byte_en;

  iosfTxn = new("iosfTxn");

  data_i = new[1];
  data_i[0] = iosf_data;

  if (iosf_addr[1:0] != 0) begin
    byte_en = 4'h0;
    for (int i = iosf_addr[1:0] ; i < 4 ; i++) begin
      byte_en[i] = 1'b1;
    end
    iosf_addr[1:0] = 2'b00;
  end else begin
    byte_en = 4'hf;
  end

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = Iosf::CfgRd1;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = 0;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.length            = 1;
  iosfTxn.address           = iosf_addr;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i;
  iosfTxn.first_byte_en     = byte_en;
  iosfTxn.last_byte_en      = 4'h0;
  iosfTxn.reqLocked         = 0;  
  iosfTxn.compareType       = Iosf::CMP_EQ;
  iosfTxn.compareCompletion = 0;
  iosfTxn.waitForCompletion = 0;
  iosfTxn.pollingMode       = 0;
  get_next_tag();
  iosfTxn.tag               = iosf_tag;
  iosfTxn.expectRsp         = 1;
  iosfTxn.driveBadCmdParity =  $test$plusargs("HQM_CFG_RD_BAD_PARITY") ? 1 : 0;
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

  
  
  iosfTxn.set_transaction_id (reqTxnId);

  `ovm_send (iosfTxn)

    if($test$plusargs("BLOCKING_IOSF_TXN"))begin
      //`ifdef BLOCKIG_IOSF_TXN

  iosfTxn.waitForComplete();

  if (iosfTxn.cplStatus == 3'b000) begin //Successful Completion
    iosf_data = iosfTxn.cplData[0];

    if (iosf_exp_error) begin
      ovm_report_error(get_full_name(), $psprintf("CfgRd0 Address=0x%x BE=0x%01x Data=0x%08x, expected error",iosf_addr,byte_en,iosf_data), OVM_LOW);
    end else begin
      ovm_report_info(get_full_name(), $psprintf("CfgRd0 Address=0x%x BE=0x%01x Data=0x%08x",iosf_addr,byte_en,iosf_data), OVM_LOW);
    end
  end else begin
    if (iosf_exp_error) begin
      ovm_report_info(get_full_name(), $psprintf("CfgRd0 Address=0x%x BE=0x%01x expected error completion (0x%x)",iosf_addr,byte_en,iosfTxn.cplStatus), OVM_LOW);
    end else begin
      ovm_report_error(get_full_name(), $psprintf("CfgRd0 Address=0x%x BE=0x%01x unexpected error completion (0x%x)",iosf_addr,byte_en,iosfTxn.cplStatus), OVM_LOW);
    end
  end
//`endif
end

    if($test$plusargs("UR_TXN"))begin
              //unsupported ompletion check
      iosfTxn.waitForComplete();
  if (iosfTxn.cplStatus == 3'b001) //expect unsupported request Completion
    ovm_report_info(get_full_name(), $psprintf("CfgWr0 Address=0x%x BE=0x%01x Data=0x%08x completed successfully",iosf_addr,byte_en,iosf_data), OVM_LOW);
  else
    ovm_report_error(get_full_name(), $psprintf("CfgWr0 Address=0x%x BE=0x%01x Data=0x%08x error completion (0x%x)",iosf_addr,byte_en,iosf_data,iosfTxn.cplStatus), OVM_LOW);

  end

/*if (iosfTxn.expectRsp) begin
         $sformat (msg, "Launch Rsp TransID-0x%h", reqTxnId);
         `ovm_info (CLASSNAME, msg, Iosf::VERBOSITY_ALL)
         // Task to get response for the particular txn id. 
         getRsp (cmplData, reqTxnId); 
      end */
endtask : body  

`endif
