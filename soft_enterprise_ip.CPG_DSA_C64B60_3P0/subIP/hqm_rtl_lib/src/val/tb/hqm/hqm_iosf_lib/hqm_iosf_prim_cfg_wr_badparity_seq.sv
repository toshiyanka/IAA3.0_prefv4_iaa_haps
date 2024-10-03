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
`ifndef hqm_iosf_prim_cfg_wr_badparity_seq__SV
`define hqm_iosf_prim_cfg_wr_badparity_seq__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_cfg_wr_badparity_seq extends hqm_iosf_prim_np_base_seq;

  `ovm_sequence_utils(hqm_iosf_prim_cfg_wr_badparity_seq,IosfAgtSeqr)
  

   rand bit m_driveBadCmdParity; ; // toggles cmd parity signal
   rand bit m_driveBadDataParity; //  toggles data[0] when set
   rand int unsigned m_driveBadDataParityCycle;// bad parity data cycle
   rand int unsigned m_driveBadDataParityPct; // more than one cycle

  extern                function        new(string name = "hqm_iosf_prim_cfg_wr_badparity_seq");
  extern virtual        task            body();

endclass : hqm_iosf_prim_cfg_wr_badparity_seq

function hqm_iosf_prim_cfg_wr_badparity_seq::new(string name = "hqm_iosf_prim_cfg_wr_badparity_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_prim_cfg_wr_badparity_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];
  bit [3:0]             byte_en;

  iosfTxn = new("iosfTxn");

  data_i = new[1];
  data_i[0] = iosf_data << (iosf_addr[1:0] * 8);

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
  iosfTxn.cmd               = Iosf::CfgWr0;
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
  iosfTxn.expectRsp         = 0;
  iosfTxn.driveBadCmdParity = m_driveBadCmdParity;
  iosfTxn.driveBadDataParity = m_driveBadDataParity;
  iosfTxn.driveBadDataParityCycle = m_driveBadDataParityCycle;
  iosfTxn.driveBadDataParityPct   = m_driveBadDataParityPct;
  iosfTxn.reqGap            =  0;
  iosfTxn.chain             =  1'b0;
  iosfTxn.sai               =  iosf_sai;


  `ovm_send (iosfTxn)

   if($test$plusargs("UR_TXN"))begin
  iosfTxn.waitForComplete();

  if (iosfTxn.cplStatus == 3'b001) //Successful Completion
    ovm_report_info(get_full_name(), $psprintf("CfgWr0 Address=0x%x BE=0x%01x Data=0x%08x completed unsuccessfully",iosf_addr,byte_en,iosf_data), OVM_LOW);
  else
    ovm_report_error(get_full_name(), $psprintf("CfgWr0 Address=0x%x BE=0x%01x Data=0x%08x error completion (0x%x)not expected sccesful",iosf_addr,byte_en,iosf_data,iosfTxn.cplStatus), OVM_LOW);

  end
endtask : body  

`endif
