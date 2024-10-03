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
`ifndef TEST13
`define TEST13 

// class: test13 
// Tests basic test flow for the IOSF sideband interface fabric 
class test13 extends base_test;

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
  `ovm_component_utils(iosftest_pkg::test13)

endclass :test13

// FUNCTION: new
//
// DESCR:
//  test13 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test13
function test13::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new

function void test13::build();
  super.build();
  rcvd_msgs = new("rcvd_msgs", this);
      fabric_cfg_i.np_crd_buffer = 1;
      fabric_cfg_i.pc_crd_buffer = 20;
      
endfunction

function void test13::connect();
   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction

task test13::run();
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
       
  simple_seq_1 = simple_seq::type_id::create("SIMPLE_SEQ_1",this);
  simple_seq_2 = simple_seq::type_id::create("SIMPLE_SEQ_2",this);
  simple_seq_3 = simple_seq::type_id::create("SIMPLE_SEQ_3",this);
  simple_seq_4 = simple_seq::type_id::create("SIMPLE_SEQ_4",this);
  simple_seq_5 = simple_seq::type_id::create("SIMPLE_SEQ_5",this);
  simple_seq_6 = simple_seq::type_id::create("SIMPLE_SEQ_6",this);
  msgd_seq_i = msgd_seq::type_id::create("MSGD_SEQ",this);   
  msgd_seq_1 = msgd_seq::type_id::create("MSGD_SEQ_1",this);    
  msgd_seq_2 = msgd_seq::type_id::create("MSGD_SEQ_2",this);
  msgd_seq_3 = msgd_seq::type_id::create("MSGD_SEQ_3",this);
  regio_rd_seq_1 =regio_seq::type_id::create("REGIO_RD_SEQ_1",this);
  regio_rd_seq_2 =regio_seq::type_id::create("REGIO_RD_SEQ_2",this);      
  regio_wr_seq_1 =regio_seq::type_id::create("REGIO_WR_SEQ_1",this);  
  regio_wr_seq_4 =regio_seq::type_id::create("REGIO_wr_SEQ_4",this);      
  regio_wr_seq_3 =regio_seq::type_id::create("REGIO_WR_SEQ_3",this);   
  regio_wr_seq_2 =regio_seq::type_id::create("REGIO_WR_SEQ_2",this);
      
  //Get sequencer Reference      
  iosf_ipvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();           
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
  env_i.iosf_sbc_fabric_vc_i.disable_clkgating(1);
  env_i.iosf_sbc_fabric_vc_i.set_crd_update_delay(3);     
   

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
  
  //#1ns;
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
                                8'hbb, //Source
                                8'h22, //Dest
                                iosfsbm_cm::OP_DEASSERT_INTA, //Opcode
                                5'b00000, //Reserved
                                3'b000, //tag
                                .local_src_pid_i(8'hbb),
                                .local_dest_pid_i(8'h22)
                                );
       
 if (!IS_RATA_ENV) begin 
       simple_seq_2.start(iosf_ipvc_seqr);
 end //!RATA
    end       
      
  //#4ns;    

  regio_wr_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h0, //sbe
                          4'h0, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==63)
    begin
    
        regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h4, //sbe
                          4'h2, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA
    
   //#1ns;
 
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h6, //sbe
                          4'h4, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    
 
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'h7, //sbe
                          4'h6, //fbe
                          8'h41, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    
 
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'h8, //sbe
                          4'h7, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

      
   //#1ns;    

        regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h9, //sbe
                          4'h9, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;
 
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'ha, //sbe
                          4'ha, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    
 
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'hb, //sbe
                          4'hb, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'hc, //sbe
                          4'hc, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'hd, //sbe
                          4'hd, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'he, //sbe
                          4'he, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    
    
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'hf, //sbe
                          4'h1, //fbe
                          8'hc2, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

         //#1ns;    

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'h0, //sbe
                          4'h1, //fbe
                          8'hff, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

   //#1ns;    

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h1, //sbe
                          4'h0, //fbe
                          8'hc4, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA
end
        //#1ns;    

  regio_wr_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h0, //sbe
                          4'h0, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;    
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==63)
    begin    
        regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h2, //sbe
                          4'h4, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;

        regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'h3, //sbe
                          4'h7, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'h4, //sbe
                          4'ha, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;  

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h6, //sbe
                          4'hc, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;  
 
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'h7, //sbe
                          4'hf, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);      
 end //!RATA

   //#1ns;  
     
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b011, //bar 
                          3'b010, //tag
                          4'h8, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

   //#1ns;    

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h1, //sbe
                          4'h0, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

        //#1ns;    

  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IORD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h9, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
      end
   //#1ns;    
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==63)
    begin
    
    regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
       
       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b010, //bar 
                          3'b110, //tag
                          4'h2, //sbe
                          4'h1, //fbe
                          8'h83, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
       
       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b011, //bar 
                          3'b100, //tag
                          4'h3, //sbe
                          4'h1, //fbe
                          8'h84, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
       
       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h4, //sbe
                          4'h1, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
       
       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b001, //bar 
                          3'b111, //tag
                          4'h5, //sbe
                          4'h1, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
//#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b010, //bar 
                          3'b001, //tag
                          4'h6, //sbe
                          4'h1, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

              //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b100, //bar 
                          3'b010, //tag
                          4'ha, //sbe
                          4'h1, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

              //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b100, //bar 
                          3'b011, //tag
                          4'hb, //sbe
                          4'h1, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

              //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b101, //bar 
                          3'b100, //tag
                          4'hc, //sbe
                          4'h1, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
 
       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'hd, //sbe
                          4'h1, //fbe
                          8'hc2, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b010, //bar 
                          3'b110, //tag
                          4'he, //sbe
                          4'h1, //fbe
                          8'hc2, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b100, //bar 
                          3'b111, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'hc2, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b101, //bar 
                          3'b001, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'hc2, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
        //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b011, //bar 
                          3'b010, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
        //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b010, //bar 
                          3'b011, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b011, //bar 
                          3'b101, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
     
       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b011, //bar 
                          3'b101, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'hc2, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b100, //bar 
                          3'b110, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'hc2, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b100, //bar 
                          3'b111, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

       //#1ns;

           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b101, //bar 
                          3'b001, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
 
           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b101, //bar 
                          3'b010, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h90, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
    
 
           regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b100, //bar 
                          3'b011, //tag
                          4'h1, //sbe
                          4'h1, //fbe
                          8'h90, //fid
                          '{8'h10, 8'h00,8'h10, 8'h00,8'h10, 8'h00}, //address   
                          '{8'h0,8'h4,8'h0,8'h0,8'h0,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 if (!IS_RATA_ENV) begin 
         regio_wr_seq_1.start(iosf_ipvc_seqr);
    
 end //!RATA
  
  end // UNMATCHED !!
  else
  begin 
    
    regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h10, 8'h00}, //address   
                          '{8'h3,8'h1,8'h1,8'h0}, //2dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 if (!IS_RATA_ENV) begin 
       regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

  end 
  
  #4ns;
  regio_wr_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15)
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
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h00}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15)
  else
  begin    
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
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
                          .local_dest_pid_i(8'h11)
                          );
  end
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_2.start(iosf_ipvc_seqr);
 end //!RATA
    

  //#1ns;
  regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
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
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_2.start(iosf_ipvc_seqr);  
 end //!RATA

  //#1ns;
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==31)
  begin  
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CRWR, //Opcode
                          2'b00, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'he, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h20}, //address   
                          '{8'h02, 8'h00, 8'h01, 8'h20}, //1dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
  end  
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
                          4'he, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h20}, //address   
                          '{8'h02, 8'hff, 8'h01, 8'h20, 8'h0, 8'h0, 8'h10, 8'h20}, //2dw data 
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
  end  
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_2.start(iosf_ipvc_seqr); 
 end //!RATA
    
  //#1ns;      
  regio_rd_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

      //#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==63)
        begin
    
        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b010, //tag
                         4'h2, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

      //#1ns;


        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b011, //tag
                         4'h9, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

      //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b100, //tag
                         4'ha, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

      //#1ns;
     
        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'hc, //sbe
                         4'h3, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA


        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b110, //tag
                         4'hf, //sbe
                         4'hb, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

      
   //#4ns;      
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b111, //tag
                         4'ha, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
   
   //#1ns;      

        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b001, //tag
                         4'hb, //sbe
                         4'h1, //fbe
                         8'h82, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
   
   //#1ns;

        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b010, //tag
                         4'hc, //sbe
                         4'h1, //fbe
                         8'h82, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA

   
   //#1ns;
   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b011, //tag
                         4'hd, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
   
   //#1ns; 
     
        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'he, //sbe
                         4'h1, //fbe
                         8'hc4, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
    end   
   //#1ns;

        regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'hc4, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA

  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b110, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'hc4, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
   
   //#1ns;  

  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b111, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h82, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                         );


 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
  //#1ns;  

  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h83, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
  //#1ns;  

  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h41, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
   
   //#1ns;  

  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h42, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
   
   //#1ns;  

  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h45, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);       
 end //!RATA
     
   //#1ns;

      
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==47)
  begin   
    regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_CRRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                         );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==47)
  else
  begin  
    regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_CRRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b110, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                              );
     
  end                            
 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

       //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b111, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

             //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA


             //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

             //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h83, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

       //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

        //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

             //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b110, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h06, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

             //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h06, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
      
       //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
       //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
     
      
  //#1ns;       
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
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

  //#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==63)
        begin
    
  regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
        end 
  //#1ns;   
  msgd_seq_i.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  msgd_seq_i.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'hbb, //Source
                        8'h22, //Dest
                        iosfsbm_cm::OP_PM_DMD, //Opcode
                        3'b001, //tag
                        '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                        );
     
 if (!IS_RATA_ENV) begin 
  msgd_seq_i.start(iosf_ipvc_seqr);
 end //!RATA

  //#1ns;   
  msgd_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  msgd_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'h22, //Source
                        8'hbb, //Dest
                        iosfsbm_cm::OP_PM_DMD, //Opcode
                        3'b001, //tag
                        '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'h22),
                          .local_dest_pid_i(8'hbb)
                        );
     
 if (!IS_RATA_ENV) begin 
  msgd_seq_1.start(iosf_fbrcvc_seqr);
 end //!RATA
 

  //#1ns;   
  msgd_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  msgd_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'h11, //Source
                        8'hbb, //Dest
                        iosfsbm_cm::OP_PM_DMD, //Opcode
                        3'b001, //tag
                        '{8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'h11),
                        .local_dest_pid_i(8'hbb)
                        );
     
 if (!IS_RATA_ENV) begin 
  msgd_seq_1.start(iosf_fbrcvc_seqr);
 end //!RATA
      
 //#1ns;   
  msgd_seq_i.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
              env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  msgd_seq_i.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                        8'hbb, //Source
                        8'h11, //Dest
                        iosfsbm_cm::OP_PM_DMD, //Opcode
                        3'b001, //tag
                        '{8'h0, 8'h8, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                        .local_src_pid_i(8'hbb),
                        .local_dest_pid_i(8'h11)
                        );
     
 if (!IS_RATA_ENV) begin 
  msgd_seq_i.start(iosf_ipvc_seqr);
 end //!RATA
 //#1ns;

         //#4ns;  
       regio_rd_seq_2.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);    
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
      //#1ns;

      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
        begin  
       regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc1, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
        end
      //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

           //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc1, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

     //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc1, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
 
     //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b110, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc1, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
 
     //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b111, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
 
     //#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
        begin      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b001, //tag
                         4'hf, //sbe
                         4'h0, //fbe
                         8'h41, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
        end

     //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h41, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

    //#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
        begin       
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b011, //tag
                         4'h6, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

    //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b100, //tag
                         4'he, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
 
    //#1ns;
 
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'hd, //sbe
                         4'h0, //fbe
                         8'h01, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
        end
      //#1ns;

      
        regio_wr_seq_4.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h0, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);     
  //#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
        begin  
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'h2, //sbe
                          4'h1, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);    
 //#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h1, //sbe
                          4'h0, //fbe
                          8'hc1, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h33),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);    
 
//#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h3, //sbe
                          4'h1, //fbe
                          8'h05, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h33),
                          .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);  

//#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h4, //sbe
                          4'h1, //fbe
                          8'h80, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr); 
        end
      //#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h80, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
        begin        
           //#1ns;
           if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr == 48)
             begin
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04},
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa));

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
             
      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04},
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb));

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04},
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b011, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04},
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'hbb));

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04},
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'haa));

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);     

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04},
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'hbb));

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h02, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
             end
        end
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h1, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
        begin
           if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr == 48)
             begin
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
             end
  
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h41, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h41, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'hc3, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'haa)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
//#1ns;
           if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr == 48)
             begin
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b011, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h02, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h02, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h02, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
             end
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
   
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b001, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b010, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
       
    
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b100, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
       
      //#1ns;

  
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'h5, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);     
  //#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h6, //sbe
                          4'h1, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);    
 //#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h7, //sbe
                          4'h0, //fbe
                          8'hc1, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);    
 
//#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h8, //sbe
                          4'h1, //fbe
                          8'h05, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);  

//#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'h9, //sbe
                          4'h1, //fbe
                          8'h80, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr); 
  
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h0, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);



      //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'hb, //sbe
                          4'h2, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);     
  //#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'hc, //sbe
                          4'h3, //fbe
                          8'h01, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);    
 //#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'hd, //sbe
                          4'h4, //fbe
                          8'hc1, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);    
 
//#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'he, //sbe
                          4'h5, //fbe
                          8'h05, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);  

//#1ns;
   regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGRD, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h1, //sbe
                          4'h6, //fbe
                          8'h80, //fid
                          '{8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr); 
  
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h7, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'h9, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'ha, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
  
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'hb, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'hc, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'hd, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr); 

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'h4, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);


      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'he, //sbe
                         4'h5, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b110, //tag
                         4'hd, //sbe
                         4'h8, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      
      //#1ns;

  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b111, //tag
                         4'hc, //sbe
                         4'h4, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

            //#1ns;

  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b001, //tag
                         4'h3, //sbe
                         4'h6, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

            //#1ns;

  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b010, //tag
                         4'h5, //sbe
                         4'h7, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
 
      //#1ns;

  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b011, //tag
                         4'h7, //sbe
                         4'ha, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

      //#1ns;

  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b100, //tag
                         4'h9, //sbe
                         4'hd, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

           //#1ns;

  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b101, //tag
                         4'ha, //sbe
                         4'hf, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

      
      //#1ns;

  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IORD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b110, //tag
                         4'hb, //sbe
                         4'he, //fbe
                         8'h00, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);     
      //#1ns;


  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'h7, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'h9, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'ha, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
  
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'hb, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'hc, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'hd, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr); 

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_CFGRD, //opcode
                         2'b00, //addrlen                         
                         3'b000, //bar 
                         3'b111, //tag
                         4'hf, //sbe
                         4'hf, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
           if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr == 48)
             begin
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
             
      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b010, //tag
                         4'h3, //sbe
                         4'hf, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b011, //tag
                         4'h5, //sbe
                         4'hf, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b100, //tag
                         4'h7, //sbe
                         4'hf, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b101, //tag
                         4'h9, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b011, //bar 
                         3'b110, //tag
                         4'hc, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b111, //tag
                         4'he, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b001, //tag
                         4'hf, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04} ,
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h00, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h02, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h02, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

   
      
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b111, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b001, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h82, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b010, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
      
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b011, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b100, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04} ,
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
      regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b101, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h42, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MWR, //opcode
                         2'b01, //addrlen                         
                         3'b011, //bar 
                         3'b110, //tag
                         4'h1, //sbe
                         4'hf, //fbe
                         8'h04, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address
                           '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, 
                           .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
regio_wr_seq_4.start(iosf_fbrcvc_seqr);
      
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b111, //tag
                         4'hc, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
    
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b001, //tag
                         4'hb, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
regio_wr_seq_4.start(iosf_fbrcvc_seqr);
 //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b011, //bar 
                         3'b010, //tag
                         4'ha, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
      regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b011, //tag
                         4'h8, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
      regio_wr_seq_4.start(iosf_fbrcvc_seqr);
//#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b100, //tag
                         4'h5, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
      regio_wr_seq_4.start(iosf_fbrcvc_seqr);

      //#1ns;
  regio_wr_seq_4.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b101, //tag
                         4'h2, //sbe
                         4'h0, //fbe
                         8'hc2, //fid
                         '{8'h40, 8'h04,8'h40, 8'h04,8'h40, 8'h04}, //address   
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );
      regio_wr_seq_4.start(iosf_fbrcvc_seqr);
             end
        end
     //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b110, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

     //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b111, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

     //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

     //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b00, //addrlen                         
                         3'b011, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

     //#1ns;
      if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr == 48)
        begin
   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

     //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

     //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h46, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);   
 end //!RATA

     //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b111, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h86, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

           //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h86, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA


           //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b011, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h86, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

           //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h06, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

           //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h06, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
      
           //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b011, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h06, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA

                //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b110, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h86, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
 
          //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b001, //bar 
                         3'b111, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);  
 end //!RATA

          //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b010, //bar 
                         3'b001, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);  
 end //!RATA

         //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b000, //bar 
                         3'b010, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

         //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'haa, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b011, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'haa),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

         //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b100, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'hc6, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);  
 end //!RATA
          //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hbb, //Source
                         8'h22, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b100, //bar 
                         3'b101, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h06, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hbb),
                         .local_dest_pid_i(8'h22)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);  
 end //!RATA

          //#1ns;

   regio_rd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'hcc, //Source
                         8'h11, //Dest            
                         iosfsbm_cm::OP_MRD, //opcode
                         2'b01, //addrlen                         
                         3'b101, //bar 
                         3'b110, //tag
                         4'h0, //sbe
                         4'h0, //fbe
                         8'h06, //fid
                         '{8'h10, 8'h20,8'h10, 8'h20,8'h10, 8'h20}, //address   
                         .local_src_pid_i(8'hcc),
                         .local_dest_pid_i(8'h11)
                         );

 if (!IS_RATA_ENV) begin 
  regio_rd_seq_1.start(iosf_ipvc_seqr);  
 end //!RATA

        end
    //#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
        begin    
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h11, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b001, //tag
                         4'h3, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h11),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

          //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b010, //tag
                         4'h5, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

          //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b011, //tag
                         4'h6, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h33),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

          //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b100, //tag
                         4'h7, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
 
    //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b101, //tag
                         4'h9, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

    //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h22, //Source
                         8'hcc, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b110, //tag
                         4'hb, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h22),
                         .local_dest_pid_i(8'hcc)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);

    //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'hbb, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b111, //tag
                         4'hd, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h33),
                          .local_dest_pid_i(8'hbb)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);     

    //#1ns;
      
  regio_rd_seq_2.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                         8'h33, //Source
                         8'haa, //Dest            
                         iosfsbm_cm::OP_IOWR, //opcode
                         2'b00, //addrlen                         
                         3'b101, //bar 
                         3'b001, //tag
                         4'hf, //sbe
                         4'h0, //fbe
                         8'h81, //fid
                         '{8'h10, 8'h20}, //address
                         '{8'h10, 8'h20,8'h10, 8'h20},
                         .local_src_pid_i(8'h33),
                          .local_dest_pid_i(8'haa)
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);   

      //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h3, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);  

           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h4, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00} ,
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);

           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'h6, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                          .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'h7, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h9, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h33),
                          .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'ha, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h33),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'hb, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'hc, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'hd, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h22, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'he, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h22),
                          .local_dest_pid_i(8'hbb)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr);
           //#1ns;
      
  regio_wr_seq_4.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h33, //Source
                          8'haa, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'hf, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'h33),
                          .local_dest_pid_i(8'haa)
                          );
 
  regio_wr_seq_4.start(iosf_fbrcvc_seqr); 
        end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtdata==64)
      
      //#1ns;
      if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstrdata==64)
        begin  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h6, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

      //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b101, //bar 
                          3'b111, //tag
                          4'h7, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

     //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b100, //bar 
                          3'b001, //tag
                          4'h8, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

     //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b001, //bar 
                          3'b010, //tag
                          4'h9, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA
     //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b010, //bar 
                          3'b011, //tag
                          4'ha, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

     //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'hd, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA
     //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'he, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_IOWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h2, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

      
     //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'h2, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h3, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'h2, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'h4, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'h5, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'h6, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'h7, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'h8, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b001, //tag
                          4'h9, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b010, //tag
                          4'ha, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

               //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b011, //tag
                          4'hb, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr);
 end //!RATA
      
          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b100, //tag
                          4'hc, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hbb, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b101, //tag
                          4'hd, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'hcc, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b110, //tag
                          4'he, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},   
                          .local_src_pid_i(8'hcc),
                          .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

          //#1ns;
  
  regio_wr_seq_1.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'haa, //Source
                          8'h22, //Dest
                          iosfsbm_cm::OP_CFGWR, //Opcode
                          2'b00, //addrlen                         
                          3'b000, //bar 
                          3'b111, //tag
                          4'hf, //sbe
                          4'h0, //fbe
                          8'h42, //fid
                          '{8'h10, 8'h00},
                          '{8'h10, 8'h00,8'h10, 8'h00},
                          .local_src_pid_i(8'haa),
                          .local_dest_pid_i(8'h22)
                          );
 
 if (!IS_RATA_ENV) begin 
  regio_wr_seq_1.start(iosf_ipvc_seqr); 
 end //!RATA

        end
   #20us;
     
      
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("TEST13 ", "Stopping Test");
  
  #150us;

  // Stop simulation
  global_stop_request();
endtask :run

`endif //TEST13

