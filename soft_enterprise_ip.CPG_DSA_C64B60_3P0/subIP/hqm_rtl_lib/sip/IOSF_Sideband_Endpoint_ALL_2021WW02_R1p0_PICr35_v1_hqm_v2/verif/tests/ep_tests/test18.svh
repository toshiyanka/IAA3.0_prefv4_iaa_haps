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
`ifndef TEST18_1
`define TEST18_1 

// TO RUN TEST18_1: make iptest TEST=test18_1 INT=0 ASYNC_RESET=1 RESET_TEST=1

// class: test18_1 
// Tests to check inband reset
`ifndef IOSF_SB_PH2  
class test18_1#(int PAYLOAD_WIDTH=MAXPLDBIT+1, 
                int AGENT_MASTERING_SB_IF=0, 
                int MAXPCMSTR=DEFAULT_MAXPCMSTR,
                int MAXNPMSTR=DEFAULT_MAXNPMSTR, 
                int MAXPCTRGT=DEFAULT_MAXPCTRGT, 
                int MAXNPTRGT=DEFAULT_MAXNPTRGT, 
                int MAXPLDBIT=MAXPLDBIT,
                int MAXTRGTADDR=DEFAULT_MAXTRGTADDR,
                int MAXTRGTDATA=DEFAULT_MAXTRGTDATA,
                int MAXMSTRADDR=DEFAULT_MAXMSTRADDR,
                int MAXMSTRDATA=DEFAULT_MAXMSTRDATA,
                int NUM_TX_EXT_HEADERS=DEFAULT_NUM_TX_EXT_HEADERS,
                int NUM_RX_EXT_HEADERS=DEFAULT_NUM_RX_EXT_HEADERS) extends base_test;
        `else
class test18 extends base_test;
`endif


  //fbrc VC xactions
  tlm_analysis_fifo #(iosfsbm_cm::xaction)  rcvd_msgs;//For received messages
  //Locals

  iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr, iosf_epvc_seqr;
  
  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern function void connect();
  extern task run();
`ifdef IOSF_SB_PH2
  `ovm_component_utils(iosftest_pkg::test18)
`endif
endclass 

// FUNCTION: new
//
// DESCR:
//  test18_1 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test18_1



`ifndef IOSF_SB_PH2
function test18_1::new(string name, ovm_component parent);
`else
function test18::new(string name, ovm_component parent);
`endif    
  // Parent caller
  super.new(name, parent);
endfunction :new

`ifndef IOSF_SB_PH2
function void test18_1::build();
`else
function void test18::build();
`endif

  super.build();
  rcvd_msgs = new("rcvd_msgs", this);
  fabric_cfg_i.independent_reset=1;
  fabric_cfg_i.auto_pm_rsp = 1'b1;

      
