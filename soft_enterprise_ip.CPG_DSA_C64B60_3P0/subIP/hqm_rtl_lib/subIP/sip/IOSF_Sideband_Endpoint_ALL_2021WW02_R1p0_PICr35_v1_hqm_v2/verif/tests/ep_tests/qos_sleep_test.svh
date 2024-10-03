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
`ifndef QOS_SLEEP_TEST
`define QOS_SLEEP_TEST 

// class: qos_sleep_test 
// Tests basic test flow for the IOSF sideband interface fabric 
class qos_sleep_test extends base_test;

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
  `ovm_component_utils(iosftest_pkg::qos_sleep_test)

endclass :qos_sleep_test

// FUNCTION: new
//
// DESCR:
//  qos_sleep_test class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type qos_sleep_test
function qos_sleep_test::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new

function void qos_sleep_test::build();
  super.build();
  fabric_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_12);
  agent_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_12);
  rcvd_msgs = new("rcvd_msgs",this);
  fabric_cfg_i.auto_pm_rsp = 1'b1;
if (!IS_RATA_ENV) begin
  agent_cfg_i.ep_cfg_i.auto_pm_rsp = 1'b1;
  agent_cfg_i.ep_cfg_i.auto_sleep_rsp = 1'b1;
  agent_cfg_i.ep_cfg_i.auto_qos_rsp = 1'b1;
  fabric_cfg_i.compmon_incl_usage = 1'b1;
end //!RATA
  fabric_cfg_i.auto_qos_rsp = 1'b1;
  fabric_cfg_i.auto_sleep_rsp = 1'b1;
  fabric_cfg_i.compmon_incl_usage = 1'b1;
endfunction

function void qos_sleep_test::connect();
   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction

task qos_sleep_test::run();
  // locals
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  iosfsbm_cm::xaction rx_xaction;
  msgd_seq msgd_seq_i,msgd_seq_1, msgd_seq_2, msgd_seq_3;
  qos_seq qos_seq_1,qos_seq_2;
  string msg;
  iosfsbm_cm::iosfsbc_sequencer iosf_ipvc_seqr,iosf_fbrcvc_seqr;
  int crd_reinit_count;  
       
  msgd_seq_i = msgd_seq::type_id::create("MSGD_SEQ",this);   
  msgd_seq_1 = msgd_seq::type_id::create("MSGD_SEQ_1",this);    
  msgd_seq_2 = msgd_seq::type_id::create("MSGD_SEQ_2",this);
  msgd_seq_3 = msgd_seq::type_id::create("MSGD_SEQ_3",this);
  qos_seq_1  = qos_seq::type_id::create("QOS_SEQ_1",this);   
  qos_seq_2  = qos_seq::type_id::create("QOS_SEQ_2",this);   

  //Get sequencer Reference      
  iosf_ipvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();           
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
  env_i.iosf_sbc_fabric_vc_i.disable_clkgating(1);
   
  #1ns;      
  
  msgd_seq_i.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  msgd_seq_i.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'hbb, //Source
                        8'h22, //Dest
                        iosfsbm_cm::OP_PM_REQ, //Opcode
                        3'b001, //tag
                        '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'hbb),
                        .local_dest_pid_i(8'h22)
                        );
if (!IS_RATA_ENV) begin
  msgd_seq_i.start(iosf_ipvc_seqr); 
end //!RATA
 
 #1ns;

  msgd_seq_i.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  msgd_seq_i.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'h22, //Source
                        8'hbb, //Dest
                        iosfsbm_cm::OP_PM_REQ, //Opcode
                        3'b001, //tag
                        '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'h22),
                        .local_dest_pid_i(8'hbb)
                        );
     
if (!IS_RATA_ENV) begin
  msgd_seq_i.start(iosf_fbrcvc_seqr); 
end //!RATA
  


  #1ns;  
  qos_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  qos_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'hAA, //Source
                        8'h44, //Dest
                        iosfsbm_cm::OP_QOS_DMD, //Opcode
                        3'b001, //tag
                        3'b001,//payload
                        0,//valid
                        1,//rsp
                        3'b000,
                        3'b000,
                        10'b0000000000,
                        '{8'h0, 8'h9, 8'h0, 8'h9},
                        4'h0,
                        0,
                        .local_src_pid_i(8'hAA),
                        .local_dest_pid_i(8'h44)
                        );
     
if (!IS_RATA_ENV) begin
  qos_seq_1.start(iosf_ipvc_seqr);  
end //!RATA


#1ns;
  msgd_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  msgd_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'hbb, //Source
                        8'h11, //Dest
                        iosfsbm_cm::OP_QOS_DMD, //Opcode
                        3'b001, //tag
                        '{8'h80, 8'h81, 8'h82, 8'h83, 8'h84, 8'h85, 8'h57, 8'h58}, //64 bit data
                        .misc_i(5'b00010),
                        .local_src_pid_i(8'hbb),
                        .local_dest_pid_i(8'h11)
                        );
      
if (!IS_RATA_ENV) begin
  msgd_seq_1.start(iosf_ipvc_seqr); 
end //!RATA


  #1ns;

  msgd_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  msgd_seq_2.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'hbb, //Source
                        8'h22, //Dest
                        iosfsbm_cm::OP_SLEEP_LEVEL_REQ, //Opcode
                        3'b001, //tag
                        '{8'h80, 8'h81, 8'h82, 8'h83, 8'h84, 8'h85, 8'h57, 8'h58}, //64 bit data
                        .misc_i(5'b00000),
                        .local_src_pid_i(8'hbb),
                        .local_dest_pid_i(8'h22)
                        );
     
if (!IS_RATA_ENV) begin
  msgd_seq_2.start(iosf_ipvc_seqr);
end //!RATA

  
#1ns;               
  msgd_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  msgd_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'h22, //Source
                        8'hbb, //Dest
                        iosfsbm_cm::OP_SLEEP_LEVEL_REQ, //Opcode
                        3'b001, //tag
                        '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'h22),
                        .local_dest_pid_i(8'hbb)
                        );
     
if (!IS_RATA_ENV) begin
  msgd_seq_1.start(iosf_fbrcvc_seqr);
end //!RATA
  #1ns;

  msgd_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  msgd_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'h22, //Source
                        8'hbb, //Dest
                        iosfsbm_cm::OP_QOS_DMD, //Opcode
                        3'b001, //tag
                        '{8'h80, 8'h81, 8'h82, 8'h83, 8'h84, 8'h85, 8'h57, 8'h58}, //64 bit data
                        .misc_i(5'b00010),
                        .local_src_pid_i(8'h22),
                        .local_dest_pid_i(8'hbb)
                        );
     
if (!IS_RATA_ENV) begin
  msgd_seq_1.start(iosf_fbrcvc_seqr);
end //!RATA




   #1ns;  
  qos_seq_2.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  qos_seq_2.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'h44, //Source
                        8'hAA, //Dest
                        iosfsbm_cm::OP_QOS_DMD, //Opcode
                        3'b001, //tag
                        3'b001,//payload
                        0,//valid
                        1,//rsp
                        3'b000,
                        3'b000,
                        10'b0000000000,
                        '{8'h0, 8'h9, 8'h0, 8'h9},
                        4'h0,
                        0,
                        .local_src_pid_i(8'h44),
                        .local_dest_pid_i(8'hAA)
                        );
     
if (!IS_RATA_ENV) begin
  qos_seq_2.start(iosf_fbrcvc_seqr);  
end //!RATA

  
  
  #100us;
      
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("QOS_SLEEP_TEST ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run

`endif //qos_sleep_test

