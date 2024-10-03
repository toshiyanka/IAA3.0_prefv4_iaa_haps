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
`ifndef TEST35
`define TEST35 

// class: test35 
// Tests basic test flow for the IOSF sideband interface fabric 
class test35 extends base_test;


  iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr, iosf_epvc_seqr;
  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern task run();

  `ovm_component_utils(iosftest_pkg::test35)

endclass :test35

// FUNCTION: new
//
// DESCR:
//  test35 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test35
function test35::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new
function void test35::build();
  super.build();
      //agent_cfg_i.disable_idle = 1;
      fabric_cfg_i.np_crd_buffer = 1;
      fabric_cfg_i.pc_crd_buffer = 10;
      fabric_cfg_i.fab_parity_chk = 1;
      fabric_cfg_i.agt_parity_chk = 1;
      fabric_cfg_i.fab_parity_defeature = 0;
      if(BULKRDWR && SB_PARITY_REQUIRED) begin
        fabric_cfg_i.agt_parity_chk = 0;
        fabric_cfg_i.disable_compmon_assertion("SBMI_PARITYERRDETECTED_AGT");
      end  
      fabric_cfg_i.disable_compmon_assertion("ISMPM_079_AGENTMUSTENTER_IDLE_REQ");
      fabric_cfg_i.disable_compmon_assertion("SBMI_PARITYERRDETECTED_FAB");
endfunction :build


task test35::run();
  // locals
  string ep_name, ep_name_fbrc;
  string comp_name,comp_ep_name;
  //unicast_rnd_seq rnd_seqs[string],x, y;
  iosfsbm_seq::unicast_rnd_seq rnd_seqs[string];
  iosfsbm_seq::unicast_rnd_seq_endpoint rnd_seqs_ep[string];
  //unicast_rnd_seq rnd_seqs[string],x,y;
  //unicast_rnd_seq_endpoint rnd_seqs_ep[string],x1,y1;
  iosfsbm_seq::base_seq x, y;
  //unsupported_pid_seq unsupp_seqs[string],y;
  int ep_idx;
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  string msg;
  logic [2:0] ism_state;
  bit credit_returned;
    
  // Create random sequences
  ep_name = "Agent_TLM";
  $sformat(comp_name, "%s_Agent_RND_SEQ", ep_name);
  $sformat(comp_ep_name, "%s_Agent_RND_EP_SEQ", ep_name); 
  
  rnd_seqs[ep_name] = iosfsbm_seq::unicast_rnd_seq::type_id::create("comp_name",this);
  rnd_seqs_ep[ep_name] = iosfsbm_seq::unicast_rnd_seq_endpoint::type_id::create("comp_ep_name",this);



  ep_name = "Fabric_TLM";
  $sformat(comp_name, "%s_Fabric_RND_SEQ", ep_name);
  $sformat(comp_ep_name, "%s_Fabric_RND_EP_SEQ", ep_name); 
  
   rnd_seqs[ep_name] = iosfsbm_seq::unicast_rnd_seq::type_id::create("comp_name",this);
   rnd_seqs_ep[ep_name] = iosfsbm_seq::unicast_rnd_seq_endpoint::type_id::create("comp_ep_name",this);

   foreach(rnd_seqs[i]) rnd_seqs[i].delay_ovrd = 1;
   foreach(rnd_seqs_ep[i]) rnd_seqs_ep[i].delay_ovrd = 1; 


  //Get sequencer Reference      
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
  iosf_epvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();

  //Set posted/non-posted crd_init delay for agent/fabric   
  env_i.iosf_sbc_fabric_vc_i.set_pc_crd_init_delay(5);
  env_i.iosf_sbc_fabric_vc_i.set_np_crd_init_delay(4);         
  env_i.iosf_sbc_ip_vc_i.vc_set_to_claim_all_msg(1'b0);
  //fabric_vintf.control_ep_reset = 1'b1;

  // Run random sequences
  ep_name = "Agent_TLM";
  ep_name_fbrc = "Fabric_TLM";
  
  if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==31 ||
      env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15 ||
      env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==31 ||
      env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==15)  begin
    x = rnd_seqs_ep[ep_name];
    y = rnd_seqs_ep[ep_name_fbrc];
  end
  else begin
    x = rnd_seqs[ep_name];
    y = rnd_seqs[ep_name_fbrc];
  end
  
 if (!IS_RATA_ENV) begin
  x.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
            env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  y.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
            env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
 end //!RATA  
 else
 begin
  x.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
            env_i.iosf_sbc_ip_vc_i.common_cfg_i,.reg_txn_only(1'b1));
  y.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
            env_i.iosf_sbc_fabric_vc_i.common_cfg_i,.reg_txn_only(1'b1));
 end
  
  //y.set_parity_err(1);
  
  fork
   if (!IS_RATA_ENV) begin
    x.start(iosf_epvc_seqr);
   end //!RATA      
    y.start(iosf_fbrcvc_seqr);
  join_none
  

    for(int i=0; i<8; i++) begin
        if($urandom_range(1,0) == 1)
        #10us;
        y.set_parity_err(0);
        x.set_parity_err(0);
        ep_vintf.parity_defeature = 0;
        #5us;
        ep_vintf.parity_defeature = 1;
        #10us;
    
        x.control_trans(1);
        y.control_trans(1);
        
        #110us;
        if(ep_vintf.side_ism_lock_b == 0) begin
            ep_vintf.side_ism_lock_b = 1;
            #10us;    
        end

        ism_state = env_i.iosf_sbc_fabric_vc_i.get_ism_state();
        credit_returned = env_i.iosf_sbc_fabric_vc_i.is_credit_returned();

         if(ism_state != 3'b011)
         begin
          ovm_report_info(get_name(), $psprintf("SMMM: ism_state = %0b", ism_state));
         end
        if(!credit_returned)
         begin
          ovm_report_info(get_name(), $psprintf("SMMM: credits are not returned", credit_returned));
         end


        ep_vintf.assert_reset_all = 1'b0;
        #10us;
        ep_vintf.assert_reset_all = 1'b1;
    
        x.set_parity_err(0);
        y.set_parity_err(0);

        x.control_trans(0);
        y.control_trans(0);
    end


      // Get global stop event reference
      event_pool = ovm_event_pool::get_global_pool();
      stop_send_event = event_pool.get("STOP_SEND");
      
  //random delay
  ovm_report_info("TEST35", "Generate Random Transactions");  
  #20us; 
 
  ovm_report_info("TEST35", "STOP Generating Random Transactions");
   
  stop_send_event.trigger();
        
  ovm_report_info("TEST35", "Stopping further production of new transactions");
  
  #150us;
  // Stop simulation
  global_stop_request();

endtask :run



`endif //FABRIC_AGENT_VC_TEST

