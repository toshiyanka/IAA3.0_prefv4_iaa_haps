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
`ifndef BULK_TRDY_SANITY_TEST 
`define BULK_TRDY_SANITY_TEST 

class  bulk_trdy_sanity_test extends base_test;

    iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr, iosf_epvc_seqr;
  
    extern function new(string name, ovm_component parent);
    extern function void build();
    extern task run();
    extern function void check();

    `ovm_component_utils(iosftest_pkg::bulk_trdy_sanity_test)

endclass : bulk_trdy_sanity_test

//***********************************************************************

function  bulk_trdy_sanity_test::new(string name, ovm_component parent);
    super.new(name, parent);
endfunction :new

//***********************************************************************

function void  bulk_trdy_sanity_test::build();
    super.build();  
    agent_cfg_i.treg_sanity_en = 1;
    agent_cfg_i.rsp_err_inj_en = 0;
endfunction :build

//***********************************************************************

task  bulk_trdy_sanity_test::run();
    string ep_name, ep_name_fbrc;
    string comp_name,comp_ep_name;
    unicast_bulk_seq bulk_rnd_seqs[string],x,y;
    unicast_rnd_seq_endpoint rnd_seqs_ep[string], uni_fab, x1,y1;
    unicast_rnd_seq rnd_seqs[string], uni_ep;
    iosf_sb_seq sb_seq;
    ovm_event_pool event_pool;
    ovm_event stop_send_event;
    string msg;
    bit claim_off;
    int num_chunk;
    int addr_len;
    bit[1:0]               space[];
    iosfsbm_cm::flit_t     fid[];
    iosfsbm_cm::flit_t     data_length[];
    iosfsbm_cm::flit_t     addr[][];
    iosfsbm_cm::flit_t     data[][];
    
   claim_off = $random;
   if (claim_off && !DISABLE_COMPLETION_FENCING)
     begin
        ovm_report_info("BASE TEST", "VC is set not to claim all message"); 
        env_i.iosf_sbc_ip_vc_i.vc_set_to_claim_all_msg(0);
     end
  // Create random sequences
    
    ep_name = "Agent_TLM";
    $sformat(comp_name, "%s_Agent_RND_SEQ", ep_name);
    $sformat(comp_ep_name, "%s_Agent_RND_EP_SEQ", ep_name); 
    bulk_rnd_seqs[ep_name] = unicast_bulk_seq::type_id::create("comp_name",this);
    rnd_seqs[ep_name] = unicast_rnd_seq::type_id::create("comp_name",this);
    rnd_seqs_ep[ep_name] = unicast_rnd_seq_endpoint::type_id::create("comp_ep_name",this);
     
    sb_seq = iosf_sb_seq::type_id::create("iosf_sb_seq",this);

    ep_name = "Fabric_TLM";
    $sformat(comp_name, "%s_Fabric_RND_SEQ", ep_name);
    $sformat(comp_ep_name, "%s_Fabric_RND_EP_SEQ", ep_name); 
    bulk_rnd_seqs[ep_name] = unicast_bulk_seq::type_id::create("comp_name",this);
    rnd_seqs[ep_name] = unicast_rnd_seq::type_id::create("comp_name",this);
    rnd_seqs_ep[ep_name] = unicast_rnd_seq_endpoint::type_id::create("comp_ep_name",this);

    iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
    iosf_epvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();

    env_i.iosf_sbc_fabric_vc_i.set_pc_crd_init_delay(0);
    env_i.iosf_sbc_fabric_vc_i.set_np_crd_init_delay(0);         
    env_i.iosf_sbc_fabric_vc_i.set_crd_update_delay(0);   
    env_i.iosf_sbc_fabric_vc_i.set_clkack_deassert_delay(1);
    env_i.iosf_sbc_fabric_vc_i.set_xaction_delay(0);
    env_i.iosf_sbc_ip_vc_i.set_free_delay(POSTED, 0);
    env_i.iosf_sbc_ip_vc_i.set_free_delay(NON_POSTED, 0);
    env_i.iosf_sbc_fabric_vc_i.set_driver_delay(0);
    env_i.iosf_sbc_fabric_vc_i.turn_off_flit_delay(1);
    env_i.iosf_sbc_fabric_vc_i.set_xaction_delay(0);
                 
    ep_name = "Agent_TLM";
    ep_name_fbrc = "Fabric_TLM";
    
    num_chunk = 3;
    addr_len = 2;
    space = new[num_chunk];
    fid = new[num_chunk];
    data_length = new[num_chunk]; 
    addr = new[num_chunk];
    data = new[num_chunk];
    
    foreach(space[i])
        space[i] = iosfsbm_cm::MEM_SPACE;
    foreach(fid[i])
        fid[i] = $urandom_range(1,200);
    foreach(data_length[i])
        data_length[i] = 1;
    foreach(data[i]) begin
        data[i] = new[data_length[i]*4];
        foreach(data[i][j])
            data[i][j] = $urandom_range(200,2000);
    end 
    foreach(addr[i]) begin
        addr[i] = new[addr_len];
        foreach(addr[i][j]) begin
            addr[i][j] = $urandom_range(2000,5000);
            addr[i][j][1:0] = 'h00;
        end    
    end       
    /*
    sb_seq.send_xaction(.iosfsbc_seqr(iosf_fbrcvc_seqr),
                             .xaction_class_i(iosfsbm_cm::POSTED), 
                             .src_pid_i(8'h11),
                             .dest_pid_i(8'haa),
                             .opcode_i(8'h09), 
                             .tag_i(3'b010),
							 .bulk_space_i(space),
                             .bulk_fid_i(fid),
                             .data_length_i(data_length),
                             .bulk_addr_i(addr),
                             .bulk_data_i(data));

    sb_seq.send_xaction(.iosfsbc_seqr(iosf_fbrcvc_seqr),
                             .xaction_class_i(iosfsbm_cm::NON_POSTED), 
                             .src_pid_i(8'h11),
                             .dest_pid_i(8'haa),
                             .opcode_i(8'h08), 
                             .tag_i(3'b010),
							 .bulk_space_i(space),
                             .bulk_fid_i(fid),
                             .data_length_i(data_length),
                             .bulk_addr_i(addr));

    */ 
    fork
      
      y = bulk_rnd_seqs[ep_name_fbrc];
      y.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
      y.start(iosf_fbrcvc_seqr);
      
      uni_fab = rnd_seqs_ep[ep_name_fbrc];
      uni_fab.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                      env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
      //uni_fab.start(iosf_fbrcvc_seqr);
/*       
      x = bulk_rnd_seqs[ep_name];
      x.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
      x.start(iosf_epvc_seqr);
*/      
    join_none
    #0;
    

    event_pool = ovm_event_pool::get_global_pool();
    stop_send_event = event_pool.get("STOP_SEND");
    
     /* 
    fork
        forever begin
            if(stop_send_event.is_on()) break;
            #1ns;
            ovm_report_info(get_name(), "SMMM: Setting seq to stop!!");
            foreach(bulk_rnd_seqs[n])
                bulk_rnd_seqs[n].control_trans(1'b1); //stop sequence 
            #10us;
            ovm_report_info(get_name(), "SMMM: Setting seq to run!!");
            foreach(bulk_rnd_seqs[n])
                bulk_rnd_seqs[n].control_trans(1'b0);
        end               
    join_none
    #0;      
    */

    ovm_report_info("BULK_TRDY_SANITY_TEST", "Generate Random Transactions");  
    #100us; 
    ovm_report_info("BULK_TRDY_SANITY_TEST", "STOP Generating Random Transactions");
    stop_send_event.trigger();
    ovm_report_info("BULK_TRDY_SANITY_TEST", "Stopping further production of new transactions");

    #150us;
    global_stop_request();
endtask :run

function void bulk_trdy_sanity_test::check();
    if(env_i.iosf_sbc_fabric_vc_i.q_is_empty == 0)
        ovm_report_error(get_name(), "Check sb_rsp, queue is not empty!!");
endfunction

//***********************************************************************
`endif 

