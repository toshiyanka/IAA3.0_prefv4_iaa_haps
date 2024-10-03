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
`ifndef TEST15_1
`define TEST15_1 

// TO RUN TEST15_1: make iptest TEST=test15_1 INT=0 +define+async_reset

// class: test15_1 
// Tests to check inband reset 
`ifndef IOSF_SB_PH2
class test15_1#(int PAYLOAD_WIDTH=MAXPLDBIT+1, 
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
 class test15 extends base_test;
 `endif//IOSF_SB_PH2 

  //fbrc VC xactions
  tlm_analysis_fifo #(iosfsbm_cm::xaction)  rcvd_msgs;//For received messages
  //Locals
local event reset_event;

  iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr, iosf_epvc_seqr;
  
  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern function void connect();
  extern task run();
  extern task gen_reset_event();
`ifdef IOSF_SB_PH2
  `ovm_component_utils(iosftest_pkg::test15)
  `endif


endclass 

// FUNCTION: new
//
// DESCR:
//  test15_1 class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type test15_1
`ifndef IOSF_SB_PH2
function test15_1::new(string name, ovm_component parent);
`else
function test15::new(string name, ovm_component parent);
`endif    
  // Parent caller
  super.new(name, parent);
endfunction :new
`ifndef IOSF_SB_PH2
function void test15_1::build();
`else
function void test15::build();
`endif    

  super.build();
  agent_cfg_i.disable_idle = 1;
  rcvd_msgs = new("rcvd_msgs", this);

endfunction
`ifndef IOSF_SB_PH2
function void test15_1::connect();
`else
function void test15::connect();
`endif    
   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
endfunction
`ifndef IOSF_SB_PH2
task test15_1::run();
`else
task test15::run();
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
  env_i.iosf_sbc_fabric_vc_i.set_activereq_delay(25);
      
   ep_vintf.assert_reset = 1'b0; 
   ep_vintf.control_ep_reset = 1'b0;  
  #1us;
   ep_vintf.assert_reset = 1'b1;
   ep_vintf.control_ep_reset = 1'b1;  

   fork
      if (!SKIP_ACTIVEREQ) gen_reset_event();
     join_none
        
  //Send xactions
  //wait(fabric_vintf.rsp_cb.side_ism_agent == 0);       
  #1070000;
            
      //fabric_vintf.side_ism_agent = 2;
  simple_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                       env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  simple_seq_1.set_fields( 
                           iosfsbm_cm::POSTED, //Xaction_class
                           8'h11, //Source
                           8'haa, //Dest
                           iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                           3'b000,
                           .local_src_pid_i(8'h11),
                           .local_dest_pid_i(8'haa)
                          );

  if (!IS_RATA_ENV) begin
  simple_seq_1.start(iosf_fbrcvc_seqr);
  end //!RATA      
      
      if (AGT_CLK_PERIOD > FAB_CLK_PERIOD)
        #(AGT_CLK_PERIOD*10);
      else
        #(FAB_CLK_PERIOD*10);
    
 regio_wr_seq_2.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                         env_i.iosf_sbc_ip_vc_i.common_cfg_i);
      
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15)
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
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15)
  else 
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
                          .local_src_pid_i(8'hbb),
                          .local_dest_pid_i(8'h22)
                          );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==31)
if (!IS_RATA_ENV) begin
  regio_wr_seq_2.start(iosf_ipvc_seqr);
end //!RATA
      
      #1us;
      regio_wr_seq_2.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                             env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==15)
  begin
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'h22, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CRWR, //Opcode
                          2'b00, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h00}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'h22),
                          .local_dest_pid_i(8'hbb)
                          );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15)
  else 
  begin    
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::POSTED, //Xaction_class
                          8'h22, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_CRWR, //Opcode
                          2'b01, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h00, 8'h10, 8'h20,8'h10, 8'h20}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'h22),
                          .local_dest_pid_i(8'hbb)
                          );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==31)

      regio_wr_seq_2.start(iosf_fbrcvc_seqr);        
      #1us;


  if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==15)
  begin
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b00, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h00}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'hbb)
                          );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==15)
  else 
  begin    
    regio_wr_seq_2.set_fields( 
                          iosfsbm_cm::NON_POSTED, //Xaction_class
                          8'h11, //Source
                          8'hbb, //Dest
                          iosfsbm_cm::OP_MWR, //Opcode
                          2'b01, //addrlen                         
                          3'b001, //bar 
                          3'b000, //tag=0 for posted
                          4'h0, //sbe
                          4'h1, //fbe
                          8'h00, //fid
                          '{8'h30, 8'h00, 8'h10, 8'h20,8'h10, 8'h00}, //address   
                          '{8'h0,8'h1,8'h1,8'h0}, //1dw data 
                          .local_src_pid_i(8'h11),
                          .local_dest_pid_i(8'hbb)
                          );
  end // if (env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxmstraddr==31)
                 
  regio_wr_seq_2.start(iosf_fbrcvc_seqr);        

      #50us;
      
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("TEST15_1 ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run
`ifndef IOSF_SB_PH2
  task test15_1::gen_reset_event();
  `else
  task test15::gen_reset_event();
  `endif//PH2          
      int cnt=0;
      wait(ep_vintf.assert_reset == 1);
      
  if (!IS_RATA_ENV) begin
      wait(fabric_vintf.rsp_cb.side_ism_agent == 0);
      wait(fabric_vintf.rsp_cb.side_ism_agent == 2);
  end //!RATA      
        
      //fabric_vintf.side_ism_agent <= 4;
      

      ovm_report_info("ddd", "event triggered",0);
      
      ep_vintf.assert_reset = 1'b0;
      #100ns;
      
      ep_vintf.assert_reset = 1'b1;
      
  endtask // gen_reset_event
      
`ifndef IOSF_SB_PH2         
class test15 extends test15_1#(.PAYLOAD_WIDTH(MAXPLDBIT+1),
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
  `ovm_component_utils(iosftest_pkg::test15)
      
endclass :test15
`endif//IOSF_SB_PH2
`endif //TEST15_1

