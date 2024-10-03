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
`ifndef TEST20
`define TEST20 

// class: test20 
// Tests basic test flow for the IOSF sideband interface fabric 
class test20 extends base_test;

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
  `ovm_component_utils(iosftest_pkg::test20)

endclass :test20

// FUNCTION: new
//
// DESCR:
//  test20 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test20
function test20::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new

function void test20::build();
  super.build();
  rcvd_msgs = new("rcvd_msgs", this);
     

endfunction

function void test20::connect();
   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction

task test20::run();
  // locals
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  iosfsbm_cm::xaction rx_xaction;
  simple_seq simple_seq_1, simple_seq_2, simple_seq_3,simple_seq_4;
  msgd_seq msgd_seq_i,msgd_seq_1;
  regio_seq regio_rd_seq_1,regio_rd_seq_2,regio_rd_seq_3,regio_wr_seq_1, regio_wr_seq_2,regio_wr_seq_3,regio_wr_seq_4; 
  string msg;
  iosfsbm_cm::iosfsbc_sequencer iosf_ipvc_seqr,iosf_fbrcvc_seqr;
  int crd_reinit_count;  
       
  simple_seq_1 = simple_seq::type_id::create("SIMPLE_SEQ_1",this);
  simple_seq_2 = simple_seq::type_id::create("SIMPLE_SEQ_2",this);
  simple_seq_3 = simple_seq::type_id::create("SIMPLE_SEQ_3",this);
  simple_seq_4 = simple_seq::type_id::create("SIMPLE_SEQ_4",this);

  msgd_seq_i = msgd_seq::type_id::create("MSGD_SEQ",this);   
  msgd_seq_1 = msgd_seq::type_id::create("MSGD_SEQ_1",this); 

  regio_rd_seq_1 =regio_seq::type_id::create("REGIO_RD_SEQ_1",this);
  regio_rd_seq_2 =regio_seq::type_id::create("REGIO_RD_SEQ_2",this);      
  
  regio_wr_seq_1 =regio_seq::type_id::create("REGIO_WR_SEQ_1",this);
  regio_wr_seq_4 =regio_seq::type_id::create("REGIO_wr_SEQ_4",this);      
  regio_wr_seq_3 =regio_seq::type_id::create("REGIO_WR_SEQ_3",this);   
  regio_wr_seq_2 =regio_seq::type_id::create("REGIO_WR_SEQ_2",this); 
      
  //Get sequencer Reference      
  iosf_ipvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();           
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();

  regio_rd_seq_2.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                         env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                            8'h11, //Source
                            8'haa, //Dest            
                            iosfsbm_cm::OP_MRD, //opcode
                            2'b00, //addrlen                         
                            3'b000, //bar 
                            3'b001, //tag
                            4'h0, //sbe
                            4'h0, //fbe
                            8'h00, //fid
                            '{8'h30, 8'h40}, //address   
                            .local_src_pid_i(8'h11),
                            .local_dest_pid_i(8'haa)
                            );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==63)
  begin                              
    regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CRRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h30, 8'h40,8'h30, 8'h40,8'h30, 8'h40}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );
  end                              
  else
  begin
    regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h30, 8'h40}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'haa)
                         );   
  end                         
  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

  // Send xactions from fabric_TLM
  simple_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  simple_seq_1.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'h11, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b001, //tag
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'haa)
                          );
 
  if (!IS_RATA_ENV) begin
  simple_seq_1.start(iosf_fbrcvc_seqr);
  end //!RATA
             
  #2us;
  // Send xactions from ep_TLM
  simple_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                       env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_1.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b001, //tag
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
  if (!IS_RATA_ENV) begin
  simple_seq_1.start(iosf_ipvc_seqr);
  end //!RATA
  #50us;
 
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("TEST20 ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run

`endif //TEST20

