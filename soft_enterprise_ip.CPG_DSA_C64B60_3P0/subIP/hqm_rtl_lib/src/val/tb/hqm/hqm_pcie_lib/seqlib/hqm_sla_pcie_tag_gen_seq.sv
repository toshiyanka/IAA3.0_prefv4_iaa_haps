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

`ifndef HQM_SLA_PCIE_TAG_GEN_SEQ__SV
`define HQM_SLA_PCIE_TAG_GEN_SEQ__SV

//-----------------------------------------------------------------------------------------------------
// File        : hqm_sla_pcie_tag_gen_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence generates variations of Transaction ID (reqID+tag) sent to HQM.
//               Control parameter "HQM_TAG_GEN_SEQ_MODE" has values as below,
//               - 'normal'               -> Sends NP reqs to HQM with all tag values (255/1024)
//               - 'duplicate_req_id'     -> Sends NP reqs to HQM with duplicate txn id
//               - 'unique_random_req_id' -> Sends NP reqs to HQM with random unique txn id
//-----------------------------------------------------------------------------------------------------


class hqm_sla_pcie_tag_gen_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_tag_gen_seq,sla_sequencer)
  sla_ral_data_t        read_val;
  bit                   ten_bit_tag_en;         // -- Value of strap driven to HQM
  string                mode = "";
 
  function new(string name = "hqm_sla_pcie_tag_gen_seq");
    super.new(name);
    ten_bit_tag_en = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));
    if(!$value$plusargs("HQM_TAG_GEN_SEQ_MODE=%s",mode)) mode = "normal";
  endfunction

  task issue_np_req_with_duplicate_txnid(bit unique_req_id = 1);
    sla_ral_reg cfg_reg = pf_cfg_regs.CACHE_LINE_SIZE;
    bit [9:0]  tagbits    = 10'h_0;
    bit [15:0] base_reqID = $urandom_range(0,16'h_ffff);
    Iosf::address_t iosf_addr = ral.get_addr_val(sla_iosf_pri_reg_lib_pkg::get_src_type(), cfg_reg);
    tagbits[9] = ten_bit_tag_en;
    `ovm_info(get_full_name(), $psprintf("Starting issue_np_req_with_duplicate_txnid with unique_req_id (0x%0x), tagbits (0x%0x) and base_reqID (0x%0x)", unique_req_id, tagbits, base_reqID), OVM_LOW);
      for(int i=0; i<=8'h_ff; i++) begin
        `ovm_info(get_full_name(), $psprintf("Next iteration with tagbits (0x%0x) and base_reqID (0x%0x)", tagbits, base_reqID), OVM_LOW);

         send_tlp( get_tlp(iosf_addr, Iosf::CfgWr0, .i_data({8'h_ff}), .i_reqID(i + base_reqID), .i_tag(tagbits) ) );
         if(unique_req_id) tagbits++;
         send_tlp( get_tlp(iosf_addr, Iosf::CfgRd0, .i_reqID(i + base_reqID), .i_tag(tagbits) ), .compare(1), .comp_val(8'h_ff) );
         if(unique_req_id) tagbits++;
         send_tlp( get_tlp(iosf_addr, Iosf::CfgWr0, .i_data({8'h_0}), .i_reqID(i + base_reqID), .i_tag(tagbits) ));
         if(unique_req_id) tagbits++;
         send_tlp( get_tlp(iosf_addr, Iosf::CfgRd0, .i_reqID(i + base_reqID), .i_tag(tagbits) ), .compare(1), .comp_val(8'h_0) );
         if(unique_req_id) tagbits++;
      end
  endtask

  virtual task body();

   pf_cfg_regs.PCIE_CAP_DEVICE_CAP_2.read(status,read_val,primary_id,this,.sai(legal_sai));
   chk_strap_in_devcap2(read_val[16], ten_bit_tag_en, pf_cfg_regs.get_name());

   `ovm_info(get_full_name(),$psprintf("Starting hqm_sla_pcie_tag_gen_seq with mode as (%s)!!",mode),OVM_LOW);
    if(mode=="normal") begin
        for(int i=0;i<1024;i++) begin
          send_rd(master_regs.CFG_DIAGNOSTIC_RESET_STATUS, .with_pasid(0), .ur(0));
          `ovm_info(get_full_name(),$psprintf("Sent PF CSR_BAR Txn #(0x%0x) for tag value (0x%0x)",(i+1),(i+1)),OVM_LOW);
        end
     
        for(int i=0;i<1024;i++) begin
          send_rd(pf_cfg_regs.DEVICE_COMMAND             , .with_pasid(0), .ur(0));
          `ovm_info(get_full_name(),$psprintf("Sent CfgRd0 Txn #(0x%0x) for tag value (0x%0x)",(i+1),(i+1)),OVM_LOW);
        end
    end else if(mode == "duplicate_req_id") begin
        issue_np_req_with_duplicate_txnid(0);
    end else if(mode == "unique_random_req_id") begin
        issue_np_req_with_duplicate_txnid(1);
    end else `ovm_error(get_full_name(), $psprintf("Unknown mode (%s) provided to plusarg 'HQM_TAG_GEN_SEQ_MODE'",mode))
     

  endtask

  function chk_strap_in_devcap2(bit reg_val, bit ten_bit_tag_en, string func_name);
    string log = "";
    log = $psprintf("with ten_bit_tag_en strap (0x%0x) & PCIE_CAP_DEVICE_CAP_2.CMP10BTAGS (0x%0x) for function (%s)", ten_bit_tag_en, reg_val, func_name);

    if(reg_val == ten_bit_tag_en) begin `ovm_info(get_full_name(),$psprintf("Cpl Ten bit tag en strap match %s",log),OVM_LOW) end
    else begin `ovm_error(get_full_name(),$psprintf("Cpl Ten bit tag en strap mismatch %s",log)) end
  endfunction
endclass

`endif
