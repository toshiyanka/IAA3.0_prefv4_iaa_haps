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
`ifndef TEST21
`define TEST21 

// class: test21 
// Tests basic test flow for the IOSF sideband interface fabric 
class test21 extends base_test;

  //fbrc VC xactions
  tlm_analysis_fifo #(iosfsbm_cm::agent_ism_type_e)  agt_ism_msgs;//For received messages
  //Locals
  event trigger_agent_idle_req_to_idle;

  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern function void connect();
  extern task run();
  extern task gen_agent_idle_event ();      
  `ovm_component_utils(iosftest_pkg::test21)

endclass :test21

// FUNCTION: new
//
// DESCR:
//  test21 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test21
function test21::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new

function void test21::build();
  super.build();
  agt_ism_msgs = new("agt_ism_msgs", this);
  agent_cfg_i.clkreq_assert_delay = 50;
      
endfunction

function void test21::connect();
   env_i.iosf_sbc_fabric_vc_i.agt_ism_ap.connect(agt_ism_msgs.analysis_export);
endfunction

task test21::run();
  // locals
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  iosfsbm_cm::xaction rx_xaction;
  simple_seq simple_seq_1, simple_seq_2, simple_seq_3,simple_seq_4,simple_seq_5, simple_seq_6;
  msgd_seq msgd_seq_i,msgd_seq_1, msgd_seq_2, msgd_seq_3;
  regio_seq regio_rd_seq_1,regio_rd_seq_2,regio_rd_seq_3,regio_wr_seq_1, regio_wr_seq_2,regio_wr_seq_3,regio_wr_seq_4; 
  string msg;
  iosfsbm_cm::iosfsbc_sequencer iosf_ipvc_seqr,iosf_fbrcvc_seqr;
  int crd_reinit_count;  
       
  // Create the SIMPLE sequence
  simple_seq_1 = simple_seq::type_id::create("SIMPLE_SEQ_1");

  //Get sequencer Reference      
  iosf_ipvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();           
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
   


  fork
     gen_agent_idle_event();
     join_none
       
 if (!IS_RATA_ENV) begin
  // Send xactions from ep_TLM
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
  simple_seq_1.start(iosf_ipvc_seqr);
  

  wait(trigger_agent_idle_req_to_idle.triggered);
  #2ns;
     
  $display("ddD", "sending xaction");   
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
 
  simple_seq_1.start(iosf_ipvc_seqr);
  simple_seq_1.start(iosf_ipvc_seqr);
  simple_seq_1.start(iosf_ipvc_seqr);
  simple_seq_1.start(iosf_ipvc_seqr);
  simple_seq_1.start(iosf_ipvc_seqr);
  simple_seq_1.start(iosf_ipvc_seqr);
  simple_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

      
  #50us;
   
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("TEST21 ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run

  task test21::gen_agent_idle_event ();
  agent_ism_type_e ismstate;
  bit agent_idle_req=1'b0;
      
     forever begin                     
        agt_ism_msgs.get(ismstate);
        $display("ddd", "ism state=%s, agent_idle_req=%d", ismstate.name(), agent_idle_req);
        
        if (ismstate == iosfsbm_cm::AGENT_IDLE_REQ)
          /*agent_idle_req=1'b1;
        else if (ismstate != iosfsbm_cm::AGENT_IDLE && ismstate != iosfsbm_cm::AGENT_IDLE_REQ)
          agent_idle_req=1'b0;

        if (ismstate == iosfsbm_cm::AGENT_IDLE && agent_idle_req)        
         begin
            */-> trigger_agent_idle_req_to_idle;
            $display("ddD", "event triggered");
         //end
        
     end


endtask // test02
      
`endif //TEST21

