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
`ifndef TEST37
`define TEST37 

// class: test37 
// Tests basic test flow for the IOSF sideband interface fabric 
class test37 extends base_test;

  //fbrc VC xactions
  tlm_analysis_fifo #(iosfsbm_cm::xaction)  rcvd_msgs;//For received messages
  //Locals
  iosfsbm_seq::base_seq bseq[$];

  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern function void connect();
  extern task run();
  extern task manage_launch();

  `ovm_component_utils(iosftest_pkg::test37)

endclass :test37

// FUNCTION: new
//
// DESCR:
//  test37 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test37
function test37::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new

function void test37::build();
  super.build();
  rcvd_msgs = new("rcvd_msgs", this);
  fabric_cfg_i.fab_parity_chk = 0;    
  agent_cfg_i.en_clk_gate = 1;
  if(BULKRDWR && SB_PARITY_REQUIRED) begin
        fabric_cfg_i.agt_parity_chk = 0;
        fabric_cfg_i.disable_compmon_assertion("SBMI_PARITYERRDETECTED_AGT");
  end      
  fabric_cfg_i.disable_compmon_assertion("ISMPM_079_AGENTMUSTENTER_IDLE_REQ");
  fabric_cfg_i.disable_compmon_assertion("SBMI_PARITYERRDETECTED_FAB");
endfunction

function void test37::connect();
   env_i.iosf_sbc_ip_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction


task test37::manage_launch();
    iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr;
    iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
    foreach(bseq[i]) begin
        bseq[i].start(iosf_fbrcvc_seqr);
        #30us;
        ep_vintf.assert_reset_all = 1'b0;
        #10us;
        ep_vintf.assert_reset_all = 1'b1;
        #20us;
    end
endtask

task test37::run();
  // locals
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  iosfsbm_cm::xaction rx_xaction;
  string msg;
  int crd_reinit_count;  
  simple_seq smpl_seq[];
  regio_seq rg_seq[];
  iosfsbm_cm::flit_t src_pid_t, dest_pid_t;

  smpl_seq = new[8];
  foreach(smpl_seq[i]) begin
    smpl_seq[i] = simple_seq::type_id::create($psprintf("SIMPLE_SEQ_%0d",i),this);
    smpl_seq[i].set_parity_err(1);
    smpl_seq[i].set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                        env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
    src_pid_t = fabric_cfg_i.my_ports[i];
    dest_pid_t = agent_cfg_i.my_ports[i];

    smpl_seq[i].set_fields( 
                                iosfsbm_cm::POSTED, //Xaction_class
                                src_pid_t, //Source
                                dest_pid_t, //Dest
                                iosfsbm_cm::OP_DEASSERT_INTA, //Opcode
                                5'b00000, //Reserved
                                3'b000, //tag
                                .local_src_pid_i(src_pid_t),
                                .local_dest_pid_i(dest_pid_t)
                                );
  end
    
  rg_seq = new[8];
  foreach(rg_seq[i]) begin
    rg_seq[i] =regio_seq::type_id::create($psprintf("REGIO_WR_SEQ_%0d", i),this);
    rg_seq[i].set_parity_err(1);
    rg_seq[i].set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                      env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
    src_pid_t = fabric_cfg_i.my_ports[i];
    dest_pid_t = agent_cfg_i.my_ports[i];

    rg_seq[i].set_fields( 
                                 iosfsbm_cm::NON_POSTED, //Xaction_class
                                 src_pid_t, //Source
                                 dest_pid_t, //Dest
                                 iosfsbm_cm::OP_CFGWR, //Opcode
                                 2'b00, //addrlen                         
                                 3'b000, //bar 
                                 3'b001, //tag
                                 4'h0, //sbe
                                 4'h0, //fbe
                                 8'h00, //fid
                                 '{8'h10, 8'h00}, //address   
                                 '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                                 .local_src_pid_i(src_pid_t),
                                 .local_dest_pid_i(dest_pid_t)
                                 );                  
  end
  
  foreach(smpl_seq[i])
    bseq.push_back(smpl_seq[i]);
  foreach(rg_seq[i])
    bseq.push_back(rg_seq[i]);
  bseq.shuffle();

  manage_launch();

  #30us;
      
  ep_vintf.assert_reset_all = 1'b0;
  #10us;
  ep_vintf.assert_reset_all = 1'b1;

      // Get global stop event
      event_pool = ovm_event_pool::get_global_pool();
      stop_send_event = event_pool.get("STOP_SEND");
      
      stop_send_event.trigger();
      ovm_report_info("TEST37 ", "Stopping Test");
  
      // Stop simulation
      global_stop_request();
endtask :run 
    
`endif //TEST37

