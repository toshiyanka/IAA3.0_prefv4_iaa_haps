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

`ifndef MEM_RD_TXN_OVERRIDE__SV
`define MEM_RD_TXN_OVERRIDE__SV

`define CLK_PERIOD 1            // 1ns

class mem_rd_txn_override extends IosfBaseCallBack;
  int dly_300ns;
  int dly_400ns;
  int dly_500ns;
  int dly_600ns;
  int dly_700ns;
  int rand_dly_en;
  int rand_dly_min;
  int rand_dly_max;

  function new();
    super.new();
    if(!$value$plusargs("dly_300ns=%d",     dly_300ns))     dly_300ns = 0;
    if(!$value$plusargs("dly_400ns=%d",     dly_400ns))     dly_400ns = 0;
    if(!$value$plusargs("dly_500ns=%d",     dly_500ns))     dly_500ns = 0;
    if(!$value$plusargs("dly_600ns=%d",     dly_600ns))     dly_600ns = 0;
    if(!$value$plusargs("dly_700ns=%d",     dly_700ns))     dly_700ns = 0;
    if(!$value$plusargs("rand_dly_en=%d",   rand_dly_en))   rand_dly_en  = 0;
    if(!$value$plusargs("rand_dly_min=%d",  rand_dly_min))  rand_dly_min = 0;
    if(!$value$plusargs("rand_dly_max=%d",  rand_dly_max))  rand_dly_max = 0;
  endfunction:new;

 `ifdef HQM_IOSF_2019_BFM
  function void execute (IosfAgtSlvTlm slvHandle, IosfTgtTxn tgtTxn);
 `else
  function void execute (IosfAgtTgtTlm slvHandle, IosfTgtTxn tgtTxn);
 `endif
    IosfTxn ModTgtTxn = new;
    IosfTxn ModTgtTxns[$];
    time dly = 1ns;

    if(dly_300ns || dly_400ns || dly_500ns || dly_600ns || dly_700ns || rand_dly_en)begin
      slvHandle.buildCplD (tgtTxn, ModTgtTxns);
      while(ModTgtTxns.size)begin
         ModTgtTxn =ModTgtTxns.pop_front();
         randcase
           dly_300ns   : dly = 300000ns;      // 300ns
           dly_400ns   : dly = 400000ns;      // 400ns
           dly_500ns   : dly = 500000ns;      // 500ns
           dly_600ns   : dly = 600000ns;      // 600ns
           dly_700ns   : dly = 700000ns;      // 700ns
           rand_dly_en : dly = (($urandom_range(rand_dly_max, rand_dly_min)) * 100ns); //3000
         endcase

         ModTgtTxn.parallelDelay = dly;

         sendCompletion(slvHandle, ModTgtTxn);
      end  //while
    end else begin
      slvHandle.sendCplD();
    end
  endfunction: execute;

endclass: mem_rd_txn_override;
`endif
