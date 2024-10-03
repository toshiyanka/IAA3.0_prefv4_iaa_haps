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
`ifndef TEST08_1
`define TEST08_1 

// TO RUN TEST08_1: make iptest TEST=test08_1 INT=0 +define+async_reset

// class: test08_1 
// Tests to check inband reset
`ifndef IOSF_SB_PH2  
class test08_1#(int PAYLOAD_WIDTH=MAXPLDBIT+1, 
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
class test08 extends base_test;
`endif//IOSF_SB_PH2

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
  `ovm_component_utils(iosftest_pkg::test08)
  `endif

endclass 

// FUNCTION: new
//
// DESCR:
//  test08_1 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test08_1
//
`ifndef IOSF_SB_PH2
function test08_1::new(string name, ovm_component parent);
`else
function test08::new(string name, ovm_component parent);
`endif

  // Parent caller
  super.new(name, parent);
endfunction :new
`ifndef IOSF_SB_PH2
function void test08_1::build();
`else
function void test08::build();
`endif

  super.build();
  rcvd_msgs = new("rcvd_msgs", this);

endfunction

`ifndef IOSF_SB_PH2
function void test08_1::connect();
`else
function void test08::connect();
`endif

   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction
`ifndef IOSF_SB_PH2
task test08_1::run();
`else
task test08::run();
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


/*   regio_rd_seq_2.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
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
                         '{8'h30, 8'h40} //address   
                         );

  regio_rd_seq_2.start(iosf_fbrcvc_seqr);
   */  
  //Send xactions from Fabric_tlm
  #1070000;
      //fabric_vintf.side_ism_agent = 2;
  simple_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_1.set_fields( 
                           iosfsbm_cm::POSTED, //Xaction_class
                           8'haa, //Source
                           8'h11, //Dest
                           iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                           3'b000, //tag
                           .xaction_delay_i(10),
                           .local_src_pid_i(8'haa),
                           .local_dest_pid_i(8'h11)
                          );
 
 if (!IS_RATA_ENV) begin
  simple_seq_1.start(iosf_ipvc_seqr);
 end     //!RATA 
      env_i.iosf_sbc_fabric_vc_i.set_creditack_delay(10);
      
      
  //#110001;
      //wait ( fabric_vintf.rsp_cb.side_ism_agent == 2);
      
      //fabric_vintf.drv_cb.side_ism_fabric <= 4;
      
    //env_i.iosf_sbc_fabric_vc_i.do_crd_reinit(1);
    //  ovm_report_info("ddD", "waiting for idel");
      
      //wait(fabric_vintf.side_ism_fabric == 0);      
      //fabric_vintf.side_ism_fabric = 4;
      
      #1us;
      
/*  regio_rd_seq_2.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
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
                         '{8'h30, 8'h40} //address   
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
                         '{8'h30, 8'h40} //address   
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
                        '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0} //64 bit data
                        );
     
  msgd_seq_1.start(iosf_fbrcvc_seqr);
 
 #1ns;      
  simple_seq_3.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
              env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  simple_seq_3.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                          8'h33, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b000 //tag
                          );
      
  simple_seq_3.start(iosf_fbrcvc_seqr);

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
                         '{8'h0,8'h0,8'h0,8'h0} //1dw data    
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
                         '{8'h0,8'h0,8'h0,8'h0} //1dw data    
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
                         '{8'h0,8'h0,8'h0,8'h0} //1dw data    
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
                          3'b110 //tag
                          );
      
  simple_seq_4.start(iosf_fbrcvc_seqr);
    
   #2ns;
      
 // Send xactions from ep_TLM
  simple_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                env_i.iosf_sbc_ip_vc_i.common_cfg_i);
  simple_seq_1.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'haa, //Source
                          8'h11, //Dest
                          iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                          3'b000 //tag
                          );
 
  //simple_seq_1.start(iosf_ipvc_seqr);
  

      
    */  
  #30us;
      
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("TEST08_1 ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run
`ifndef IOSF_SB_PH2
class test08 extends test08_1#(.PAYLOAD_WIDTH(MAXPLDBIT+1),
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
  `ovm_component_utils(iosftest_pkg::test08)
      
endclass :test08
`endif //IOSF_SB_PH2

`endif //TEST08_1

