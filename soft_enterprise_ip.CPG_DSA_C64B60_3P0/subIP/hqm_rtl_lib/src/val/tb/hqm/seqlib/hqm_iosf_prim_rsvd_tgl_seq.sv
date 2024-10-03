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
`ifndef HQM_IOSF_PRIM_RSVD_TGL_SEQ__SV
`define HQM_IOSF_PRIM_RSVD_TGL_SEQ__SV

import IosfPkg::*;
import iosfsbm_fbrc::*;
import iosfsbm_agent::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_rsvd_tgl_seq extends IosfBaseRspSeq;

  `ovm_sequence_utils(hqm_iosf_prim_rsvd_tgl_seq,IosfAgtSeqr)
  rand  IosfTxn iosf_txn;
  rand bit     exp_ur;
  rand bit     skip_ur_chk;

  constraint _ur_expect_ { soft exp_ur == 1'b_0; soft skip_ur_chk == 1'b_0; }

  extern                function        new(string name = "hqm_iosf_prim_rsvd_tgl_seq");
  extern                function        set_iosf_txn(IosfTxn i_iosf_txn);
  extern virtual        task            body();

endclass : hqm_iosf_prim_rsvd_tgl_seq

function hqm_iosf_prim_rsvd_tgl_seq::new(string name = "hqm_iosf_prim_rsvd_tgl_seq");
  super.new(name);
  iosf_txn = IosfTxn::type_id::create("iosf_txn");
endfunction

function hqm_iosf_prim_rsvd_tgl_seq::set_iosf_txn(IosfTxn i_iosf_txn);
  this.iosf_txn=i_iosf_txn;
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_prim_rsvd_tgl_seq::body();

  iosf_txn.set_sequencer (get_sequencer());

  ovm_report_info(get_full_name(), $psprintf("hqm_iosf_prim_rsvd_tgl_seq -> Issuing IosfTxn as below, \n%s",iosf_txn.convert2string()), OVM_LOW);

  `ovm_send (iosf_txn)

  iosf_txn.waitForComplete();

  if(skip_ur_chk == 0) begin : cpl_status_chk
     ovm_report_info(get_full_name(), $psprintf("Starting Cpl status chk for Txn:\n%s",iosf_txn.convert2string()), OVM_DEBUG);
     if (iosf_txn.cplStatus == 3'b000) begin //Successful Completion
       if (exp_ur) begin
         ovm_report_error(get_full_name(), $psprintf("Unexpected SC received for Txn:\n%s",iosf_txn.convert2string()), OVM_LOW);
       end else begin
         ovm_report_info(get_full_name(), $psprintf("Expected SC received for Txn:\n%s",iosf_txn.convert2string()), OVM_LOW);
       end
     end else begin
       if (exp_ur) begin
         ovm_report_info(get_full_name(), $psprintf("Expected UR received for Txn:\n%s",iosf_txn.convert2string()), OVM_LOW);
       end else begin
         ovm_report_error(get_full_name(), $psprintf("Unexpected UR received for Txn:\n%s",iosf_txn.convert2string()), OVM_LOW);
       end
     end
  end : cpl_status_chk
  else begin : skip_cpl_status_chk
     ovm_report_info(get_full_name(), $psprintf("Skipping Cpl status chk for Txn:\n%s",iosf_txn.convert2string()), OVM_LOW);
  end : skip_cpl_status_chk

endtask : body  

`endif
