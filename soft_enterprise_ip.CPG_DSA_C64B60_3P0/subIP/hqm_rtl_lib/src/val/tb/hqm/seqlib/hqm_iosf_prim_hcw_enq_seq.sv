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
`ifndef HQM_IOSF_PRIM_HCW_ENQ_SEQ__SV
`define HQM_IOSF_PRIM_HCW_ENQ_SEQ__SV

import IosfPkg::*;

`include "stim_config_macros.svh"

class hqm_iosf_prim_hcw_enq_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_iosf_prim_hcw_enq_seq_stim_config";

  `ovm_object_utils_begin(hqm_iosf_prim_hcw_enq_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(channel_id,                  OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

  `stimulus_config_object_utils_begin(hqm_iosf_prim_hcw_enq_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_rand_int(channel_id)
  `stimulus_config_object_utils_end

  string                        tb_env_hier     = "*";

  rand  int                     channel_id;

  constraint c_hwm_stress_rand_en {
    soft channel_id     == 0;
  }

  function new(string name = "hqm_iosf_prim_hcw_enq_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_iosf_prim_hcw_enq_seq_stim_config

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_iosf_prim_hcw_enq_seq extends IosfSendTxnSeq;

  `ovm_sequence_utils(hqm_iosf_prim_hcw_enq_seq,IosfAgtSeqr)

  rand hqm_iosf_prim_hcw_enq_seq_stim_config       cfg;

  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_iosf_prim_hcw_enq_seq_stim_config);

  rand logic [63:0]     iosf_addr;
  rand Iosf::data_t     iosf_data[];
  rand logic [7:0]      iosf_sai;
  static int            tr_id = 0;

  rand logic [63:0]     pp_enq_addr;
  rand logic [127:0]    hcw_enq_q[];


  constraint deflt { soft iosf_sai == 8'h03; }

  extern                function        new(string name = "hqm_iosf_prim_hcw_enq_seq");
  extern virtual        task            body();
  extern virtual        task            send(logic [63:0] addr, logic [127:0] hcw[$], logic [7:0] sai = 8'h03);

endclass : hqm_iosf_prim_hcw_enq_seq

function hqm_iosf_prim_hcw_enq_seq::new(string name = "hqm_iosf_prim_hcw_enq_seq");
  super.new(name);

  cfg = hqm_iosf_prim_hcw_enq_seq_stim_config::type_id::create("hqm_iosf_prim_hcw_enq_seq_stim_config");
  apply_stim_config_overrides(0);

endfunction

task hqm_iosf_prim_hcw_enq_seq::body();
  ovm_report_info(get_full_name(), $psprintf("HCW Enqueue sequence started"), OVM_MEDIUM);

  apply_stim_config_overrides(1);

   if($test$plusargs("HQM_CFG_PRIM_HCW_ENQ_SEQ"))  send(pp_enq_addr, hcw_enq_q, iosf_sai);
endtask

task hqm_iosf_prim_hcw_enq_seq::send(logic [63:0] addr, logic [127:0] hcw[$], logic [7:0] sai = 8'h03);
  IosfTxn               iosfTxn;
  Iosf::data_t          data_i[];
  string                hcw_str;
  bit [22:0]            iosf_pasidtlp;

  if ((hcw.size() < 1) || (hcw.size() > 4)) begin
    ovm_report_error(get_full_name(), $psprintf("HCW Enqueue Address=0x%x illegal number of HCWs = %0d",iosf_addr,hcw.size()));
    return;
  end

  iosf_addr     = addr;
  iosf_sai      = sai;

  iosfTxn       = new("iosfTxn");

  data_i = new[4 * hcw.size()];

  hcw_str = "";

  for (int i = 0 ; i < hcw.size() ; i++) begin
    logic [127:0]       next_hcw;

    next_hcw = hcw[i];

    hcw_str = {hcw_str,$psprintf("0x%032x ",next_hcw)};

    data_i[(i*4) + 0]   = next_hcw[31:0];
    data_i[(i*4) + 1]   = next_hcw[63:32];
    data_i[(i*4) + 2]   = next_hcw[95:64];
    data_i[(i*4) + 3]   = next_hcw[127:96];
  end

  iosfTxn.set_sequencer (get_sequencer());

  if ( (iosf_addr[63:32] == 32'b0)  && !($test$plusargs("IOSF_MWR64_HCW")) )begin
      iosfTxn.cmd           = Iosf::MWr32;
  end else begin
      iosfTxn.cmd           = Iosf::MWr64;
  end

  if ($test$plusargs("HQM_IOSF_PRIM_HCW_ENQ_RAND_PASID")) begin
    iosf_pasidtlp = '1;
    iosf_pasidtlp = $urandom_range(iosf_pasidtlp,0);
  end else if ($test$plusargs("HQM_IOSF_PRIM_HCW_ENQ_FMT2_1")) begin
    iosf_pasidtlp = '0;
    iosf_pasidtlp[22] = 1;
  end else begin
    iosf_pasidtlp = '0;
  end

  if ($test$plusargs("HQM_IOSF_PRIM_HCW_ENQ_ADDR_25_0")) begin
    iosf_addr[25] = $urandom_range(0,1); //--0
  end

  iosfTxn.reqChId           = cfg.channel_id;
  iosfTxn.trafficClass      = 0;
  iosfTxn.reqID             = tr_id;
  iosfTxn.reqType           = Iosf::getReqTypeFromCmd (iosfTxn.cmd);
  iosfTxn.procHint          = 0;
  iosfTxn.pasidtlp          = iosf_pasidtlp;
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
  iosfTxn.tag               = 8'h0;
  iosfTxn.expectRsp         = 0;
  iosfTxn.driveBadCmdParity =  0;
  iosfTxn.driveBadDataParity =  0;
  iosfTxn.driveBadDataParityCycle =  0;
  iosfTxn.driveBadDataParityPct   =  0;
  iosfTxn.reqGap            =  0;
  iosfTxn.chain             =  1'b0;
  iosfTxn.sai               =  iosf_sai;

  tr_id++;

  `ovm_info("PP_CQ_DEBUG",$psprintf("hqm_iosf_prim_hcw_enq_seq_send - addr=0x%0x addr[25]=%0d; iosf_addr=0x%0x iosf_addr[25]=%0d; iosf_pasidtlp=0x%0x data_i.size=%0d ", addr, addr[25], iosf_addr, iosf_addr[25], iosf_pasidtlp, data_i.size()),OVM_MEDIUM)

`ifndef HQM_PCIE_TB
  `ovm_send (iosfTxn)
`endif
  ovm_report_info(get_full_name(), $psprintf("HCW Enqueue Address=0x%x Data=%s",iosf_addr,hcw_str), OVM_LOW);
endtask

`endif
