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

import ovm_pkg::*;
import svlib_pkg::*;
import sla_pkg::*;
import ccu_vc_pkg::*;

`define SBEREGB(b) b == 31 ?  3 :  7
`define PLDW(b,a) b == 1 ? a : 31
`define MPLDW(b,a,c) b == 1 ? ((a+1)*c)+a : (32*c)+31
`define LBWCAL(b,a,c) b == 1 ? (a+1)*c : (32*c)
//`define UBWCAL(b,a,c) b == 1 ? (a+1)*c
//`timescale 1ns/1ns

//  testbench to test endpoint (IP VC, fabric VC  connected to endpoint)
module tb_top ;
   import iosftest_pkg::*;   
   
  // misc wires.
   logic clk, clk1, reset, reset1, gated_side_clk, gated_clk,endpoint_reset;
   int reset_cnt1, reset_cnt2;  
   string ep_intf_name;
   bit mux_sel;
   bit new_usync0,new_usync1;

// This parameter is a place holder for driving the USYNC_ENABLE parameter
// to the sbendpoint instance. For now, USYNC_ENABLE is set to one, causing
// the RTL to instantiate universal synchronizers in the async fifos.
// The universal synchronizers are bypassed by setting the usyncselect
// sbendpoint input to 0. In order to excercise the universal synchronizer,
// the testbench needs to drive the side_usync and agent_usync inputs
// appropriately.
   
    initial 
	begin  
	 if(USYNC_ENABLE == 1)
  	   mux_sel = $urandom_range(1,0);
	  else
           mux_sel = 0;
         end 

    always @ (posedge ccu_if.clk[0])
        new_usync0 <= ccu_if.usync[0];
    always @ (posedge ccu_if.clk[1])
        new_usync1 <= ccu_if.usync[1];

// The following logic is included to emulate the power gating behavior of the 
// of the host agent
  logic sleep_b   = 0;
  logic isol_en_b = 1;
  logic rst_b     = 1;
  logic fet_en_b  = 0;

`ifdef SBEP_POWER_AWARE_SIM
  always @ (tb_top.ep_intf.side_ism_lock_b or 
            tb_top.fabric_intf.side_ism_agent)
    begin
      // ISM_AGENT_IDLE = 0
      if ((tb_top.fabric_intf.side_ism_agent == '0) && 
          !tb_top.ep_intf.side_ism_lock_b)
        fork
          #2_000 sleep_b    = 1;
          #2_000 isol_en_b  = 0;
          #4_000 rst_b      = 0;
          #6_000 fet_en_b   = 1;
        join
        #10_000;
        fork
          #2_000 fet_en_b   = 0;
          #4_000 rst_b      = 1;
          #6_000 sleep_b    = 0;
          #6_000 isol_en_b  = 1;
        join
    end // always_comb
`endif

    parameter NUM_REPEATER_FLOPS = (VARIABLE_CLAIM_DELAY == 1)? 3 : 0;

	logic [MAXPCMSTR:0]	            mmsg_pcirdy_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXNPMSTR:0]	            mmsg_npirdy_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXPCMSTR:0]	            mmsg_pceom_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXNPMSTR:0]	            mmsg_npeom_ep [NUM_REPEATER_FLOPS+1];
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCMSTR):0]	mmsg_pcpayload_ep [NUM_REPEATER_FLOPS+1];
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPMSTR):0]	mmsg_nppayload_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXPCMSTR:0]				mmsg_pctrdy_ep [NUM_REPEATER_FLOPS+1];  //multi
	logic [MAXNPMSTR:0]				mmsg_nptrdy_ep [NUM_REPEATER_FLOPS+1];  //multi
	logic [MAXPCMSTR:0]				mmsg_pcmsgip_ep [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXNPMSTR:0]				mmsg_npmsgip_ep [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXPCMSTR:0]	            mmsg_pcsel_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXNPMSTR:0]	            mmsg_npsel_ep [NUM_REPEATER_FLOPS+1];

	logic [MAXPCTRGT:0]	            tmsg_pcfree_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXNPTRGT:0]	            tmsg_npfree_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXNPTRGT:0]	            tmsg_npclaim_ep [NUM_REPEATER_FLOPS+1];
	logic [MAXPCTRGT:0]				tmsg_pcput_ep [NUM_REPEATER_FLOPS+1];   //multi
	logic [MAXNPTRGT:0]				tmsg_npput_ep [NUM_REPEATER_FLOPS+1];   //multi
	logic [MAXPCTRGT:0]				tmsg_pcmsgip_ep [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXNPTRGT:0]				tmsg_npmsgip_ep [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXPCTRGT:0]				tmsg_pceom_ep [NUM_REPEATER_FLOPS+1];   //multi
	logic [MAXNPTRGT:0]				tmsg_npeom_ep [NUM_REPEATER_FLOPS+1];   //multi

	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_pcpayload_ep [NUM_REPEATER_FLOPS+1];
	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_nppayload_ep [NUM_REPEATER_FLOPS+1];
    logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCTRGT):0]	tmsg_pcpayload_ep [NUM_REPEATER_FLOPS+1];
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPTRGT):0]	tmsg_nppayload_ep [NUM_REPEATER_FLOPS+1];

	logic [MAXPCTRGT:0]				tmsg_pccmpl_ep [NUM_REPEATER_FLOPS+1];  //multi
	logic [MAXNPTRGT:0]				tmsg_npvalid_ep [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXPCTRGT:0]				tmsg_pcvalid_ep [NUM_REPEATER_FLOPS+1];	//multi
	
	logic [MAXPCMSTR:0]	            mmsg_pcirdy_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXNPMSTR:0]	            mmsg_npirdy_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXPCMSTR:0]	            mmsg_pceom_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXNPMSTR:0]	            mmsg_npeom_ip [NUM_REPEATER_FLOPS+1];
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCMSTR):0]	mmsg_pcpayload_ip [NUM_REPEATER_FLOPS+1];
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPMSTR):0]	mmsg_nppayload_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXPCMSTR:0]				mmsg_pctrdy_ip [NUM_REPEATER_FLOPS+1];  //multi
	logic [MAXNPMSTR:0]				mmsg_nptrdy_ip [NUM_REPEATER_FLOPS+1];  //multi
	logic [MAXPCMSTR:0]				mmsg_pcmsgip_ip [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXNPMSTR:0]				mmsg_npmsgip_ip [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXPCMSTR:0]	            mmsg_pcsel_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXNPMSTR:0]	            mmsg_npsel_ip [NUM_REPEATER_FLOPS+1];

	logic [MAXPCTRGT:0]	            tmsg_pcfree_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXNPTRGT:0]	            tmsg_npfree_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXNPTRGT:0]	            tmsg_npclaim_ip [NUM_REPEATER_FLOPS+1];
	logic [MAXPCTRGT:0]				tmsg_pcput_ip [NUM_REPEATER_FLOPS+1];   //multi
	logic [MAXNPTRGT:0]				tmsg_npput_ip [NUM_REPEATER_FLOPS+1];   //multi
	logic [MAXPCTRGT:0]				tmsg_pcmsgip_ip [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXNPTRGT:0]				tmsg_npmsgip_ip [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXPCTRGT:0]				tmsg_pceom_ip [NUM_REPEATER_FLOPS+1];   //multi
	logic [MAXNPTRGT:0]				tmsg_npeom_ip [NUM_REPEATER_FLOPS+1];   //multi

	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_pcpayload_ip [NUM_REPEATER_FLOPS+1];
	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_nppayload_ip [NUM_REPEATER_FLOPS+1];
    logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCTRGT):0]    tmsg_pcpayload_ip [NUM_REPEATER_FLOPS+1];
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPTRGT):0]    tmsg_nppayload_ip [NUM_REPEATER_FLOPS+1];

	logic [MAXPCTRGT:0]				tmsg_pccmpl_ip [NUM_REPEATER_FLOPS+1];  //multi
	logic [MAXNPTRGT:0]				tmsg_npvalid_ip [NUM_REPEATER_FLOPS+1]; //multi
	logic [MAXPCTRGT:0]				tmsg_pcvalid_ip [NUM_REPEATER_FLOPS+1]; //multi
    

    logic 				tmsg_pcput_inter;
    logic 				tmsg_npput_inter;
    logic 				tmsg_pcmsgip_inter;
    logic 				tmsg_npmsgip_inter;
    logic 				tmsg_pceom_inter;
    logic 				tmsg_npeom_inter;
    logic 				tmsg_pccmpl_inter;
    logic 				tmsg_npvalid_inter;
    logic 				tmsg_pcvalid_inter;
    logic 				mmsg_pctrdy_inter;
    logic 				mmsg_nptrdy_inter;
    logic 				mmsg_pcmsgip_inter;
    logic 				mmsg_npmsgip_inter;
    logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_pcpayload_inter;
	logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_nppayload_inter;

	genvar          loop;
    genvar          agt;

 // Instantiate DUT(IP_VC-DUT-FABRIC_VC)

