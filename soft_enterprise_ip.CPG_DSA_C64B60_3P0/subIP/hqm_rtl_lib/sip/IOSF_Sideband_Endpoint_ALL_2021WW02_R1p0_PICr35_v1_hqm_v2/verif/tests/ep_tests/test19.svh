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
`ifndef TEST19
`define TEST19 

// class: test19 
// Tests basic test flow for the IOSF sideband interface fabric 
class test19 extends base_test;


  iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr, iosf_epvc_seqr;
  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern task run();

  `ovm_component_utils(iosftest_pkg::test19)

endclass :test19

// FUNCTION: new
//
// DESCR:
//  test19 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test19
function test19::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new
function void test19::build();
  super.build();
      fabric_cfg_i.np_crd_buffer = 1;
      fabric_cfg_i.pc_crd_buffer = 10;
  
endfunction :build


task test19::run();
  // locals
  string ep_name, ep_name_fbrc;
  string comp_name,comp_ep_name;
  //unicast_rnd_seq rnd_seqs[string],x, y;
  unicast_rnd_invalid_opcode_seq rnd_seqs[string],x,y;
  unicast_rnd_invalid_opcode_seq_endpoint rnd_seqs_ep[string],x1,y1;
      
  //unsupported_pid_seq unsupp_seqs[string],y;
  int ep_idx;
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  string msg;
      
  // Create random sequences
  ep_name = "Agent_TLM";
  $sformat(comp_name, "%s_Agent_RND_SEQ", ep_name);
  $sformat(comp_ep_name, "%s_Agent_RND_EP_SEQ", ep_name); 
  
  rnd_seqs[ep_name] = unicast_rnd_invalid_opcode_seq::type_id::create("comp_name",this);
  rnd_seqs_ep[ep_name] = unicast_rnd_invalid_opcode_seq_endpoint::type_id::create("comp_ep_name",this);



  ep_name = "Fabric_TLM";
  $sformat(comp_name, "%s_Fabric_RND_SEQ", ep_name);
  $sformat(comp_ep_name, "%s_Fabric_RND_EP_SEQ", ep_name); 
  
   rnd_seqs[ep_name] = unicast_rnd_invalid_opcode_seq::type_id::create("comp_name",this);
   rnd_seqs_ep[ep_name] = unicast_rnd_invalid_opcode_seq_endpoint::type_id::create("comp_ep_name",this);

 


  //Get sequencer Reference      
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
  iosf_epvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();

  //Set posted/non-posted crd_init delay for agent/fabric   
  env_i.iosf_sbc_fabric_vc_i.set_pc_crd_init_delay(5);
  env_i.iosf_sbc_fabric_vc_i.set_np_crd_init_delay(4);         
  env_i.iosf_sbc_ip_vc_i.vc_set_to_claim_all_msg(1'b0);
      
  // Run random sequences
  ep_name = "Agent_TLM";
  ep_name_fbrc = "Fabric_TLM";
      
  if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==31 ||
      env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15 ||
      env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==31 ||
      env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==15)  begin   
    fork
      x1 = rnd_seqs_ep[ep_name];
      x1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
   if (!IS_RATA_ENV) begin
     x1.start(iosf_epvc_seqr);
   end //!RATA
    join_none
    #0;
  
    fork
      y1 = rnd_seqs_ep[ep_name_fbrc];
      y1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
   if (!IS_RATA_ENV) begin
      y1.start(iosf_fbrcvc_seqr);
   end //!RATA
     join_none
    #0;   
  end
  else
  begin
    fork   
      x = rnd_seqs[ep_name];
      x.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
   if (!IS_RATA_ENV) begin
      x.start(iosf_epvc_seqr);
   end //!RATA
    join_none
    #0;  
    fork
      y = rnd_seqs[ep_name_fbrc];
      y.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
   if (!IS_RATA_ENV) begin
      y.start(iosf_fbrcvc_seqr);
   end //!RATA
    join_none
    #0;
    end 

      // Get global stop event reference
      event_pool = ovm_event_pool::get_global_pool();
      stop_send_event = event_pool.get("STOP_SEND");
      
  //random delay
  ovm_report_info("TEST19", "Generate Random Transactions");  
  #50us; 
 
  ovm_report_info("TEST19", "STOP Generating Random Transactions");
   
  stop_send_event.trigger();
        
  ovm_report_info("TEST19", "Stopping further production of new transactions");
  
  #150us;
  // Stop simulation
  global_stop_request();

endtask :run



`endif //FABRIC_AGENT_VC_TEST

