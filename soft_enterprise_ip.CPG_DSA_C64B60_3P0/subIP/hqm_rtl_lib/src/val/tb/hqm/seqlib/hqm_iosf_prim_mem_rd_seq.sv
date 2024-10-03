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
`ifndef HQM_IOSF_PRIM_MEM_RD_SEQ__SV
`define HQM_IOSF_PRIM_MEM_RD_SEQ__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_mem_rd_seq extends hqm_iosf_prim_np_base_seq;

  `ovm_sequence_utils(hqm_iosf_prim_mem_rd_seq,IosfAgtSeqr)
  rand bit ep = 1'b0; 
  rand int iosf_length;

  IosfTxn               iosfTxn;

  constraint deflt_ep { soft ep == 1'b0; }

  constraint c_length { soft iosf_length == 1; }

  extern                function        new(string name = "hqm_iosf_prim_mem_rd_seq");
  extern virtual        task            body();

endclass : hqm_iosf_prim_mem_rd_seq

function hqm_iosf_prim_mem_rd_seq::new(string name = "hqm_iosf_prim_mem_rd_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_prim_mem_rd_seq::body();
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = (iosf_addr[63:32] == 32'h0) ? Iosf::MRd32 : Iosf::MRd64;
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = 0;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.length            = iosf_length;
  iosfTxn.errorPresent      = ep;
  iosfTxn.address           = iosf_addr;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i;
  iosfTxn.first_byte_en     = 4'hf;
  iosfTxn.last_byte_en      = (iosf_length > 1) ? 4'hf : 4'h0;
  iosfTxn.reqLocked         = 0;  
  iosfTxn.compareType       = Iosf::CMP_EQ;
  iosfTxn.compareCompletion = 0;
  iosfTxn.waitForCompletion = iosf_wait_for_completion;
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
  iosfTxn.pasidtlp		      =  iosf_pasidtlp;
  iosfTxn.ecrc              =  ecrc;

  `ovm_send (iosfTxn)

  if (iosf_wait_for_completion) begin
    iosfTxn.waitForComplete();
    iosf_cpl_status = iosfTxn.cplStatus;

    if (iosfTxn.cplStatus == 3'b000) begin //Successful Completion
      iosf_data = iosfTxn.cplData[0];

      if (iosf_exp_error) begin
        ovm_report_error(get_full_name(), $psprintf("MRd64 Address=0x%x SAI=0x%02x Data=0x%08x, expected error",iosf_addr,iosf_sai,iosf_data), OVM_LOW);
      end else begin
        ovm_report_info(get_full_name(), $psprintf("MRd64 Address=0x%x SAI=0x%02x Data=0x%08x",iosf_addr,iosf_sai,iosf_data), OVM_LOW);
      end
    end else begin
      if (iosf_exp_error) begin // Unexpected error
        ovm_report_info(get_full_name(), $psprintf("MRd64 Address=0x%x SAI=0x%02x expected error completion (0x%x)",iosf_addr,iosf_sai,iosfTxn.cplStatus), OVM_LOW);
      end else begin
        ovm_report_error(get_full_name(), $psprintf("MRd64 Address=0x%x SAI=0x%02x unexpected error completion (0x%x)",iosf_addr,iosf_sai,iosfTxn.cplStatus), OVM_LOW);
      end
    end
  end
endtask : body  

`endif