//***************************************************

sbendpoint#(
  .NPQUEUEDEPTH (NPQUEUEDEPTH),
  .PCQUEUEDEPTH (PCQUEUEDEPTH),
  .VALONLYMODEL (VALONLYMODEL),
  .MAXTRGTADDR  (MAXTRGTADDR),
  .MAXMSTRADDR  (MAXMSTRADDR),
  .MAXMSTRDATA  (MAXMSTRDATA),
  .MAXTRGTDATA  (MAXTRGTDATA),
  .CUP2PUT1CYC  (CUP2PUT1CYC),  
  .ASYNCENDPT   (ASYNCENDPT),
  .ASYNCEQDEPTH (ASYNCEQDEPTH),
  .ASYNCIQDEPTH (ASYNCIQDEPTH),
  .TARGETREG    (TARGETREG),
  .MASTERREG    (MASTERREG),
  .MAXPCTRGT    (MAXPCTRGT),
  .MAXNPTRGT    (MAXNPTRGT),
  .MAXPCMSTR    (MAXPCMSTR), 
  .MAXNPMSTR    (MAXNPMSTR),
  .MAXPLDBIT    (MAXPLDBIT),
  .MATCHED_INTERNAL_WIDTH (MATCHED_INTERNAL_WIDTH),
  .DUMMY_CLKBUF(DUMMY_CLKBUF),            
  .RX_EXT_HEADER_SUPPORT(RX_EXT_HEADER_SUPPORT),
  .TX_EXT_HEADER_SUPPORT(TX_EXT_HEADER_SUPPORT),
  .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS - 1),
  .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS - 1),
  .RX_EXT_HEADER_IDS(RX_EXT_HEADER_IDS),
  .DISABLE_COMPLETION_FENCING(DISABLE_COMPLETION_FENCING),
  .LATCHQUEUES(LATCHQUEUES),       
  .SKIP_ACTIVEREQ(SKIP_ACTIVEREQ),
  .PIPEISMS(PIPEISMS),
  .PIPEINPS(PIPEINPS),
  .USYNC_ENABLE(USYNC_ENABLE),
  .UNIQUE_EXT_HEADERS(UNIQUE_EXT_HEADERS),
  .SAIWIDTH(SAIWIDTH),
  .RSWIDTH(RSWIDTH),
  .AGENT_USYNC_DELAY(AGENT_USYNC_DELAY),
  .SIDE_USYNC_DELAY(SIDE_USYNC_DELAY),
  .EXPECTED_COMPLETIONS_COUNTER(EXPECTED_COMPLETIONS_COUNTER),
  .ISM_COMPLETION_FENCING(ISM_COMPLETION_FENCING),
  .CLAIM_DELAY(3*NUM_REPEATER_FLOPS)
 // .NUM_REPEATER_FLOPS (NUM_REPEATER_FLOPS)	    
)                                        
sbendpoint (                                    
  .side_clk ( gated_side_clk),
  .side_rst_b ( endpoint_reset && rst_b),
                                     
  .agent_clk(gated_clk),
  //.agent_rst_b(reset1),     

  .usyncselect(mux_sel),
  .side_usync(new_usync0),
  .agent_usync(new_usync1),
                             
  //Fabric Node
  .side_ism_fabric ( fabric_intf.side_ism_fabric ),
  .side_ism_agent  ( fabric_intf.side_ism_agent ),
  .side_ism_lock_b ( ep_intf.side_ism_lock_b ),
  .side_clkreq     ( fabric_intf.side_clkreq ),
  .side_clkack     ( fabric_intf.side_clkack ),                                   
  .tpccup (  fabric_intf.mpccup  ), 
  .mpccup (  fabric_intf.tpccup  ), 
  .tnpcup (  fabric_intf.mnpcup  ), 
  .mnpcup (  fabric_intf.tnpcup  ), 
  .mpcput (  fabric_intf.tpcput  ), 
  .tpcput (  fabric_intf.mpcput  ), 
  .mnpput (  fabric_intf.tnpput  ), 
  .tnpput (  fabric_intf.mnpput  ), 
  .meom (  fabric_intf.teom  ), 
  .teom (  fabric_intf.meom  ), 
  .mpayload (  fabric_intf.tpayload  ),
  .mparity (fabric_intf.tparity),
  .tpayload (  fabric_intf.mpayload  ),
  .tparity ( fabric_intf.mparity),

  //IP Node   
  .agent_clkreq(ep_intf.agent_clkreq),
  .agent_idle(ep_intf.agent_idle),
  .sbe_clkreq(ep_intf.sbe_clkreq),
  .sbe_idle(ep_intf.sbe_idle),
                                                                    
  .tmsg_pcfree(tmsg_pcfree_ep[0]),
  .tmsg_npfree(tmsg_npfree_ep[0]),
  .tmsg_npclaim(tmsg_npclaim_ep[0]),
  .tmsg_pcput(tmsg_pcput_inter),
  .tmsg_npput(tmsg_npput_inter),
  .tmsg_pcmsgip(tmsg_pcmsgip_inter),
  .tmsg_npmsgip(tmsg_npmsgip_inter),
  .tmsg_pceom(tmsg_pceom_inter),
  .tmsg_npeom(tmsg_npeom_inter),
  .tmsg_pcpayload(tmsg_pcpayload_inter),
  .tmsg_nppayload(tmsg_nppayload_inter),
  .tmsg_pccmpl(tmsg_pccmpl_inter),
  .tmsg_npvalid(tmsg_npvalid_inter),
  .tmsg_pcvalid(tmsg_pcvalid_inter),
  .ur_csairs_valid  ( ep_intf.ur_csairs_valid ),
  .ur_csai          ( ep_intf.ur_csai),
  .ur_crs           ( ep_intf.ur_crs),
  .ur_rx_sairs_valid( ep_intf.ur_rx_sairs_valid),
  .ur_rx_sai        ( ep_intf.ur_rx_sai),
  .ur_rx_rs         ( ep_intf.ur_rx_rs),
                                     
  .mmsg_pcirdy(mmsg_pcirdy_ep[0]),
  .mmsg_npirdy(mmsg_npirdy_ep[0]),
  .mmsg_pceom(mmsg_pceom_ep[0]),
  .mmsg_npeom(mmsg_npeom_ep[0]),
  .mmsg_pcpayload(mmsg_pcpayload_ep[0]),
  .mmsg_nppayload (mmsg_nppayload_ep[0]),
  .mmsg_pctrdy(mmsg_pctrdy_inter),
  .mmsg_nptrdy(mmsg_nptrdy_inter),
  .mmsg_pcmsgip(mmsg_pcmsgip_inter),
  .mmsg_npmsgip(mmsg_npmsgip_inter),
  .mmsg_pcsel(mmsg_pcsel_ep[0]),
  .mmsg_npsel(mmsg_npsel_ep[0]),

  .treg_trdy(ep_intf.treg_trdy),
  .treg_cerr(ep_intf.treg_cerr),
  .treg_rdata(ep_intf.treg_rdata[MAXTRGTDATA:0]),
  .treg_irdy(ep_intf.treg_irdy),
  .treg_np(ep_intf.treg_np),
  .treg_dest(ep_intf.treg_dest),
  .treg_source(ep_intf.treg_source),
  .treg_opcode(ep_intf.treg_opcode),
  .treg_addrlen(ep_intf.treg_addrlen),
  .treg_bar(ep_intf.treg_bar),
  .treg_tag(ep_intf.treg_tag),
  .treg_be(ep_intf.treg_be[`SBEREGB(MAXTRGTDATA):0]),
  .treg_fid(ep_intf.treg_fid),
  .treg_addr(ep_intf.treg_addr[MAXTRGTADDR:0]),
  .treg_wdata(ep_intf.treg_wdata[MAXTRGTDATA:0]),
  .treg_eh(ep_intf.treg_eh),
  .treg_ext_header(treg_ext_header),
  .treg_eh_discard(ep_intf.treg_eh_discard),                                              
  .treg_csairs_valid(ep_intf.treg_csairs_valid),
  .treg_csai(ep_intf.treg_csai),
  .treg_crs(ep_intf.treg_crs),
  .treg_rx_sairs_valid(treg_rx_sairs_valid),
  .treg_rx_sai        (treg_rx_sai),
  .treg_rx_rs         (treg_rx_rs ),

  .mreg_irdy(ep_intf.mreg_irdy),
  .mreg_npwrite(ep_intf.mreg_npwrite),
  .mreg_dest(ep_intf.mreg_dest),
  .mreg_source(ep_intf.mreg_source),
  .mreg_opcode(ep_intf.mreg_opcode),
  .mreg_addrlen(ep_intf.mreg_addrlen),
  .mreg_bar(ep_intf.mreg_bar),
  .mreg_tag(ep_intf.mreg_tag),
  .mreg_be(ep_intf.mreg_be[`SBEREGB(MAXMSTRDATA):0]),
  .mreg_fid(ep_intf.mreg_fid),
  .mreg_addr(ep_intf.mreg_addr[MAXMSTRADDR:0]),
  .mreg_wdata(ep_intf.mreg_wdata[MAXMSTRDATA:0]),
  .mreg_trdy(ep_intf.mreg_trdy),
  .mreg_pmsgip(ep_intf.mreg_pmsgip),
  .mreg_nmsgip(ep_intf.mreg_nmsgip),
  .mreg_sairs_valid(ep_intf.mreg_sairs_valid),
  .mreg_sai(ep_intf.mreg_sai),
  .mreg_rs(ep_intf.mreg_rs),

  .tx_ext_headers(ep_intf.tx_ext_headers),
                             
  .cgctrl_idlecnt          (8'h10),
  .cgctrl_clkgaten         (1'b1),
  .cgctrl_clkgatedef       (1'b0),
  .jta_clkgate_ovrd        (1'b0),
  .jta_force_clkreq        (1'b0),
  .jta_force_idle          (1'b0),
  .jta_force_notidle       (1'b0),
  .jta_force_creditreq     (1'b0),
  .fscan_latchopen         (1'b0),
  .fscan_latchclosed_b     (1'b1),
  .fscan_clkungate         (1'b0),
  .fscan_rstbypen          (1'b0),
  .fscan_clkungate_syn     (1'b0),
  .fscan_mode              (1'b0),
  .fscan_shiften           (1'b0),
  .fdfx_rst_b              (1'b1),
  .fscan_byprst_b          (1'b1) 
);

//***************************************************

generate 
	for( loop = 0 ; loop < MAXPCTRGT+1 ; loop++) begin
        assign tmsg_pcput_ep[0][loop] = tmsg_pcput_inter; 
        assign tmsg_pcmsgip_ep[0][loop] = tmsg_pcmsgip_inter;
        assign tmsg_pceom_ep[0][loop] = tmsg_pceom_inter;
        assign tmsg_pccmpl_ep[0][loop] = tmsg_pccmpl_inter;
        assign tmsg_pcvalid_ep[0][loop] = tmsg_pcvalid_inter;
        assign tmsg_pcpayload_ep[0][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop)] = tmsg_pcpayload_inter;
    end
endgenerate

generate 
	for( loop = 0 ; loop < MAXNPTRGT+1 ; loop++) begin
        assign tmsg_npput_ep[0][loop] = tmsg_npput_inter;
        assign tmsg_npmsgip_ep[0][loop] = tmsg_npmsgip_inter;
        assign tmsg_npeom_ep[0][loop] = tmsg_npeom_inter;
        assign tmsg_npvalid_ep[0][loop] = tmsg_npvalid_inter;
        assign tmsg_nppayload_ep[0][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop)] = tmsg_nppayload_inter;
    end
endgenerate

generate 
	for( loop = 0 ; loop < MAXPCMSTR+1 ; loop++) begin
        assign mmsg_pctrdy_ep[0][loop] = mmsg_pctrdy_inter;
        assign mmsg_pcmsgip_ep[0][loop] = mmsg_pcmsgip_inter;
    end
endgenerate

generate 
	for( loop = 0 ; loop < MAXNPMSTR+1 ; loop++) begin
        assign mmsg_nptrdy_ep[0][loop] = mmsg_nptrdy_inter;
        assign mmsg_npmsgip_ep[0][loop] = mmsg_npmsgip_inter;
    end
endgenerate

//***************************************************

assign	mmsg_pcirdy_ip[NUM_REPEATER_FLOPS] = ep_intf.mmsg_pcirdy;
assign	mmsg_npirdy_ip[NUM_REPEATER_FLOPS] = ep_intf.mmsg_npirdy;
assign	mmsg_pceom_ip[NUM_REPEATER_FLOPS] = ep_intf.mmsg_pceom;
assign	mmsg_npeom_ip[NUM_REPEATER_FLOPS] = ep_intf.mmsg_npeom; 
assign	mmsg_pcpayload_ip[NUM_REPEATER_FLOPS] = ep_intf.mmsg_pcpayload.payload;
assign	mmsg_nppayload_ip[NUM_REPEATER_FLOPS] = ep_intf.mmsg_nppayload.payload;
assign	ep_intf.mmsg_pctrdy = mmsg_pctrdy_ip[NUM_REPEATER_FLOPS]; 
assign  ep_intf.mmsg_nptrdy = mmsg_nptrdy_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.mmsg_pcmsgip = mmsg_pcmsgip_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.mmsg_npmsgip = mmsg_npmsgip_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.mmsg_pcsel = mmsg_pcsel_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.mmsg_npsel = mmsg_npsel_ip[NUM_REPEATER_FLOPS];


assign  ep_intf.tmsg_pcvalid = tmsg_pcvalid_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.tmsg_npvalid = tmsg_npvalid_ip[NUM_REPEATER_FLOPS];
assign	tmsg_pcfree_ip[NUM_REPEATER_FLOPS] = ep_intf.tmsg_pcfree;
assign	tmsg_npfree_ip[NUM_REPEATER_FLOPS] = ep_intf.tmsg_npfree;
assign  tmsg_npclaim_ip[NUM_REPEATER_FLOPS] = ep_intf.tmsg_npclaim;
assign	ep_intf.tmsg_pcput = tmsg_pcput_ip[NUM_REPEATER_FLOPS];
assign	ep_intf.tmsg_npput = tmsg_npput_ip[NUM_REPEATER_FLOPS];
assign	ep_intf.tmsg_pcmsgip = tmsg_pcmsgip_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.tmsg_npmsgip = tmsg_npmsgip_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.tmsg_pceom = tmsg_pceom_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.tmsg_npeom = tmsg_npeom_ip[NUM_REPEATER_FLOPS];
assign  ep_intf.tmsg_pcpayload = tmsg_pcpayload_ip[NUM_REPEATER_FLOPS];
assign	ep_intf.tmsg_nppayload = tmsg_nppayload_ip[NUM_REPEATER_FLOPS];
assign	ep_intf.tmsg_pccmpl = tmsg_pccmpl_ip[NUM_REPEATER_FLOPS];

//***************************************************

//****************************************************
//instantiation of repeater
//****************************************************

if(NUM_REPEATER_FLOPS == 0) begin
			assign	mmsg_pcirdy_ep[0] = mmsg_pcirdy_ip[0];
			assign	mmsg_npirdy_ep[0] = mmsg_npirdy_ip[0];
			assign	mmsg_pceom_ep[0] = mmsg_pceom_ip[0];
			assign  mmsg_npeom_ep[0] = mmsg_npeom_ip[0];
			assign	mmsg_pcpayload_ep[0] = mmsg_pcpayload_ip[0];
			assign	mmsg_nppayload_ep[0] = mmsg_nppayload_ip[0];

			assign	mmsg_pctrdy_ip[0] = mmsg_pctrdy_ep[0];
			assign	mmsg_nptrdy_ip[0] = mmsg_nptrdy_ep[0];
			assign	mmsg_pcmsgip_ip[0] = mmsg_pcmsgip_ep[0];
			assign  mmsg_npmsgip_ip[0] = mmsg_npmsgip_ep[0];
			assign	mmsg_pcsel_ip[0] = mmsg_pcsel_ep[0];
			assign	mmsg_npsel_ip[0]	= mmsg_npsel_ep[0];
		
			assign	tmsg_pcvalid_ip[0] = tmsg_pcvalid_ep[0];
			assign	tmsg_npvalid_ip[0] = tmsg_npvalid_ep[0];
			assign	tmsg_pcfree_ep[0] = tmsg_pcfree_ip[0];
			assign	tmsg_npfree_ep[0] = tmsg_npfree_ip[0];
			assign	tmsg_npclaim_ep[0] = tmsg_npclaim_ip[0];
			assign	tmsg_pcput_ip[0] = tmsg_pcput_ep[0];
			assign	tmsg_npput_ip[0] = tmsg_npput_ep[0];
			assign	tmsg_pcmsgip_ip[0] = tmsg_pcmsgip_ep[0];
			assign	tmsg_npmsgip_ip[0] = tmsg_npmsgip_ep[0];
			assign	tmsg_pceom_ip[0] = tmsg_pceom_ep[0];
			assign	tmsg_npeom_ip[0] = tmsg_npeom_ep[0];
			assign	tmsg_pcpayload_ip[0] = tmsg_pcpayload_ep[0];
			assign	tmsg_nppayload_ip[0] = tmsg_nppayload_ep[0];
			assign	tmsg_pccmpl_ip[0] = tmsg_pccmpl_ep[0];						
end

//****************************************************

generate 
	for( loop = 0 ; loop < NUM_REPEATER_FLOPS ; loop++) begin
        for(agt = 0; agt < MAXPCMSTR + 1; agt++) begin
			sberepeater #(
			.INTERNALPLDBIT(`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT))
   			)
   			i_sberepeater (
  			.agent_clk    (ccu_if.clk[1]),//gated_clk),
  			.agent_rst_b  (endpoint_reset && rst_b)  ,			   
  			.sbi_sbe_tmsg_pcfree_ip     ( tmsg_pcfree_ip[loop+1][agt]          ),
  			.sbi_sbe_tmsg_npfree_ip     ( tmsg_npfree_ip[loop+1][agt]                    ),
  			.sbi_sbe_tmsg_npclaim_ip    ( tmsg_npclaim_ip[loop+1][agt]                   ),
  			.sbe_sbi_tmsg_pcput_ip      ( tmsg_pcput_ip[loop+1][agt]                             ),
  			.sbe_sbi_tmsg_npput_ip      ( tmsg_npput_ip[loop+1][agt]                             ),
  			.sbe_sbi_tmsg_pcmsgip_ip    ( tmsg_pcmsgip_ip[loop+1][agt]                           ),
  			.sbe_sbi_tmsg_npmsgip_ip    ( tmsg_npmsgip_ip[loop+1][agt]                           ),
  			.sbe_sbi_tmsg_pceom_ip      ( tmsg_pceom_ip[loop+1][agt]                             ),
  			.sbe_sbi_tmsg_npeom_ip      ( tmsg_npeom_ip[loop+1][agt]                            ),
  			.sbe_sbi_tmsg_pcpayload_ip  (tmsg_pcpayload_ip[loop+1][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                         ),
  			.sbe_sbi_tmsg_nppayload_ip  ( tmsg_nppayload_ip[loop+1][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                         ),
  			.sbe_sbi_tmsg_pccmpl_ip     ( tmsg_pccmpl_ip[loop+1][agt]                            ),


  			.sbi_sbe_mmsg_pcirdy_ip     ( mmsg_pcirdy_ip[loop+1][agt]                    ),
  			.sbi_sbe_mmsg_npirdy_ip     ( mmsg_npirdy_ip[loop+1][agt]                    ),
  			.sbi_sbe_mmsg_pceom_ip      ( mmsg_pceom_ip[loop+1][agt]                     ),
  			.sbi_sbe_mmsg_npeom_ip      ( mmsg_npeom_ip[loop+1][agt]                     ),
  			.sbi_sbe_mmsg_pcpayload_ip  ( mmsg_pcpayload_ip[loop+1][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                 ),
  			.sbi_sbe_mmsg_nppayload_ip  ( mmsg_nppayload_ip[loop+1][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                 ),
  			.sbe_sbi_mmsg_pctrdy_ip     ( mmsg_pctrdy_ip[loop+1][agt]                            ),
  			.sbe_sbi_mmsg_nptrdy_ip     ( mmsg_nptrdy_ip[loop+1][agt]                            ),
  			.sbe_sbi_mmsg_pcmsgip_ip    ( mmsg_pcmsgip_ip[loop+1][agt]                           ),
  			.sbe_sbi_mmsg_npmsgip_ip    ( mmsg_npmsgip_ip[loop+1][agt]                           ),
  			.sbe_sbi_mmsg_pcsel_ip      ( mmsg_pcsel_ip[loop+1][agt]                     ),
  			.sbe_sbi_mmsg_npsel_ip      ( mmsg_npsel_ip[loop+1][agt]                     ),
  			.sbe_sbi_tmsg_pcvalid_ip    ( tmsg_pcvalid_ip[loop+1][agt]                           ),
  			.sbe_sbi_tmsg_npvalid_ip    ( tmsg_npvalid_ip[loop+1][agt]                         ),

  			.sbi_sbe_tmsg_pcfree_ep     ( tmsg_pcfree_ep[loop][agt]                    ),
  			.sbi_sbe_tmsg_npfree_ep     ( tmsg_npfree_ep[loop][agt]                    ),
  			.sbi_sbe_tmsg_npclaim_ep    ( tmsg_npclaim_ep[loop][agt]                   ),
  			.sbe_sbi_tmsg_pcput_ep      ( tmsg_pcput_ep[loop][agt]                             ),
  			.sbe_sbi_tmsg_npput_ep      ( tmsg_npput_ep[loop][agt]                             ),
  			.sbe_sbi_tmsg_pcmsgip_ep    ( tmsg_pcmsgip_ep[loop][agt]                           ),
  			.sbe_sbi_tmsg_npmsgip_ep    ( tmsg_npmsgip_ep[loop][agt]                           ),
  			.sbe_sbi_tmsg_pceom_ep      ( tmsg_pceom_ep[loop][agt]                             ),
  			.sbe_sbi_tmsg_npeom_ep      ( tmsg_npeom_ep[loop][agt]                            ),
  			.sbe_sbi_tmsg_pcpayload_ep  ( tmsg_pcpayload_ep[loop][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                         ),
  			.sbe_sbi_tmsg_nppayload_ep  ( tmsg_nppayload_ep[loop][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                         ),
  			.sbe_sbi_tmsg_pccmpl_ep     ( tmsg_pccmpl_ep[loop][agt]                            ),
  			.fscan_rstbypen          ( 1'b0                         ), 
  			.fscan_byprst_b          ( 1'b1                         ), 
  			.fscan_mode              ( 1'b0                             ),
  			.fscan_shiften           ( 1'b0                          ),
  			.fscan_clkungate_syn     ( 1'b0                    ),
			   
  			.sbi_sbe_mmsg_pcirdy_ep     ( mmsg_pcirdy_ep[loop][agt]                    ),
  			.sbi_sbe_mmsg_npirdy_ep     ( mmsg_npirdy_ep[loop][agt]                    ),
  			.sbi_sbe_mmsg_pceom_ep      ( mmsg_pceom_ep[loop][agt]                     ),
  			.sbi_sbe_mmsg_npeom_ep      ( mmsg_npeom_ep[loop][agt]                     ),
  			.sbi_sbe_mmsg_pcpayload_ep  ( mmsg_pcpayload_ep[loop][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                 ),
  			.sbi_sbe_mmsg_nppayload_ep  ( mmsg_nppayload_ep[loop][`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]                 ),
  			.sbe_sbi_mmsg_pctrdy_ep     ( mmsg_pctrdy_ep[loop][agt]                            ),
  			.sbe_sbi_mmsg_nptrdy_ep     ( mmsg_nptrdy_ep[loop][agt]                            ),
  			.sbe_sbi_mmsg_pcmsgip_ep    ( mmsg_pcmsgip_ep[loop][agt]                           ),
  			.sbe_sbi_mmsg_npmsgip_ep    ( mmsg_npmsgip_ep[loop][agt]                           ),
  			.sbe_sbi_mmsg_pcsel_ep      ( mmsg_pcsel_ep[loop][agt]                     ),
  			.sbe_sbi_mmsg_npsel_ep      ( mmsg_npsel_ep[loop][agt]                     ),
  			.sbe_sbi_tmsg_pcvalid_ep    ( tmsg_pcvalid_ep[loop][agt]                           ),
  			.sbe_sbi_tmsg_npvalid_ep    ( tmsg_npvalid_ep[loop][agt]                         ) 			   
 			);   			 
        end
		if(loop>0) begin	
 			assign	mmsg_pcirdy_ip[loop] = mmsg_pcirdy_ep[loop];
			assign	mmsg_npirdy_ip[loop] = mmsg_npirdy_ep[loop];
			assign	mmsg_pceom_ip[loop] = mmsg_pceom_ep[loop];
			assign  mmsg_npeom_ip[loop] = mmsg_npeom_ep[loop];
			assign	mmsg_pcpayload_ip[loop] = mmsg_pcpayload_ep[loop];
			assign	mmsg_nppayload_ip[loop] = mmsg_nppayload_ep[loop];

			assign	mmsg_pctrdy_ep[loop] = mmsg_pctrdy_ip[loop];
			assign	mmsg_nptrdy_ep[loop] = mmsg_nptrdy_ip[loop];
			assign	mmsg_pcmsgip_ep[loop] = mmsg_pcmsgip_ip[loop];
			assign  mmsg_npmsgip_ep[loop] = mmsg_npmsgip_ip[loop];
			assign	mmsg_pcsel_ep[loop] = mmsg_pcsel_ip[loop];
			assign	mmsg_npsel_ep[loop]	= mmsg_npsel_ip[loop];
		
			assign	tmsg_pcvalid_ep[loop] = tmsg_pcvalid_ip[loop];
			assign	tmsg_npvalid_ep[loop] = tmsg_npvalid_ip[loop];
			assign	tmsg_pcfree_ip[loop] = tmsg_pcfree_ep[loop];
			assign	tmsg_npfree_ip[loop] = tmsg_npfree_ep[loop];
			assign	tmsg_npclaim_ip[loop] = tmsg_npclaim_ep[loop];
			assign	tmsg_pcput_ep[loop] = tmsg_pcput_ip[loop];
			assign	tmsg_npput_ep[loop] = tmsg_npput_ip[loop];
			assign	tmsg_pcmsgip_ep[loop] = tmsg_pcmsgip_ip[loop];
			assign	tmsg_npmsgip_ep[loop] = tmsg_npmsgip_ip[loop];
			assign	tmsg_pceom_ep[loop] = tmsg_pceom_ip[loop];
			assign	tmsg_npeom_ep[loop] = tmsg_npeom_ip[loop];
			assign	tmsg_pcpayload_ep[loop] = tmsg_pcpayload_ip[loop];
			assign	tmsg_nppayload_ep[loop] = tmsg_nppayload_ip[loop];
			assign	tmsg_pccmpl_ep[loop] = tmsg_pccmpl_ip[loop];	
		end	
 	end
 endgenerate

//****************************************************
	property sbe_comp_exp_prop;
		@(posedge sbendpoint.side_clk)
		disable iff (sbendpoint.side_rst_b !== 1'b1) 
		(sbendpoint.sbe_comp_exp == 1'b1 && ISM_COMPLETION_FENCING) |-> (sbendpoint.side_ism_fabric == 3 && sbendpoint.side_ism_agent == 3);
	endproperty: sbe_comp_exp_prop

	assert property (sbe_comp_exp_prop)
	else begin
		string msg;
        $sformat(msg, {"%m: ERROR ISM are toggled",
                 "while sbe_comp_exp is asserted and ISM_COMPLETION_FENCING is setting to one."});
        $error("PCR007", msg);

	end


  // Communication matrix
  // ====================
  ccu_intf #(.NUM_SLICES(2))ccu_if(); 

  ccu_vc_ti #(.NUM_SLICES(2),
              .IS_ACTIVE(1),
              .IP_ENV_TO_AGT_PATH("*env.ccu_vc_i"))
               ccu_ti(ccu_if);

  // Interface instances
  //8-bit payload  ONLY
  `ifndef IOSF_SB_PH2
  iosf_sbc_intf #(.PAYLOAD_WIDTH(MAXPLDBIT+1), 
                  .AGENT_MASTERING_SB_IF(0)) 
   fabric_intf    ( .side_clk( ccu_if.clk[0]), 
                    .side_rst_b ( reset ), 
                    .gated_side_clk(gated_side_clk),
                    .agent_rst_b(reset1));
   `else
    iosf_sbc_intf fabric_intf ( .side_clk( ccu_if.clk[0]), 
                    .side_rst_b ( reset ), 
                    .gated_side_clk(gated_side_clk),
                    .agent_rst_b(reset1));
     
    iosf_sb_ti #(.PAYLOAD_WIDTH(MAXPLDBIT+1), 
                  .AGENT_MASTERING_SB_IF(0)) fabric_ti(.iosf_sbc_intf(fabric_intf));
   `endif



  `ifndef IOSF_SB_PH2
  iosf_ep_intf#(.MAXPCMSTR(MAXPCMSTR),
                .MAXNPMSTR(MAXNPMSTR),
                .MAXPCTRGT(MAXPCTRGT),
                .MAXNPTRGT(MAXNPTRGT),
                .MAXTRGTADDR(MAXTRGTADDR),
                .MAXTRGTDATA(MAXTRGTDATA),
                .MAXMSTRADDR(MAXMSTRADDR),
                .MAXMSTRDATA(MAXMSTRDATA),
                .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS),
                .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS),
                .SAIWIDTH(SAIWIDTH),
                .RSWIDTH(RSWIDTH),
				.MAXPLDBIT(MAXPLDBIT),
				.MATCHED_INTERNAL_WIDTH(MATCHED_INTERNAL_WIDTH))          
   ep_intf     ( .clk(ccu_if.clk[1] ), .reset ( reset1 ), .gated_clk(gated_clk));
  `else
   iosf_ep_intf ep_intf ( .clk(ccu_if.clk[1] ), .reset ( reset1 ), .gated_clk(gated_clk));

   ep_ti #(.MAXPCMSTR(MAXPCMSTR),
             .MAXNPMSTR(MAXNPMSTR),
             .MAXPCTRGT(MAXPCTRGT),
             .MAXNPTRGT(MAXNPTRGT),
             .MAXTRGTADDR(MAXTRGTADDR),
             .MAXTRGTDATA(MAXTRGTDATA),
             .MAXMSTRADDR(MAXMSTRADDR),
             .MAXMSTRDATA(MAXMSTRDATA),
             .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS),
             .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS),
             .SAIWIDTH(SAIWIDTH),
             .RSWIDTH(RSWIDTH), 
			 .MAXPLDBIT(MAXPLDBIT),
			 .MATCHED_INTERNAL_WIDTH(MATCHED_INTERNAL_WIDTH)) ep_ti(.iosf_ep_intf(ep_intf));



  `endif //IOSF_SB_PH2
   // Create module for factory registration 
   // --------------------------------------
   `ifndef IOSF_SB_PH2
   iosfsb_ep_mon #(.MAXPCMSTR(MAXPCMSTR),
                   .MAXNPMSTR(MAXNPMSTR),
                   .MAXPCTRGT(MAXPCTRGT),
                   .MAXNPTRGT(MAXNPTRGT),
                   .MAXTRGTADDR(MAXTRGTADDR),
                   .MAXTRGTDATA(MAXTRGTDATA),
                   .MAXMSTRADDR(MAXMSTRADDR),
                   .MAXMSTRDATA(MAXMSTRDATA),
                   .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS),
                   .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS),
                   .SAIWIDTH(SAIWIDTH),
                   .RSWIDTH(RSWIDTH),
				   .MAXPLDBIT(MAXPLDBIT),
				   .MATCHED_INTERNAL_WIDTH(MATCHED_INTERNAL_WIDTH),
                   .INST_NUM(0)) u_iosfsb_ep_mon();
   `else
    iosfsb_ep_mon #(.INST_NUM(0)) u_iosfsb_ep_mon();
  `endif
  
  `ifndef IOSF_SB_PH2             
   //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
  `endif 
  comm_intf comm_intf_i();
  
  initial
    begin
      `ifdef ASYNC_RESET 
       $display ("Testing ASYNC_RESET=1");
      `endif
      `ifdef RESET_TEST
       $display ("Testing RESET_TEST=1");
      `endif
    end
   
    
  `ifdef ASYNC_RESET 
     initial begin
        reset1=1'b0;
        reset=1'b0;
     end
     always @(posedge ep_intf.assert_reset)
       begin
          reset1 = 1'b1;
       end
     always @(negedge ep_intf.assert_reset)
       begin
          reset1 = 1'b0;
       end
     always @(posedge fabric_intf.control_ep_reset)
       begin
          @(negedge ccu_if.clk[0] );          
          reset = 1'b1;
       end
     always @(negedge fabric_intf.control_ep_reset)
       begin
          @(negedge ccu_if.clk[0]);
          reset = 1'b0;
       end
  `else  
   initial
   begin
   	if(USYNC_ENABLE == 1) 
		reset_cnt1 = $urandom_range(35,40);
	else	
      	reset_cnt1 = $urandom_range(5,10);                                  
   end

   initial
    begin 
      reset1 = 1'b0;
      @(negedge ccu_if.clk[0]);
      reset1 = 1'b0;
      repeat(reset_cnt1) @(posedge ccu_if.clk[0]);
      @(negedge ccu_if.clk[0]);
      reset1 = 1'b1;
    end 
   
  initial
    begin 
      reset = 1'b0;
      @(negedge ccu_if.clk[0]);
      reset = 1'b0;
	  if(USYNC_ENABLE == 1)
	  	reset_cnt2 = $urandom_range(33,38);
	  else		
      	reset_cnt2 = $urandom_range(3,8);                      
      repeat(reset_cnt1) @(posedge ccu_if.clk[0]);
      @(negedge ccu_if.clk[0]);
      reset = 1'b1;
    end
  `endif 
   
  `ifdef RESET_TEST
   assign endpoint_reset = reset1;
  `else
   assign endpoint_reset = reset;
   `endif
   
	assign fabric_intf.mparity = 1'b0;   
   
  // Instantiate the top level environment
  initial
  begin :MAIN_INIT_BLK


   // Dummy reference to trigger factory registration for tests
   iosftest_pkg::base_test dummy;
   `ifndef IOSF_SB_PH2
    //Interface Wrappers for each i/f type used

    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(MAXPLDBIT+1), 
                                      .AGENT_MASTERING_SB_IF(0)) wrapper_fbrc; 
     
    iosfsbm_cm::comm_intf_wrapper wrapper_comm_intf;
     
    //ep vintf wrapper
    iosfsbm_ipvc::ipvc_vintf_wrp#(.MAXPCMSTR(MAXPCMSTR),
                                  .MAXNPMSTR(MAXNPMSTR),
                                  .MAXPCTRGT(MAXPCTRGT),
                                  .MAXNPTRGT(MAXNPTRGT),
                                  .MAXTRGTADDR(MAXTRGTADDR),
                                  .MAXTRGTDATA(MAXTRGTDATA),
                                  .MAXMSTRADDR(MAXMSTRADDR),
                                  .MAXMSTRDATA(MAXMSTRDATA),
                                  .NUM_TX_EXT_HEADERS(NUM_TX_EXT_HEADERS),
                                  .NUM_RX_EXT_HEADERS(NUM_RX_EXT_HEADERS),
                                  .SAIWIDTH(SAIWIDTH),
                                  .RSWIDTH(RSWIDTH),
								  .MAXPLDBIT(MAXPLDBIT),
								  .MATCHED_INTERNAL_WIDTH(MATCHED_INTERNAL_WIDTH)) epvc_vintf_wrapper_i; 
     //Create Bundle
    vintfBundle = new("vintfBundle"); 

   //create ep interface wrapper, and pass interface name 
   epvc_vintf_wrapper_i = new(ep_intf);
   vintfBundle.setData ("ep_intf", epvc_vintf_wrapper_i);
     
   //create comm interface wrapper, and pass interface name                 
   wrapper_comm_intf = new(comm_intf_i);
   vintfBundle.setData ("comm_intf_i", wrapper_comm_intf);
     
   //Now fill up bundle with the i/f wrapper, connecting
   //actual interfaces to the virtual ones in the bundle
   wrapper_fbrc = new(fabric_intf);
   vintfBundle.setData ("fabric_intf" , wrapper_fbrc);
    
    //Pass config info to the environment
    //pass comm_intf name string
    set_config_string("*", "comm_intf_name", "comm_intf_i");      
            
    //pass Bundle
    set_config_object("*", SB_VINTF_BUNDLE_NAME, vintfBundle, 0);
    
   
     
  `endif
    ovm_default_printer = ovm_default_line_printer;

    // Execute test
    run_test();

     //print test results
     svlib_pkg::ovm_report_utils::printTestStatus();

  end   :MAIN_INIT_BLK // block: MAIN_INIT_BLK
 `ifdef FSDB  
 initial
   begin
      $fsdbDumpvars(0,"tb_top");
   end
 `endif 
 
 //------------------------------------------
  // FSDB Dumping 
  //------------------------------------------
  `include "std_ace_util.vic"
   initial dump_fsdb();

  initial
    begin
       //Compmon only supports 1 ext_header
       if ((AGT_EXT_HEADER_SUPPORT != FBRC_EXT_HEADER_SUPPORT) ||
           (NUM_RX_EXT_HEADERS > 1 || NUM_TX_EXT_HEADERS > 1))
         begin
 //           $assertoff (0, fabric_intf.sbc_compliance.agent_message_compliance.MessageValidityCheck[1].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasSAISupport.SBMI_096_100_MasterHasSAISupport_ASSERT);
 //           $assertoff (0, fabric_intf.sbc_compliance.agent_message_compliance.MessageValidityCheck[0].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasNoSAISupport.SBMI_096_100_MasterHasNoSAISupport_ASSERT);
 //           $assertoff (0, fabric_intf.sbc_compliance.agent_message_compliance.MessageValidityCheck[1].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasNoSAISupport.SBMI_096_100_MasterHasNoSAISupport_ASSERT);
 //           $assertoff (0, fabric_intf.sbc_compliance.agent_message_compliance.MessageValidityCheck[0].CheckSAIOnMasterInterface.SBMI_096_100_MasterHasSAISupport.SBMI_096_100_MasterHasSAISupport_ASSERT);
 //           
         end
       
       if (NUM_RX_EXT_HEADERS > 1 ||
           NUM_TX_EXT_HEADERS > 1)
         begin
            //$assertoff (0, fabric_intf.sbc_compliance.fabric_message_compliance.MessageValidityCheck[1].CheckSAIOnTargetInterface.SBMI_096_100_TargetSAICheck.SBMI_096_100_TargetSAICheck_ASSERT);
         end

       if (MAXPLDBIT == 31)
         begin
           `ifndef IOSF_SB_PH2
            $assertoff(0, fabric_intf.genblk.sbc_compliance.agent_flow_compliance.SBMI_ValidPayloadSize.SBMI_ValidPayloadSize_ASSERT);
            $assertoff(0, fabric_intf.genblk.sbc_compliance.fabric_flow_compliance.SBMI_ValidPayloadSize.SBMI_ValidPayloadSize_ASSERT);
           `endif  
         end       
    end
   
endmodule :tb_top