endfunction
`ifndef IOSF_SB_PH2
function void test18_1::connect();
`else
function void test18::connect();
`endif    
   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction
`ifndef IOSF_SB_PH2
task test18_1::run();
`else
task test18::run();
`endif    
  
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
  bit disable_clkgating;
  bit claim_off;
  
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

  disable_clkgating = $random;
   
  if (disable_clkgating)   
    env_i.iosf_sbc_fabric_vc_i.disable_clkgating(1);

   //Randomly set not to claim all messages
   claim_off = $random;
   if (claim_off)
     begin
        ovm_report_info("BASE TEST", "VC is set not to claim all message"); 
        env_i.iosf_sbc_ip_vc_i.vc_set_to_claim_all_msg(0);
     end
   
   ep_vintf.assert_reset = 1'b0; 
   ep_vintf.control_ep_reset = 1'b0;  
  #1us;
   ep_vintf.assert_reset = 1'b1;
   ep_vintf.control_ep_reset = 1'b1;  

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
 if (!IS_RATA_ENV) begin
  simple_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
  
  #1ns;
  if ( env_i.iosf_sbc_ip_vc_i.agent_cfg_i.iosfsb_spec_rev < IOSF_083)
    begin 
       simple_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                            env_i.iosf_sbc_ip_vc_i.common_cfg_i);
       simple_seq_2.set_fields( 
                                iosfsbm_cm::NON_POSTED, //Xaction_class
                                8'haa, //Source
                                8'h22, //Dest
                                iosfsbm_cm::OP_DEASSERT_INTA, //Opcode
                                5'b00000, //Reserved
                                3'b000, //tag
                                .local_src_pid_i(8'haa),
                                .local_dest_pid_i(8'h22)
                                );
       
 if (!IS_RATA_ENV) begin
       simple_seq_2.start(iosf_ipvc_seqr);
 end //!RATA
    end 
  else
    begin
       simple_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                            env_i.iosf_sbc_ip_vc_i.common_cfg_i);
       simple_seq_2.set_fields( 
                                iosfsbm_cm::POSTED, //Xaction_class
                                8'haa, //Source
                                8'h22, //Dest
                                iosfsbm_cm::OP_DEASSERT_INTA, //Opcode
                                5'b00000, //Reserved
                                3'b000, //tag
                                .local_src_pid_i(8'haa),
                                .local_dest_pid_i(8'h22)
                                );
       
 if (!IS_RATA_ENV) begin
       simple_seq_2.start(iosf_ipvc_seqr);
 end //!RATA
    end       
      
  #1ns;    

  regio_wr_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h0, //sbe
                          4'h0, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

      
  #10us;
  ep_vintf.assert_reset = 1'b0;

  #2us;
  ep_vintf.assert_reset = 1'b1;

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA
 
   #1ns;    
  
    
  #1ns;
  regio_wr_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);  
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==47)
  begin    
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CRWR, //Opcode
                          2'b01, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h00, 8'h10, 8'h20,8'h10, 8'h20}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==47)
  else
  begin  
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CRWR, //Opcode
                          2'b00, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h00}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
  end 
 if (!IS_RATA_ENV) begin
  regio_wr_seq_2.start(iosf_ipvc_seqr); 
 end //!RATA
 
  #4us;
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==31)
  begin  
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CRWR, //Opcode
                          2'b00, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'h0, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h20}, //address   
                          '{8'h02, 8'h00, 8'h01, 8'h20}, //1dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
  end  
  else//64 bit data
  begin
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CRWR, //Opcode
                          2'b00, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h20}, //address   
                          '{8'h02, 8'hff, 8'h01, 8'h20, 8'h0, 8'h0, 8'h10,
                          8'h20}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
  end  
 
 if (!IS_RATA_ENV) begin
  regio_wr_seq_2.start(iosf_ipvc_seqr);  
 end //!RATA
    
  #1ns;      
  regio_rd_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                         .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

   #1ns;      
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

   #1ns;    
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==63)
  begin   
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h00}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
  end
   #1ns;      
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==47)
  begin  
    regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_CRRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==47)
  else //16bit address
  begin
    regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_CRRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );
  end   
 if (!IS_RATA_ENV) begin
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

  #4us;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                         .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

  #50us;
  ep_vintf.assert_reset = 1'b0;
  ep_vintf.control_ep_reset = 1'b0;  

  #2us;
  ep_vintf.assert_reset = 1'b1;
  ep_vintf.control_ep_reset = 1'b1;  

  #1ns; 
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==63)
  begin      
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
  end
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
      
  //Send xactions from Fabric_tlm
  #1ns;
  #5us; 
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

  #1ns;
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CRRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h30, 8'h40}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

  #1us;               
  msgd_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  msgd_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'h22, //Source
                        8'hbb, //Dest
                        iosfsbm_cm::OP_PM_REQ, //Opcode
                        3'b000, //tag
                        '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                        );
     
 if (!IS_RATA_ENV) begin
  msgd_seq_1.start(iosf_fbrcvc_seqr);
 end //!RATA
 
 #1ns;      
  simple_seq_3.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  simple_seq_3.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                          8'h33, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b000, //tag
                          .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'hbb)
                          );
      
 if (!IS_RATA_ENV) begin
  simple_seq_3.start(iosf_fbrcvc_seqr);
 end //!RATA

  #1ns;  
  // Run regio sequence from Fabric_TLM - Write
  regio_wr_seq_3.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  regio_wr_seq_3.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b000, //tag=0 for posted
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h20, 8'h30}, //address   
                         '{8'h0,8'h0,8'h0,8'h0}, //1dw data    
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'haa)
                         );    
 

  regio_wr_seq_3.start(iosf_fbrcvc_seqr);
      
   #1ns; 
  // Run regio sequence from Fabric_TLM - Write
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==47)
  begin  
    regio_wr_seq_3.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CRWR, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b000, //tag=0 for posted
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h20, 8'h30,8'h20, 8'h30,8'h20, 8'h30}, //address   
                         '{8'h0,8'h0,8'h0,8'h0}, //1dw data    
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );    
 
  end 
  else//16bit address
  begin
    regio_wr_seq_3.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CRWR, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b000, //tag=0 for posted
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h20, 8'h30}, //address   
                         '{8'h0,8'h0,8'h0,8'h0}, //1dw data    
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );
  end   
  regio_wr_seq_3.start(iosf_fbrcvc_seqr); 

   #1ns; 
  // Run regio sequence from Fabric_TLM - Write
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==31)
  begin  
    regio_wr_seq_3.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CRWR, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b000, //tag=0 for posted
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h20, 8'h30,8'h20, 8'h30,8'h20, 8'h30}, //address   
                         '{8'h0,8'h0,8'h0,8'h0}, //1dw data    
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );    
 
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==47)
  else //64 bit write_data
  begin
    regio_wr_seq_3.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CRWR, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b000, //tag=0 for posted
                         4'h1, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h20, 8'h30}, //address   
                         '{8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0,8'h0 }, //1dw data    
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );
  end   
  regio_wr_seq_3.start(iosf_fbrcvc_seqr);
      
   #1ns; 
  simple_seq_4.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);     
  simple_seq_4.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                          8'h22, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_DEASSERT_INTA, //Opcode
                          3'b110, //tag
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                          );
      
 if (!IS_RATA_ENV) begin
  simple_seq_4.start(iosf_fbrcvc_seqr);
 end //!RATA
    
      
  #30us;
      
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("TEST18_1 ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run
`ifndef IOSF_SB_PH2
class test18 extends test18_1#(.PAYLOAD_WIDTH(MAXPLDBIT+1),
                               .AGENT_MASTERING_SB_IF(0),
                               .MAXPCMSTR(MAXPCMSTR), 
                               .MAXNPMSTR(MAXNPMSTR), 
                               .MAXPCTRGT(MAXPCTRGT), 
                               .MAXNPTRGT(MAXNPTRGT),
                               .MAXPLDBIT(MAXPLDBIT),
                               .MAXTRGTADDR(MAXTRGTADDR),
                               .MAXTRGTDATA(MAXTRGTDATA),
                               .MAXMSTRADDR(MAXMSTRADDR),
                               .MAXMSTRDATA(MAXMSTRDATA),
                               .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS),
                               .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS));          
  function new(string name, ovm_component parent);
    super.new(name, parent);
  endfunction 
  `ovm_component_utils(iosftest_pkg::test18)
      
endclass :test18
`endif //IOSF_SB_PH2
`endif //TEST18_1

