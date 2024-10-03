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

`ifndef RNDCFG_MEM_RD_TXN_OVERRIDE__SV
`define RNDCFG_MEM_RD_TXN_OVERRIDE__SV

`define CLK_PERIOD 1            // 1ns

class rndcfg_mem_rd_txn_override extends IosfBaseCallBack;
  int IngBehChk;
  int varylength = 0;
  int dm_txn_track = 0;
  int poisoned_txn = 0;

  function new();
    super.new();
    if(!$value$plusargs("ingbehchk=%d",     IngBehChk))     IngBehChk    = 0;
    if(!$value$plusargs("dm_txn_track=%d",  dm_txn_track))  dm_txn_track = 0;
    if(!$value$plusargs("varylength=%d",    varylength))    varylength   = 0;
    if(!$value$plusargs("poisoned_txn=%d",  poisoned_txn))  poisoned_txn = 0;

  endfunction:new;


 `ifdef HQM_IOSF_2019_BFM
  function void execute (IosfAgtSlvTlm slvHandle, IosfTgtTxn tgtTxn);
 `else
  function void execute (IosfAgtTgtTlm slvHandle, IosfTgtTxn tgtTxn);
 `endif
    IosfTxn ModTgtTxn = new;
    IosfTxn ModTgtTxns[$];
    int len_vary = 0;
    time dly = 1ns;

    if(dm_txn_track)begin
      slvHandle.buildCplD (tgtTxn, ModTgtTxns);
      while(ModTgtTxns.size)begin
         ModTgtTxn = ModTgtTxns.pop_front();

        if(IngBehChk == 2) begin
            randcase
                20 : ModTgtTxn.cmd = Iosf::Cpl;
                80 : ModTgtTxn.cmd = Iosf::CplD;
            endcase
         end

         if(ModTgtTxn.cmd == Iosf::Cpl)begin
            ModTgtTxn.cmd = Iosf::CplD;
            for(int i = 0; i < ModTgtTxn.dataArraySize(); i++) begin
               ModTgtTxn.data[i] = 0;
            end
         end

         if((poisoned_txn == 1) && (ModTgtTxn.cmd == Iosf::CplD))begin
            randcase
                20: ModTgtTxn.errorPresent = 1;
                80: ModTgtTxn.errorPresent = 0;
            endcase
            if(ModTgtTxn.errorPresent == 1) begin
                `ovm_info (get_type_name(), $psprintf("Error injected in packet: %s",ModTgtTxn.convert2string()), OVM_NONE);
            end
         end
/*
         if(ModTgtTxn.cplStatus == Iosf::UR)
            ModTgtTxn.first_byte_en = Iosf::UR;

         if(ModTgtTxn.cplStatus == Iosf::CA)
            ModTgtTxn.first_byte_en = Iosf::CA;
// */
         sendCompletion(slvHandle, ModTgtTxn);
      end  //while
    end else begin
      slvHandle.sendCplD();
    end
  endfunction: execute;

endclass: rndcfg_mem_rd_txn_override;
`endif
