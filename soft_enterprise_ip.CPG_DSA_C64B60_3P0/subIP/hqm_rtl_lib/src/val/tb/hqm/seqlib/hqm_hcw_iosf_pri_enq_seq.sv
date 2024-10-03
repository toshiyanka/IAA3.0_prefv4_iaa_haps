//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2019 Intel Corporation All Rights Reserved.
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

import IosfPkg::*;
import hcw_sequences_pkg::*;

`ifdef IP_TYP_TE
`include "stim_config_macros.svh"
`endif

class hqm_hcw_iosf_pri_enq_seq_stim_config extends ovm_object;
  static string stim_cfg_name = "hqm_hcw_iosf_pri_enq_seq_stim_config";

  `ovm_object_utils_begin(hqm_hcw_iosf_pri_enq_seq_stim_config)
    `ovm_field_string(tb_env_hier,              OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_string(inst_suffix_q,      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_queue_int(channel_id_q,          OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(src_id,                      OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(dest_id,                     OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(max_cacheline_num,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(hqm_txn_maxcacheline_pad,    OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
    `ovm_field_int(cacheline_shuffle,           OVM_COPY | OVM_COMPARE | OVM_PRINT | OVM_DEC)
  `ovm_object_utils_end

`ifdef IP_TYP_TE
  `stimulus_config_object_utils_begin(hqm_hcw_iosf_pri_enq_seq_stim_config)
    `stimulus_config_field_string(tb_env_hier)
    `stimulus_config_field_queue_string(inst_suffix_q)
    `stimulus_config_field_queue_int(channel_id_q)
    `stimulus_config_field_rand_int(src_id)
    `stimulus_config_field_rand_int(dest_id)
    `stimulus_config_field_rand_int(max_cacheline_num)
    `stimulus_config_field_rand_int(hqm_txn_maxcacheline_pad)
    `stimulus_config_field_rand_int(cacheline_shuffle)
  `stimulus_config_object_utils_end
`endif

  string                        tb_env_hier     = "*";
  string                        inst_suffix_q[$];
  int                           channel_id_q[$];

  rand  int                     src_id;
  rand  int                     dest_id;
  rand  int                     max_cacheline_num;
  rand  int                     hqm_txn_maxcacheline_pad;
  rand  int                     cacheline_shuffle;

  constraint c_dest_id {
    soft dest_id     == 0;
  }

  constraint c_src_id {
    soft src_id     == 0;
  }

  constraint c_max_num {
    soft max_cacheline_num     == 1;
  }

  constraint c_max_num_pad {
    soft hqm_txn_maxcacheline_pad     == 0;
  }


  constraint c_cl_shuffle {
    soft cacheline_shuffle     == 0;
  }

  function new(string name = "hqm_hcw_iosf_pri_enq_seq_stim_config");
    super.new(name); 
  endfunction
endclass : hqm_hcw_iosf_pri_enq_seq_stim_config

//-------------------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------
class hqm_hcw_iosf_pri_enq_seq extends hqm_hcw_enq_seq;

  `ovm_object_utils(hqm_hcw_iosf_pri_enq_seq)

  rand hqm_hcw_iosf_pri_enq_seq_stim_config       cfg;

`ifdef IP_TYP_TE
  `STIMULUS_CONFIG_APPLY_STIM_CONFIG_OVERRIDES(hqm_hcw_iosf_pri_enq_seq_stim_config);
`endif

  extern                function        new(string name = "hqm_hcw_iosf_pri_enq_seq");
  extern virtual        task            body();

endclass : hqm_hcw_iosf_pri_enq_seq

function hqm_hcw_iosf_pri_enq_seq::new(string name = "hqm_hcw_iosf_pri_enq_seq");
  super.new(name);

  cfg = hqm_hcw_iosf_pri_enq_seq_stim_config::type_id::create("hqm_hcw_iosf_pri_enq_seq_stim_config");
`ifdef IP_TYP_TE
    apply_stim_config_overrides(0);
`else
    cfg.randomize();
`endif
  foreach(dirpp_enq_storage[i]) 
   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:new dirpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d",  i, dirpp_enq_storage[i].pp_enq_cacheline_wr_q.size()), OVM_HIGH)
  foreach(ldbpp_enq_storage[i]) 
   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:new ldbpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d",  i, ldbpp_enq_storage[i].pp_enq_cacheline_wr_q.size()), OVM_HIGH)
endfunction

