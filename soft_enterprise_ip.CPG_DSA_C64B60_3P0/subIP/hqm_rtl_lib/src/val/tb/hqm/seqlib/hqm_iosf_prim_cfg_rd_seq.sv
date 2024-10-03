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
`ifndef HQM_IOSF_PRIM_CFG_RD_SEQ__SV
`define HQM_IOSF_PRIM_CFG_RD_SEQ__SV

import IosfPkg::*;

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_cfg_rd_seq extends hqm_iosf_prim_np_base_seq;

  `ovm_sequence_utils(hqm_iosf_prim_cfg_rd_seq,IosfAgtSeqr)

  extern                function        new(string name = "hqm_iosf_prim_cfg_rd_seq");
  extern virtual        task            body();

endclass : hqm_iosf_prim_cfg_rd_seq

function hqm_iosf_prim_cfg_rd_seq::new(string name = "hqm_iosf_prim_cfg_rd_seq");
  super.new(name);
endfunction

//------------------
//-- body
//------------------
task hqm_iosf_prim_cfg_rd_seq::body();
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];
  bit [3:0]             byte_en;

  iosfTxn = new("iosfTxn");

  data_i = new[1];
  data_i[0] = iosf_data;

  case (iosf_addr[1:0])
    2'b00: begin
      case (reg_size)
        8:              byte_en = 4'b0001;
        16:             byte_en = 4'b0011;
        24:             byte_en = 4'b0111;
        default:        byte_en = 4'b1111;
      endcase
    end
    2'b01: begin
      case (reg_size)
        8:              byte_en = 4'b0010;
        16:             byte_en = 4'b0110;
        24:             byte_en = 4'b1110;
        default:        begin
                          byte_en = 4'b0000;
                          ovm_report_error(get_full_name(), $psprintf("Unsupported RAL access combination Address=0x%x reg_size=%0d",iosf_addr,reg_size), OVM_LOW);
                        end
      endcase
    end
    2'b10: begin
      case (reg_size)
        8:              byte_en = 4'b0100;
        16:             byte_en = 4'b1100;
        default:        begin
                          byte_en = 4'b0000;
                          ovm_report_error(get_full_name(), $psprintf("Unsupported RAL access combination Address=0x%x reg_size=%0d",iosf_addr,reg_size), OVM_LOW);
                        end
      endcase
    end
    2'b11: begin
      case (reg_size)
        8:              byte_en = 4'b1000;
        default:        begin
                          byte_en = 4'b0000;
                          ovm_report_error(get_full_name(), $psprintf("Unsupported RAL access combination Address=0x%x reg_size=%0d",iosf_addr,reg_size), OVM_LOW);
                        end
      endcase
    end
  endcase

  iosf_addr[1:0] = 2'b00;

  iosfTxn.set_sequencer (get_sequencer());
  iosfTxn.cmd               = Iosf::CfgRd0;
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
  iosfTxn.waitForCompletion = iosf_wait_for_completion;
  iosfTxn.pollingMode       = 0;
  get_next_tag();
  iosfTxn.tag               = iosf_tag;
  iosfTxn.expectRsp         = 0;
  iosfTxn.driveBadCmdParity =  $test$plusargs("HQM_CFG_RD_BAD_PARITY") ? 1 : 0;
  iosfTxn.driveBadDataParity =  0;
  iosfTxn.driveBadDataParityCycle =  0;
  iosfTxn.driveBadDataParityPct   =  0;
  iosfTxn.reqGap            =  0;
  iosfTxn.chain             =  1'b0;
  iosfTxn.sai               =  iosf_sai;
  iosfTxn.errorPresent		  =  iosf_EP;
  iosfTxn.ecrc              =  ecrc;


  `ovm_send (iosfTxn)

  //iosfTxn.waitForComplete();
  //iosf_cpl_status = iosfTxn.cplStatus;

  if (iosf_wait_for_completion) begin
    iosfTxn.waitForComplete();
    iosf_cpl_status = iosfTxn.cplStatus;

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
  end

endtask : body  

`endif
