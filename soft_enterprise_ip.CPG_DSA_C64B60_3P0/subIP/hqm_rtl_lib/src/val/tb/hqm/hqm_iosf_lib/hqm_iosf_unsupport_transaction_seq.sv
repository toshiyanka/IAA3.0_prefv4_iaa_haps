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
`ifndef HQM_IOSF_UNSUPPORT_TRANSACTION_SEQ__SV 
`define HQM_IOSF_UNSUPPORT_TRANSACTION_SEQ__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_unsupport_transaction_seq extends hqm_iosf_prim_np_base_seq;

  `ovm_sequence_utils(hqm_iosf_unsupport_transaction_seq,IosfAgtSeqr)

  rand Iosf::iosf_cmd_t  iosf_cmd;
  rand Iosf::iosf_cmd_t  iosf_cmd32;
  rand Iosf::iosf_cmd_t  iosf_cmd64;
  rand bit ep = 1'b0; 
  rand int length_i; 
  rand bit [3:0] fbe_i; 
  rand bit [3:0] lbe_i; 
  rand logic [15:0]     requester_id; 
  rand bit is_cpl;
  rand bit is_rsvd_fmt_type;
  constraint deflt_ep { soft ep == 1'b0; }
  constraint deflt_fbe_i { soft fbe_i == 4'hf; }
  constraint deflt_lbe_i { soft lbe_i == 4'h0; }
  constraint deflt_length_i { soft length_i == 1; }
  constraint deflt_requester_id { soft requester_id == 16'b0; } 
  constraint deflt_is_cpl { soft is_cpl == 1'b0; }
  constraint deflt_is_rsvd_fmt_type { soft is_rsvd_fmt_type == 1'b0; }
   rand logic [7:0]    UR_sai;


  extern                function        new(string name = "hqm_iosf_unsupport_transaction_seq");
  extern virtual        task            body();

  constraint cmd_b {iosf_cmd inside {Iosf::Cpl, Iosf::CplD, Iosf::CplLk, Iosf::CplDLk};}
  constraint cmd_c {iosf_cmd32 inside {Iosf::IORd, Iosf::MRdLk32, Iosf::LTMRd32, Iosf::NPMWr32, Iosf::IOWr, Iosf::FAdd32, Iosf::Swap32, Iosf::CAS32, Iosf::LTMWr32, Iosf::CfgRd1, Iosf::CfgWr1};}
  constraint cmd_d {iosf_cmd64 inside {Iosf::MRdLk64, Iosf::LTMRd64, Iosf::NPMWr64, Iosf::FAdd64, Iosf::Swap64, Iosf::CAS64, Iosf::LTMWr64,
                                       Iosf::Msg0, Iosf::Msg1, Iosf::Msg2,Iosf::Msg3, Iosf::Msg4, Iosf::Msg5, Iosf::Msg6, Iosf::Msg7,
                                       Iosf::MsgD0, Iosf::MsgD1,Iosf::MsgD2, Iosf::MsgD3, Iosf::MsgD4,Iosf::MsgD5, Iosf::MsgD6,Iosf::MsgD7};}

endclass : hqm_iosf_unsupport_transaction_seq

function hqm_iosf_unsupport_transaction_seq::new(string name = "hqm_iosf_unsupport_transaction_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_unsupport_transaction_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];

  iosfTxn = new("iosfTxn");

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = ((is_cpl==1) ? iosf_cmd :((iosf_addr[63:32] == 32'h0) ? iosf_cmd32 : iosf_cmd64));
  iosfTxn.reqChId           = 0;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = requester_id; //0;
  iosfTxn.reqType           = (Iosf::getReqTypeFromCmd (iosfTxn.cmd));
  iosfTxn.procHint          = 0;
  iosfTxn.length            = length_i;//1;
  iosfTxn.errorPresent      = ep;
  iosfTxn.address           = iosf_addr;
  iosfTxn.byteEnWithData    = 0;
  iosfTxn.data              = data_i;
  iosfTxn.first_byte_en     = fbe_i;//4'hf;
  iosfTxn.last_byte_en      = lbe_i;//4'h0;
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
  //iosfTxn.sai               =  iosf_sai;

  
  if($test$plusargs("UR_SAI_TXN"))begin
     iosfTxn.sai               =  UR_sai;
  end 
  else begin
  iosfTxn.sai               =  iosf_sai;
   end 


   ovm_report_info(get_full_name(), $psprintf("Unsupport: cmd=%0s Address=0x%x  Data=0x%08x sai=%0d/%0d", iosfTxn.cmd.name(), iosf_addr,iosf_data, iosf_sai, iosfTxn.sai), OVM_LOW);
  `ovm_send (iosfTxn)

   if($test$plusargs("UR_TXN") && !(iosfTxn.cmd==Iosf::LTMWr32) && !(iosfTxn.cmd==Iosf::LTMWr64))begin
       ovm_report_info(get_full_name(), $psprintf("Unsupport: waiting for completion. cmd=%0s Address=0x%x  Data=0x%08x sai=%0d/%0d", iosfTxn.cmd.name(), iosf_addr,iosf_data, iosf_sai, iosfTxn.sai), OVM_LOW);
       iosfTxn.waitForComplete();
       if (iosfTxn.cplStatus == 3'b001) //expect unsupported request Completion
           ovm_report_info(get_full_name(), $psprintf("Unsupport: cmd=%0s Address=0x%x  Data=0x%08x completed successfully", iosfTxn.cmd.name(), iosf_addr,iosf_data), OVM_LOW);
       else
           ovm_report_error(get_full_name(), $psprintf("Unsupport: cmd=%0s Address=0x%x  Data=0x%08x error completion (0x%x)", iosfTxn.cmd.name(), iosf_addr,iosf_data,iosfTxn.cplStatus), OVM_LOW);
   end


 /* 
  if($test$plusargs("BLOCKING_IOSF_TXN"))begin
 
  iosfTxn.waitForComplete();

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

end  */ 

endtask : body  

`endif
