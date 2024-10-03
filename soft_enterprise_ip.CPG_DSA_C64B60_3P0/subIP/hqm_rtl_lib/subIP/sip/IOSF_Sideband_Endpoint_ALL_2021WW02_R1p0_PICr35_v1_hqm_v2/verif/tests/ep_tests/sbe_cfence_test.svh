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
`ifndef SBE_CFENCE_TEST
`define SBE_CFENCE_TEST 

// class: sbe_cfence_test 
// Tests basic test flow for the IOSF sideband interface fabric 
class sbe_cfence_test extends base_test;

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
  extern task send_target_np();
  extern task send_master_p();
  `ovm_component_utils(iosftest_pkg::sbe_cfence_test)

endclass :sbe_cfence_test

// FUNCTION: new
//
// DESCR:
//  sbe_cfence_test class constructor
//
// ARGUMENTS:
//  name - input string - OVM name
//  parent - input ovm_component - OVM parent reference
//
// RETURN:
//  Constructed component of type sbe_cfence_test
function sbe_cfence_test::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
endfunction :new

function void sbe_cfence_test::build();
  super.build();
  rcvd_msgs = new("rcvd_msgs", this);
  fabric_cfg_i.auto_pm_rsp = 1'b1;
endfunction

function void sbe_cfence_test::connect();
   env_i.iosf_sbc_fabric_vc_i.rx_ap.connect(rcvd_msgs.analysis_export);
   env_i.iosf_sbc_ip_vc_i.vc_set_to_delay_np_cmpl(100);
endfunction

task sbe_cfence_test::send_target_np();
  // locals
  simple_seq simple_seq_1;
  msgd_seq msgd_seq_1;
  regio_seq regio_seq_1;
  bulk_regio_seq bulk_seq_1;
  string msg;
  iosfsbm_cm::iosfsbc_sequencer iosf_fbrcvc_seqr;
  bit s, m, r, b;
       
  simple_seq_1 = simple_seq::type_id::create("SIMPLE_SEQ_1",this);
  msgd_seq_1 = msgd_seq::type_id::create("MSGD_SEQ_1",this); 
  regio_seq_1 = regio_seq::type_id::create("REGIO_SEQ_1",this);
  bulk_seq_1 = bulk_regio_seq::type_id::create("BULK_SEQ_1",this);
  
  //Get sequencer Reference      
  iosf_fbrcvc_seqr = env_i.iosf_sbc_fabric_vc_i.get_sequencer();
   
  randcase
    1 : begin s = 1; m = 0; r = 0; b = 0; end
    1 : begin s = 0; m = 1; r = 0; b = 0; end
    1 : begin s = 0; m = 0; r = 1; b = 0; end
    1 : begin s = 0; m = 0; r = 0; b = 1; end
    1 : begin s = 1; m = 1; r = 1; b = 0; end
  endcase

  repeat(50)begin
     randcase
        s : begin
               ovm_report_info(get_name(), $psprintf("TEST: Sending Target NP - Simple Message"));
               simple_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                           env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
               simple_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                                       8'h11, //Source
                                       8'haa, //Dest
                                       iosfsbm_cm::SIMPLE_EPSPEC_OPCODE_START, //Opcode
                                       3'b001, //tag
                                       .local_src_pid_i(8'h11),
                                       .local_dest_pid_i(8'haa)
                                       );
                   
               if (!IS_RATA_ENV) begin
                  simple_seq_1.start(iosf_fbrcvc_seqr);
               end
            end
        m : begin
               ovm_report_info(get_name(), $psprintf("TEST: Sending Target NP - Msgd Message"));
               msgd_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                                  env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
               msgd_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                                     8'h11, //Source
                                     8'haa, //Dest
                                     iosfsbm_cm::OP_LOCALSYNC, //Opcode
                                     3'b001, //tag
                                     '{8'h0, 8'h9, 8'h0, 8'h9, 8'hf, 8'hf, 8'hf, 8'h0}, //64 bit data
                                     .local_src_pid_i(8'h11),
                                     .local_dest_pid_i(8'haa)
                                     );
               
               if (!IS_RATA_ENV) begin
                  msgd_seq_1.start(iosf_fbrcvc_seqr);
               end
            end
        r : begin
               ovm_report_info(get_name(), $psprintf("TEST: Sending Target NP - Regio Message"));
               regio_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                           env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
               regio_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
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
               if (!IS_RATA_ENV) begin
                  regio_seq_1.start(iosf_fbrcvc_seqr);
               end
            end
        b : begin
               ovm_report_info(get_name(), $psprintf("TEST: Sending Target NP - Bulk Regio Message"));
               bulk_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                           env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
               bulk_seq_1.set_fields(iosfsbm_cm::NON_POSTED, //Xaction_class
                                      8'h11, //Source
                                      8'haa, //Dest            
                                      iosfsbm_cm::BULK_RD, //opcode
                                      2'b00, //addrlen                         
                                      3'b000, //bar 
                                      3'b001, //tag
                                      .num_chunk(1),
                                      .fid_i('{8'h00}),
                                      .space_i('{2'b00}),
                                      .data_length_i('{1}),
                                      .addr_i('{'{8'h30, 8'h40}}),
                                      //.num_chunk(3),
                                      //.fid_i('{8'h00, 8'h00, 8'h00}),
                                      //.space_i('{2'b00, 2'b00, 2'b00}),
                                      //.data_length_i('{1, 2, 3}),
                                      //.addr_i('{'{8'h30, 8'h40}, '{8'h50, 8'h60}, '{8'h70, 8'h80}}),
                                      .local_src_pid_i(8'h11),
                                      .local_dest_pid_i(8'haa)
                                      );
               if (!IS_RATA_ENV) begin
                  bulk_seq_1.start(iosf_fbrcvc_seqr);
               end

            end
     endcase
  end

endtask :send_target_np

task sbe_cfence_test::send_master_p();
  // locals
  simple_seq simple_seq_1;
  msgd_seq msgd_seq_1;
  regio_seq regio_seq_1;
  bulk_regio_seq bulk_seq_1;
  string msg;
  iosfsbm_cm::iosfsbc_sequencer iosf_ipvc_seqr;
  bit s, m, r, b;
      
  simple_seq_1 = simple_seq::type_id::create("SIMPLE_SEQ_1",this);
  msgd_seq_1 = msgd_seq::type_id::create("MSGD_SEQ_1",this); 
  regio_seq_1 =regio_seq::type_id::create("REGIO_SEQ_1",this);
  bulk_seq_1 = bulk_regio_seq::type_id::create("BULK_SEQ_1",this);
  
  //Get sequencer Reference      
  iosf_ipvc_seqr = env_i.iosf_sbc_ip_vc_i.get_sequencer();
   
  randcase
    0 : begin s = 1; m = 0; r = 0; b = 0; end
    1 : begin s = 0; m = 1; r = 0; b = 0; end
    1 : begin s = 0; m = 0; r = 1; b = 0; end
    1 : begin s = 0; m = 0; r = 0; b = 1; end
    1 : begin s = 0; m = 1; r = 1; b = 1; end
  endcase

  repeat(20)begin
     randcase
        s : begin
               ovm_report_info(get_name(), $psprintf("TEST: Sending Master P - Simple Message"));
               simple_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                           env_i.iosf_sbc_ip_vc_i.common_cfg_i);
               simple_seq_1.set_cfg(env_i.iosf_sbc_fabric_vc_i.fabric_cfg_i.fabric_ep_cfg_i,
                           env_i.iosf_sbc_fabric_vc_i.common_cfg_i);
               simple_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                                       8'h33, //Source
                                       8'h01, //Dest
                                       iosfsbm_cm::OP_ASSERT_INTA, //Opcode
                                       3'b000, //tag
                                       //.eh_i(1),
                                       //.ext_headers_i('{8'h11,8'haa,8'h20,8'h01}),
                                       .local_src_pid_i(8'h33),
                                       .local_dest_pid_i(8'h01)
                                       );
               if (!IS_RATA_ENV) begin
                 simple_seq_1.start(iosf_ipvc_seqr);
               end
            end
        m : begin
               ovm_report_info(get_name(), $psprintf("TEST: Sending Master P - Msgd Message"));
               msgd_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                           env_i.iosf_sbc_ip_vc_i.common_cfg_i);
               msgd_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                                     8'haa, //Source
                                     8'h11, //Dest
                                     iosfsbm_cm::OP_PM_DMD, //Opcode
                                     3'b001, //tag
                                     '{8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01}, //64 bit data
                                     .local_src_pid_i(8'haa),
                                     .local_dest_pid_i(8'h11)
                                     );
                  
               if (!IS_RATA_ENV) begin
                 msgd_seq_1.start(iosf_ipvc_seqr);
               end
            end
        r : begin
               regio_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i,
                           env_i.iosf_sbc_ip_vc_i.common_cfg_i);
               if(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.maxtrgtaddr==47)
               begin  
                 ovm_report_info(get_name(), $psprintf("TEST: Sending Master P - Regio Message A"));
                 regio_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                                      8'haa, //Source
                                      8'h11, //Dest            
                                      iosfsbm_cm::OP_CRWR, //opcode
                                      2'b01, //addrlen                         
                                      3'b000, //bar 
                                      3'b000, //tag=0 for posted
                                      4'h1, //sbe
                                      4'h1, //fbe
                                      8'haa, //fid
                                      //'{8'h20, 8'h30,8'h20, 8'h30,8'h20, 8'h30}, //address   
                                      '{8'h20, 8'h01,8'h11, 8'haa,8'h20, 8'h01}, //address   
                                      '{8'h11,8'haa,8'h20,8'h01}, //1dw data    
                                      .local_src_pid_i(8'haa),
                                      .local_dest_pid_i(8'h11)
                                      );    
 
               end 
               else//16bit address
               begin
                 ovm_report_info(get_name(), $psprintf("TEST: Sending Master P - Regio Message B"));
                 regio_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                                      8'haa, //Source
                                      8'h11, //Dest            
                                      iosfsbm_cm::OP_CRWR, //opcode
                                      2'b00, //addrlen                         
                                      3'b000, //bar 
                                      3'b000, //tag=0 for posted
                                      4'h1, //sbe
                                      4'h1, //fbe
                                      8'haa, //fid
                                      '{8'h20, 8'h01}, //address   
                                      '{8'h11,8'haa,8'h20,8'h01}, //1dw data    
                                      .local_src_pid_i(8'haa),
                                      .local_dest_pid_i(8'h11)
                                      );
               end   
               if (!IS_RATA_ENV) begin
                 regio_seq_1.start(iosf_ipvc_seqr);
               end  //!RATA                            
            end
        b : begin
               ovm_report_info(get_name(), $psprintf("TEST: Sending Master P - Bulk Regio Message"));
               bulk_seq_1.set_cfg(env_i.iosf_sbc_ip_vc_i.agent_cfg_i.ep_cfg_i, 
                           env_i.iosf_sbc_ip_vc_i.common_cfg_i);
               bulk_seq_1.set_fields(iosfsbm_cm::POSTED, //Xaction_class
                                      8'haa, //Source
                                      8'h11, //Dest            
                                      iosfsbm_cm::BULK_WR, //opcode
                                      2'b00, //addrlen                         
                                      3'b000, //bar 
                                      3'b001, //tag
                                      .num_chunk(1),
                                      .data_length_i('{'h11}),
                                      .fid_i('{8'haa}),
                                      .space_i('{2'b00}),
                                      .addr_i('{'{8'h20, 8'h01}}),
                                      .data_i('{'{8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01, 8'h11, 8'haa, 8'h20, 8'h01,
                                                  8'h11, 8'haa, 8'h20, 8'h01}}),
                                      .local_src_pid_i(8'haa),
                                      .local_dest_pid_i(8'h11)
                                      );
               if (!IS_RATA_ENV) begin
                  bulk_seq_1.start(iosf_ipvc_seqr);
               end
            end
     endcase
     #500ns;
  end

endtask :send_master_p

task sbe_cfence_test::run();
  // locals
  ovm_event_pool event_pool;
  ovm_event stop_send_event;
      
  #1us;

  fork
    send_target_np();
    send_master_p();
  join

  #100us;
      
  // Get global stop event
  event_pool = ovm_event_pool::get_global_pool();
  stop_send_event = event_pool.get("STOP_SEND");

  stop_send_event.trigger();
  ovm_report_info("SBE_CFENCE_TEST ", "Stopping Test");
  
  // Stop simulation
  global_stop_request();
endtask :run

`endif //SBE_CFENCE_TEST

