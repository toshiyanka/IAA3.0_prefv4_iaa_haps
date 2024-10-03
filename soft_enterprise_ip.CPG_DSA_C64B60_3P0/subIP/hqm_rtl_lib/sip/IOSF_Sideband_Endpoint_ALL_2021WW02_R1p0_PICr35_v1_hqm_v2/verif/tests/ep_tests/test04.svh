//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2021WW02_PICr35
//
//------------------------------------------------------------------------------
`ifndef TEST04
`define TEST04 

// class: test04 
// Tests back to back non-posted messages, exhaust all tags 
class test04 extends base_test;

  //fbrc VC xactions
  tlm_analysis_fifo #(iosfsbm_cm::xaction)  rcvd_msgs;//For received messages
  //Locals
  
  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern function void connect();
  extern task run();
  `ovm_component_utils(iosftest_pkg::test04)

endclass :test04

// FUNCTION: new
//
// DESCR:
//  test04 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test04
function test04::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new

function void test04::build();
  super.build();
  rcvd_msgs = new("rcvd_msgs", this);
endfunction

function void test04::connect();
   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction

task test04::run();
  // locals
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  iosfsbm_cm::xaction rx_xaction;
  simple_seq simple_seq_1, simple_seq_2, simple_seq_3,simple_seq_4, simple_seq_5, simple_seq_6, simple_seq_7,simple_seq_8;
  msgd_seq msgd_seq_i,msgd_seq_1;
  regio_seq regio_rd_seq_1,regio_rd_seq_2,regio_rd_seq_3,regio_wr_seq_1, regio_wr_seq_2,regio_wr_seq_3,regio_wr_seq_4; 
  string msg;
  iosfsbm_cm::iosfsbc_sequencer iosf_ipvc_seqr,iosf_fbrcvc_seqr;
  int crd_reinit_count;  
       
  simple_seq_1 = simple_seq::type_id::create("SIMPLE_SEQ_1",this);
  simple_seq_2 = simple_seq::type_id::create("SIMPLE_SEQ_2",this);
  simple_seq_3 = simple_seq::type_id::create("SIMPLE_SEQ_3",this);
  simple_seq_4 = simple_seq::type_id::create("SIMPLE_SEQ_4",this);
  simple_seq_5 = simple_seq::type_id::create("SIMPLE_SEQ_5",this);
  simple_seq_6 = simple_seq::type_id::create("SIMPLE_SEQ_6",this);
  simple_seq_7 = simple_seq::type_id::create("SIMPLE_SEQ_7",this);
  simple_seq_8 = simple_seq::type_id::create("SIMPLE_SEQ_8",this);   
 
      
  //Get sequencer Reference      
  iosf_ipvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();           
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
  env_i.iosf_sbc_fabric_vc_i.disable_clkgating(1);
  env_i.iosf_sbc_fabric_vc_i.set_compl_delay(60);

  // Send xactions from ep_TLM
  if ( env_i.iosf_sbc_ip_vc_i.agent_cfg_i.iosfsb_spec_rev < IOSF_083)
    begin 
       simple_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                            env_i.iosf_sbc_ip_vc_i.common_cfg_i);
       simple_seq_1.set_fields( 
                                iosfsbm_cm::NON_POSTED, //Xaction_class
                                8'haa, //Source
                                8'h11, //Dest
                                iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                                3'b000, //tag
                                .local_src_pid_i(8'haa),
                                .local_dest_pid_i(8'h11)

                          );
    if (!IS_RATA_ENV) begin
       simple_seq_1.start(iosf_ipvc_seqr);
    end //!RATA

  // Send xactions from ep_TLM
  simple_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_2.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b001, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_2.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_3.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_3.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b010, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_3.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_4.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b011, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
   simple_seq_4.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_5.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_5.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b100, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_5.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_6.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_6.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b101, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_6.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_7.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_7.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b110, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_7.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_8.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_8.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b111, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_8.start(iosf_ipvc_seqr);
 end //!RATA
    end 
  else
    begin
       simple_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                            env_i.iosf_sbc_ip_vc_i.common_cfg_i);
       simple_seq_1.set_fields( 
                                iosfsbm_cm::POSTED, //Xaction_class
                                8'haa, //Source
                                8'h11, //Dest
                                iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                                3'b000, //tag
                                .local_src_pid_i(8'haa),
                                .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
       simple_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b001, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_2.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_3.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_3.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b010, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_3.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_4.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_4.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b011, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_4.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_5.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_5.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b100, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_5.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_6.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_6.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b101, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_6.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_7.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_7.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b110, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_7.start(iosf_ipvc_seqr);
 end //!RATA

  // Send xactions from ep_TLM
  simple_seq_8.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_8.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b111, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin
  simple_seq_8.start(iosf_ipvc_seqr);
 end //!RATA
    end       
      
  #30us;
      
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("TEST04 ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run

`endif //TEST04
