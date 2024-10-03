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
`ifndef TEST14
`define TEST14 

// class: test14 
// Tests basic test flow for the IOSF sideband interface fabric 
class test14 extends base_test;
  polling_seq reg_rd_seq;
  regio_seq reg_wr_seq;
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
  protected static int xactID;

  iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr, iosf_epvc_seqr;
  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern task run();
  extern task read_reg(input bit[15:0] addr, output bit[31:0] data);
  extern task write_reg(bit[15:0] addr, bit[31:0] data);
  extern task sendRandomRegTrans();  
  `ovm_component_utils(iosftest_pkg::test14)

endclass :test14

// FUNCTION: new
//
// DESCR:
//  test14 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test14
function test14::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new
function void test14::build();
  super.build();
      fabric_cfg_i.np_crd_buffer = 1;
      fabric_cfg_i.pc_crd_buffer = 10;
      reg_wr_seq = regio_seq::type_id::create("reg_wr_seq",this);
      reg_rd_seq = polling_seq::type_id::create("reg_rd_seq",this);
      
endfunction :build


task test14::run();
  // locals
  string ep_name, ep_name_fbrc;
  string comp_name,comp_ep_name;
  //unicast_rnd_seq rnd_seqs[string],x, y;
  unicast_invalid_seq rnd_seqs[string],x,y;
  unicast_invalid_seq_endpoint rnd_seqs_ep[string],x1,y1;
      
  //unsupported_pid_seq unsupp_seqs[string],y;
  int ep_idx;
  //ovm_event_pool event_pool;
  //ovm_event stop_send_event;
  string msg;
      
  // Create random sequences
  ep_name = "Agent_TLM";
  $sformat(comp_name, "%s_Agent_RND_SEQ", ep_name);
  $sformat(comp_ep_name, "%s_Agent_RND_EP_SEQ", ep_name); 
  
  rnd_seqs[ep_name] = unicast_invalid_seq::type_id::create("comp_name",this);
  rnd_seqs_ep[ep_name] = unicast_invalid_seq_endpoint::type_id::create("comp_ep_name",this);

  ep_name = "Fabric_TLM";
  $sformat(comp_name, "%s_Fabric_RND_SEQ", ep_name);
  $sformat(comp_ep_name, "%s_Fabric_RND_EP_SEQ", ep_name); 
  
  rnd_seqs[ep_name] = unicast_invalid_seq::type_id::create("comp_name",this);
  rnd_seqs_ep[ep_name] = unicast_invalid_seq_endpoint::type_id::create("comp_ep_name",this);
 
  //Get sequencer Reference      
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
  iosf_epvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();

  //Set posted/non-posted crd_init delay for agent/fabric   
  env_i.iosf_sbc_fabric_vc_i.set_pc_crd_init_delay(5);
  env_i.iosf_sbc_fabric_vc_i.set_np_crd_init_delay(4);         
  //env_i.iosf_sbc_ip_vc_i.vc_set_to_randomly_claim_msg();
  env_i.iosf_sbc_ip_vc_i.vc_set_to_claim_all_msg(0);    
     
  // Run random sequences
  ep_name = "Agent_TLM";
  ep_name_fbrc = "Fabric_TLM";
      
  // Get global stop event reference
      event_pool = ovm_event_pool::get_global_pool();
      stop_send_event = event_pool.get("STOP_SEND");
    fork   
      x = rnd_seqs[ep_name];
      x.set_count(1000);
       
      x.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);

  if (!IS_RATA_ENV) begin
      x.start(iosf_epvc_seqr);
  end //!RATA
    join_none
    #0;  
    fork
      y = rnd_seqs[ep_name_fbrc];
      y.set_count(1000);
       
      y.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  if (!IS_RATA_ENV) begin
      y.start(iosf_fbrcvc_seqr);
  end //!RATA
    join_none
    #0;
       
    fork
       sendRandomRegTrans(); 
    join_none
    #0;       

      // Get global stop event reference
      //event_pool = ovm_event_pool::get_global_pool();
      //stop_send_event = event_pool.get("STOP_SEND");
      
  //random delay
  //ovm_report_info("TEST14", "Generate Random Transactions");  
  #50us; 
 
  ovm_report_info("TEST14", "STOP Generating Random Transactions");
   
  stop_send_event.trigger();
        
  ovm_report_info("TEST14", "Stopping further production of new transactions");
  
  #100us;
  // Stop simulation
  global_stop_request();

endtask :run

task test14::sendRandomRegTrans();
   bit[31:0] data, readData;
   bit[15:0] addr;
   int transCnt, idx;

   idx = 0;      
   transCnt = 50;
      
   while(idx < transCnt) begin
     addr = $urandom;
     data = $urandom;
     if(stop_send_event.is_on()) break;
     write_reg( addr, data);
     #50;
     read_reg(addr, readData);
     idx++;
   end // while
endtask : sendRandomRegTrans

task test14::write_reg(bit[15:0] addr, bit[31:0] data);
  //Local
  bit[7:0] wr_data[]; // data to be written
  bit[7:0] addr_byte_list[]; // addr value but packed as a list of bytes.
      
  //Set the address as a list of bytes.
  addr_byte_list[0]=addr[7:0];
  addr_byte_list[1]=addr[15:8];
	
  for(int j=0; j < 4; j++) begin
     wr_data[j]=data[(8*j)+7 -:8];
  end
	
   // WRITE RTL - Run regio sequence from Fabric_TLM - Write
   reg_wr_seq.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                  env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
   reg_wr_seq.set_fields(
                     .xaction_class_i(iosfsbm_cm::POSTED), //Xaction_class
                     .src_pid_i(8'h11), //Source
                     .dest_pid_i(8'haa), //Dest            
                     .opcode_i(8'h07), //opcode for CRWr
                     .addrlen_i(2'b00), //addrlen                         
                     .bar_i(3'b000), //bar 
                     .tag_i(3'b000), //tag=0 for posted
                     .fbe_i(4'b1111), //fbe
                     .sbe_i(4'b0000), //fbe
                     .fid_i(8'h00),
                     .addr_i(addr_byte_list), //address   
		             .data_i(wr_data),
                     .local_src_pid_i(8'h11),
                     .local_dest_pid_i(8'haa)
		     );    
   reg_wr_seq.start(iosf_fbrcvc_seqr);

endtask

/******************************************************************************
 * Read PSF register with addr address and check if returned completion 
 * has the same data payload as the one read from TB RegMap registers[addr].
 ******************************************************************************/
task test14::read_reg(input bit[15:0] addr, output bit[31:0] data);

  bit[7:0] addr_byte_list[]; // addr value but packed as a list of bytes.
      
  //Set the address as a list of bytes.
      addr_byte_list[0]=addr[7:0];
      addr_byte_list[1]=addr[15:8];
      xactID++;
      
      reg_rd_seq.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                         env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
      reg_rd_seq.set_fields(
		        .xaction_class_i(iosfsbm_cm::NON_POSTED), 
                        .src_pid_i(8'h11), 
                        .dest_pid_i(8'haa),          
                        .opcode_i(8'h06), 
                        .addrlen_i(2'b00),                       
                        .bar_i(3'b000), 
                        .tag_i(3'b000), 
                        .fbe_i(4'b1111),
                        .sbe_i(4'h0),
                        .fid_i(8'h00), 
                        .addr_i(addr_byte_list),
                        .expect_rsp(1'b1),
                        .xact_id(xactID),
                        .local_src_pid_i(8'h11),
                        .local_dest_pid_i(8'haa)
                        );

      //Blocked Until Read data Available  
      reg_rd_seq.start(iosf_fbrcvc_seqr);

      ovm_report_info("TEST14",
                      $psprintf(" Read Data:%p from Addr: %p", 
                                reg_rd_seq.cmpl_data, addr_byte_list));
      
endtask 
      
`endif //FABRIC_AGENT_VC_TEST

