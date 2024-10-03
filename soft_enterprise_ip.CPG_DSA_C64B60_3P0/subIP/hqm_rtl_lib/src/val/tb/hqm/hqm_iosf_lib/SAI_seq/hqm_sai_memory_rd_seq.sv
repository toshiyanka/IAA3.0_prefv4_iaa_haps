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
`ifndef hqm_sai_memory_rd_seq__SV
`define hqm_sai_memory_rd_seq__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_sai_memory_rd_seq extends hqm_iosf_prim_np_base_seq;

  `ovm_sequence_utils(hqm_sai_memory_rd_seq,IosfAgtSeqr)

   rand logic [7:0]      Iosf_sai;

  extern                function        new(string name = "hqm_sai_memory_rd_seq");
  extern virtual        task            body();

endclass : hqm_sai_memory_rd_seq

function hqm_sai_memory_rd_seq::new(string name = "hqm_sai_memory_rd_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_sai_memory_rd_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = (iosf_addr[63:32] == 32'h0) ? Iosf::MRd32 : Iosf::MRd64;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = 0;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.length            = 1;
  iosfTxn.address           = iosf_addr;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i;
  iosfTxn.first_byte_en     = 4'hf;
  iosfTxn.last_byte_en      = 4'h0;
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
  iosfTxn.sai               =  Iosf_sai;

  

  `ovm_send (iosfTxn)

  
  if($test$plusargs("BLOCKING_IOSF_TXN"))begin
 
  iosfTxn.waitForComplete();

  if (iosfTxn.cplStatus == 3'b000) begin //Successful Completion
    iosf_data = iosfTxn.cplData[0];
    end
 end   

  if($test$plusargs("UR_TXN"))begin
              //unsupported ompletion check
      iosfTxn.waitForComplete();
  if (iosfTxn.cplStatus == 3'b001) //expect unsupported request Completion
    ovm_report_info(get_full_name(), $psprintf("MEmrd0 Address=0x%x SAI=0x%01x completed successfully",iosf_addr,Iosf_sai), OVM_LOW);
  else
    ovm_report_error(get_full_name(), $psprintf("Memrd0 Address=0x%x sai=0x%01x  error completion (0x%x)",iosf_addr,Iosf_sai,iosfTxn.cplStatus), OVM_LOW);

  end

  if($test$plusargs("DENIED_SAI_TXN"))begin
              //unsupported ompletion check
      iosfTxn.waitForComplete();

     
  
  if (iosfTxn.cplStatus == 3'b000) begin //Successful Completion with 000 data
    iosf_data = iosfTxn.cplData[0];
  
     if (iosf_data != 32'h00000000)begin
        `ovm_error("Read data mistmatch_received",$psprintf(" read data does not match  (0x%08x) with SAI (0x%01x) ",iosf_data[0],Iosf_sai))
       end

     end

     if (iosfTxn.cplStatus == 3'b000) //expect succesful Completion
    ovm_report_info(get_full_name(), $psprintf("Memrd0 Address=0x%x  Data=0x%08x completed successfully",iosf_addr,iosf_data), OVM_LOW);
  else
    ovm_report_error(get_full_name(), $psprintf("Memrd0 Address=0x%x  Data=0x%08x error completion (0x%x)",iosf_addr,iosf_data,iosfTxn.cplStatus), OVM_LOW);



           
  
   end //arg end

 

endtask : body  

`endif
