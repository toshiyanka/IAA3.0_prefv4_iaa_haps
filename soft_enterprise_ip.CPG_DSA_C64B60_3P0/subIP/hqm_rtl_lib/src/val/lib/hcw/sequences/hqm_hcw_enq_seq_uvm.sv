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
//-------------------------------------
//-------------------------------------
//  typedef struct {
//    bit [127:0] waddr;
//    byte        wdata[];
//    int         wlen;
//    bit [63:0]  wbyte_en;        
//  } hqm_enq_cacheline_wr_t;

class hqm_enq_cacheline_wr_ops extends uvm_object;

    `uvm_object_utils(hqm_enq_cacheline_wr_ops)
    bit [127:0] waddr;
    byte        wdata[];
    int         wlen;
    bit [63:0]  wbyte_en; 

  function new(string name="hqm_enq_cacheline_wr_ops");  //[UVM MIGRATION]Added class constructer
     super.new(name);
  endfunction

endclass

typedef struct {
     hqm_enq_cacheline_wr_ops pp_enq_cacheline_wr_q[$];
} pp_enq_storage_t;

//-------------------------------------
//-------------------------------------
class hqm_hcw_enq_seq extends uvm_sequence;

  `uvm_object_utils(hqm_hcw_enq_seq)

  string                inst_suffix;

  rand bit              is_ldb;
  rand logic [5:0]      pp_id;
  rand logic [63:0]     pp_enq_addr;
  rand logic [127:0]    hcw_enq_q[];
  rand logic [7:0]      sai;
  rand bit              is_last_hcw;
  rand int              hqm_max_cacheline_num;
  rand int              hqm_txn_maxcacheline_pad;
  rand int              hqm_cacheline_shuffle;

  //static hqm_enq_cacheline_wr_ops  pp_enq_cacheline_wr_q[$];
  static pp_enq_storage_t          dirpp_enq_storage[hqm_pkg::NUM_DIR_CQ];
  static pp_enq_storage_t          ldbpp_enq_storage[hqm_pkg::NUM_LDB_CQ];

  extern                function        new(string name = "hqm_hcw_enq_seq");
  extern virtual        task            body();

  function void pre_randomize;
  endfunction : pre_randomize

endclass : hqm_hcw_enq_seq

function hqm_hcw_enq_seq::new(string name = "hqm_hcw_enq_seq");
  super.new(name);

endfunction

task hqm_hcw_enq_seq::body();
  `uvm_error(get_full_name(),"hqm_hcw_enq_seq class should be extended for desired enqueue interface")
endtask