task hqm_hcw_iosf_pri_enq_seq::body();
  iosf_pri_seq_item_pkg::iosf_pri_mem_wr        mem_wr;
  byte                                          wr_data[];
  int                                           len;
  bit [63:0]                                    byte_en;
  int                                           qi[$];
  hqm_enq_cacheline_wr_ops                      enq_cacheline_wr_ops;
  hqm_enq_cacheline_wr_ops                      pad_cacheline_wr_ops;
  hqm_enq_cacheline_wr_ops                      txn_cacheline_wr_ops;
  int                                           total_cacheline_num;
  int                                           pp_total_cacheline_num;
  int                                           use_max_cacheline_num;
  int                                           use_hqm_txn_maxcacheline_pad;
  int                                           use_hqm_cacheline_shuffle;

`ifdef IP_TYP_TE
  apply_stim_config_overrides(1);
`endif

   use_max_cacheline_num = cfg.max_cacheline_num;
   if(cfg.max_cacheline_num>1) begin
        use_max_cacheline_num = hqm_max_cacheline_num;
   end
   use_hqm_txn_maxcacheline_pad = hqm_txn_maxcacheline_pad || cfg.hqm_txn_maxcacheline_pad;
   use_hqm_cacheline_shuffle = hqm_cacheline_shuffle || cfg.cacheline_shuffle;
   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:Start with passed knobs: hqm_max_cacheline_num=%0d;    cfg.max_cacheline_num=%0d;        use_max_cacheline_num=%0d",         hqm_max_cacheline_num, cfg.max_cacheline_num, use_max_cacheline_num), OVM_MEDIUM)
   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:Start with passed knobs: hqm_txn_maxcacheline_pad=%0d; cfg.hqm_txn_maxcacheline_pad=%0d; use_hqm_txn_maxcacheline_pad=%0d ", hqm_txn_maxcacheline_pad, cfg.hqm_txn_maxcacheline_pad, use_hqm_txn_maxcacheline_pad), OVM_HIGH)
   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:Start with passed knobs: hqm_cacheline_shuffle=%0d;    cfg.cacheline_shuffle=%0d;        use_hqm_cacheline_shuffle=%0d",     hqm_cacheline_shuffle, cfg.cacheline_shuffle, use_hqm_cacheline_shuffle), OVM_HIGH)

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  //--pad_cacheline_wr_ops (one cache-line) to prepare for padding
  pad_cacheline_wr_ops  = hqm_enq_cacheline_wr_ops::type_id::create("pad_cacheline_wr_ops");
  pad_cacheline_wr_ops.wdata = new[64];
  for (int j = 0 ; j < 64 ; j++) begin
    pad_cacheline_wr_ops.wdata[j]=0;
  end
  pad_cacheline_wr_ops.wlen=64;
  pad_cacheline_wr_ops.wbyte_en=(64'h1 << 64) - 64'h1;
  pad_cacheline_wr_ops.waddr = pp_enq_addr; 

  //--------------------------------------------------------------
  //--------------------------------------------------------------
  //--enq_cacheline_wr_ops received pp_enq_addr/hcw_enq_q[] from hqm_pp_cq_base_seq
  enq_cacheline_wr_ops  = hqm_enq_cacheline_wr_ops::type_id::create("enq_cacheline_wr_ops");
  enq_cacheline_wr_ops.wdata = new[16 * hcw_enq_q.size()];

  wr_data = new[16 * hcw_enq_q.size()];
  for (int i = 0 ; i < hcw_enq_q.size() ; i++) begin
    for (int j = 0 ; j < 16 ; j++) begin
      wr_data[(i * 16) + j] = hcw_enq_q[i][(j*8) +: 8];
      enq_cacheline_wr_ops.wdata[(i * 16) + j] = hcw_enq_q[i][(j*8) +: 8];
    end
   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S1 - is_ldb=%0d pp_id=%0d hcw_enq_q[%0d] in size=%0d, byte_len=%0d: QE_DATA=0x%0x cmd=%0d tbcnt=0x%0x pp_enq_addr=0x%0x", is_ldb, pp_id, i, hcw_enq_q.size(), 16 * hcw_enq_q.size(), hcw_enq_q[i], hcw_enq_q[i][123:120], hcw_enq_q[i][63:0], pp_enq_addr), OVM_HIGH)
  end

  len           = 16 * hcw_enq_q.size();
  byte_en       = (64'h1 << len) - 64'h1;
   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S2 - is_ldb=%0d pp_id=%0d pp_enq_addr=0x%0x len=%0d wr_data.size=%0d wr_data=%p is_last_hcw=%0d", is_ldb, pp_id, pp_enq_addr, len, wr_data.size(), wr_data, is_last_hcw), OVM_HIGH)


  enq_cacheline_wr_ops.waddr     = pp_enq_addr; //--temp {pp_enq_addr[127:1], 1'b0};
  enq_cacheline_wr_ops.wlen      = len;
  enq_cacheline_wr_ops.wbyte_en  = byte_en;

  if(is_ldb==0) begin 
     dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.push_back(enq_cacheline_wr_ops);
     pp_total_cacheline_num = dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size();
  end else begin
     ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.push_back(enq_cacheline_wr_ops);
     pp_total_cacheline_num = ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size();
  end 

   `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S3 - is_ldb=%0d pp_id=%0d -- pp_total_cacheline_num=%0d enq_cacheline_wr_ops.waddr=0x%0x cachelineaddr=%0d wlen=%0d - is_last_hcw=%0d ", is_ldb, pp_id, pp_total_cacheline_num,enq_cacheline_wr_ops.waddr, enq_cacheline_wr_ops.waddr[9:6], enq_cacheline_wr_ops.wlen, is_last_hcw), OVM_MEDIUM)
   //`ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S3 - is_ldb=%0d pp_id=%0d -- pp_total_cacheline_num=%0d enq_cacheline_wr_ops.waddr=0x%0x cachelineaddr=%0d - wdata=%p  ", is_ldb, pp_id, pp_total_cacheline_num,enq_cacheline_wr_ops.waddr, enq_cacheline_wr_ops.waddr[9:6], enq_cacheline_wr_ops.wdata), OVM_HIGH)

  //-------------------------------------------------------------
  //-- when is_last_hcw=1, but pp_total_cacheline_num<use_max_cacheline_num
  //-- inject paddings when   use_hqm_txn_maxcacheline_pad=1
  //-------------------------------------------------------------
  if(is_last_hcw==1 && pp_total_cacheline_num<use_max_cacheline_num && use_hqm_txn_maxcacheline_pad) begin
     if(is_ldb==0) begin 
        for(int k=0; k<(use_max_cacheline_num-pp_total_cacheline_num); k++) begin
           dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.push_back(pad_cacheline_wr_ops);
        end
        pp_total_cacheline_num = dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size();
     end else begin
        for(int k=0; k<(use_max_cacheline_num-pp_total_cacheline_num); k++) begin
           ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.push_back(pad_cacheline_wr_ops);
        end
        pp_total_cacheline_num = ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size();
     end 
    `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S3.Padding - is_ldb=%0d pp_id=%0d -- pp_total_cacheline_num=%0d enq_cacheline_wr_ops.waddr=0x%0x cachelineaddr=%0d is_last_hcw=%0d ", is_ldb, pp_id, pp_total_cacheline_num,enq_cacheline_wr_ops.waddr, enq_cacheline_wr_ops.waddr[9:6], is_last_hcw), OVM_MEDIUM)
  end

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  if((pp_total_cacheline_num == use_max_cacheline_num) || is_last_hcw==1) begin
      //-- shuffle 
      if(use_hqm_cacheline_shuffle) begin
         if(is_ldb==0) begin 
            dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.shuffle(); 
           `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S5 - is_ldb=%0d pp_id=%0d -- dirpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d shuffled ", is_ldb, pp_id, pp_id, dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size()), OVM_MEDIUM)
         end else begin
            ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.shuffle(); 
           `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S5 - is_ldb=%0d pp_id=%0d -- ldbpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d shuffled ", is_ldb, pp_id, pp_id, ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size()), OVM_MEDIUM)
         end 
      end

      //----------- 
      for(int i=0; i<pp_total_cacheline_num; i++) begin
          //-- pop_front
          if(is_ldb==0) begin 
             txn_cacheline_wr_ops = dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.pop_front();
          end else begin
             txn_cacheline_wr_ops = ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.pop_front();
          end
  
          `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S5 - is_ldb=%0d pp_id=%0d is_last_hcw=%0d -- HCW to be issued - %0d in %0d -- txn_cacheline_wr_ops.waddr=0x%0x cachelineaddr=%0d wlen=%0d", is_ldb, pp_id, is_last_hcw, i, pp_total_cacheline_num, txn_cacheline_wr_ops.waddr, txn_cacheline_wr_ops.waddr[9:6], txn_cacheline_wr_ops.wlen), OVM_MEDIUM)
          //`ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S5 - is_ldb=%0d pp_id=%0d is_last_hcw=%0d -- HCW to be issued - %0d in %0d -- txn_cacheline_wr_ops.waddr=0x%0x cachelineaddr=%0d wlen=%0d byte_en=0x%0x wdata=%p ", is_ldb, pp_id, is_last_hcw, i, pp_total_cacheline_num, txn_cacheline_wr_ops.waddr, txn_cacheline_wr_ops.waddr[9:6], txn_cacheline_wr_ops.wlen, txn_cacheline_wr_ops.wbyte_en, txn_cacheline_wr_ops.wdata), OVM_HIGH)

          `ovm_create(mem_wr)

          qi = cfg.inst_suffix_q.find_index with (item == inst_suffix);

          if (qi.size() > 0) begin
             `ovm_rand_send_with(mem_wr, { dflt_addr == 0;
                           dflt_data == 0;
                           cmd.req_ch_id == cfg.channel_id_q[qi[0]];
                           cmd.src_id == cfg.src_id;
                           cmd.dest_id == cfg.dest_id;
                           cmd.addr                          == txn_cacheline_wr_ops.waddr; //pp_enq_addr;
                           cmd.security_attrib == sai;
                           cmd.len                           == txn_cacheline_wr_ops.wlen;  //len;
                           cmd.data.size                     == txn_cacheline_wr_ops.wlen;  //len;
                           cmd.root_space == 0;
                           cmd.address_type == 0;
                           cmd.process_addr_space_id_execute == 0;
                           cmd.process_addr_space_id_privileged_mode == 0;
                           cmd.processing_hint == 0;
                           cmd.traffic_class == 0;
                           cmd.transaction_hint == 0;
                           cmd.integrity_data_encryption_t == 0;
                           foreach (cmd.data[i]) cmd.data[i] == txn_cacheline_wr_ops.wdata[i]; //wr_data[i];
                           cmd.byte_en                       == txn_cacheline_wr_ops.wbyte_en; //byte_en;
                         })
          end else begin
             `ovm_rand_send_with(mem_wr, { dflt_addr == 0;
                           dflt_data == 0;
                           cmd.req_ch_id == 0;
                           cmd.src_id == cfg.src_id;
                           cmd.dest_id == cfg.dest_id;
                           cmd.addr                          == txn_cacheline_wr_ops.waddr; // pp_enq_addr;
                           cmd.security_attrib == sai;
                           cmd.len                           == txn_cacheline_wr_ops.wlen;  // len;
                           cmd.data.size                     == txn_cacheline_wr_ops.wlen;  // len;
                           cmd.root_space == 0;
                           cmd.address_type == 0;
                           cmd.process_addr_space_id_execute == 0;
                           cmd.process_addr_space_id_privileged_mode == 0;
                           cmd.processing_hint == 0;
                           cmd.traffic_class == 0;
                           cmd.transaction_hint == 0;
                           cmd.integrity_data_encryption_t == 0;
                           foreach (cmd.data[i]) cmd.data[i] == txn_cacheline_wr_ops.wdata[i]; //wr_data[i];
                           cmd.byte_en                       == txn_cacheline_wr_ops.wbyte_en; // byte_en;
                         })
          end//--if (qi.size() 
      end //--for(int i=0; i<pp_total_cacheline_num; i++) 
  end else begin
      if(is_ldb==0) begin 
           `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S4 - is_ldb=%0d pp_id=%0d -- dirpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d is_last_hcw=%0d - HCW not ready to be issued", is_ldb, pp_id, pp_id, dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size(), is_last_hcw), OVM_MEDIUM)
      end else begin
           `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S4 - is_ldb=%0d pp_id=%0d -- ldbpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d is_last_hcw=%0d - HCW not ready to be issued", is_ldb, pp_id, pp_id, ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size(), is_last_hcw), OVM_MEDIUM)
      end
  end//--if((pp_total_cacheline_num == use_max_cacheline_num) || is_last_hcw==1)

  //--report
  if(is_ldb==0) begin 
           `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S6 - is_ldb=%0d pp_id=%0d -- dirpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d is_last_hcw=%0d", is_ldb, pp_id, pp_id, dirpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size(), is_last_hcw), OVM_MEDIUM)
  end else begin
           `ovm_info(get_full_name(),$psprintf("HQM_HCW_IOSF_PRI_ENQ_SEQ:S6 - is_ldb=%0d pp_id=%0d -- ldbpp_enq_storage[%0d].pp_enq_cacheline_wr_q.size=%0d is_last_hcw=%0d", is_ldb, pp_id, pp_id, ldbpp_enq_storage[pp_id].pp_enq_cacheline_wr_q.size(), is_last_hcw), OVM_MEDIUM)
  end

endtask
