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
import uvm_pkg::*;
import xvm_pkg::*;
import svlib_pkg::*;
import sla_pkg::*;
import ccu_vc_pkg::*;

`define SBEREGB(b) b == 31 ?  3 :  7
`define PLDW(b,a) b == 1 ? a : 31
`define MPLDW(b,a,c) b == 1 ? ((a+1)*c)+a : (32*c)+31
`define LBWCAL(b,a,c) b == 1 ? (a+1)*c : (32*c)
`define MAXVAL(a,b) (a>=b)? a : b  
`define CAL_FLOP(a,b) (b==0)? b : a%b
`define CLAIM_RP(a,b) (a==1)? b : 0

//`define UBWCAL(b,a,c) b == 1 ? (a+1)*c
//`timescale 1ns/1ns

//  testbench to test endpoint (IP VC, fabric VC  connected to endpoint)
module tb_top ;
   import iosftest_pkg::*;   
   
  // misc wires.
   logic clk, clk1, reset, reset1, gated_side_clk, gated_clk,endpoint_reset;
   int reset_cnt1, reset_cnt2;  
   string ep_intf_name;
   bit new_usync0,new_usync1;

// This parameter is a place holder for driving the USYNC_ENABLE parameter
// to the hqm_sbendpoint instance. For now, USYNC_ENABLE is set to one, causing
// the RTL to instantiate universal synchronizers in the async fifos.
// The universal synchronizers are bypassed by setting the usyncselect
// hqm_sbendpoint input to 0. In order to excercise the universal synchronizer,
// the testbench needs to drive the side_usync and agent_usync inputs
// appropriately.
   
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

    parameter NUM_REPEATER_FLOPS = (VARIABLE_CLAIM_DELAY == 1)? NUM_REPEATER :0;
    parameter NUM_CLAIM_FLOPS = (VARIABLE_CLAIM_DELAY == 1)? NUM_CLAIM_REPEATER :0;
    parameter TOTAL_CLAIM_DELAY = (3*NUM_REPEATER_FLOPS) + NUM_CLAIM_FLOPS;

	logic [MAXPCMSTR:0]	mmsg_pcirdy_ep;
	logic [MAXNPMSTR:0]	mmsg_npirdy_ep;
    logic [MAXPCMSTR:0]	mmsg_pcparity_ep;
	logic [MAXNPMSTR:0]	mmsg_npparity_ep;
	logic [MAXPCMSTR:0]	mmsg_pceom_ep;
	logic [MAXNPMSTR:0]	mmsg_npeom_ep;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCMSTR):0]	mmsg_pcpayload_ep;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPMSTR):0]	mmsg_nppayload_ep;
	logic [MAXPCMSTR:0]	mmsg_pctrdy_ep;
	logic [MAXNPMSTR:0]	mmsg_nptrdy_ep;
	logic [MAXPCMSTR:0]	mmsg_pcmsgip_ep;
	logic [MAXNPMSTR:0]	mmsg_npmsgip_ep;
	logic [MAXPCMSTR:0]	mmsg_pcsel_ep;
	logic [MAXNPMSTR:0]	mmsg_npsel_ep;

	logic [MAXPCTRGT:0]	tmsg_pcfree_ep;
	logic [MAXNPTRGT:0]	tmsg_npfree_ep;
	logic [MAXNPTRGT:0]	tmsg_npclaim_ep;
	logic [MAXPCTRGT:0]	tmsg_pcput_ep;
	logic [MAXNPTRGT:0]	tmsg_npput_ep;
    logic [MAXPCTRGT:0]	tmsg_pcparity_ep;
	logic [MAXNPTRGT:0]	tmsg_npparity_ep;
	logic [MAXPCTRGT:0]	tmsg_pcmsgip_ep;
	logic [MAXNPTRGT:0]	tmsg_npmsgip_ep;
	logic [MAXPCTRGT:0]	tmsg_pceom_ep;
	logic [MAXNPTRGT:0]	tmsg_npeom_ep;
	 	
	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_pcpayload_ep;
	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_nppayload_ep;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCTRGT):0]	tmsg_pcpayload_ep;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPTRGT):0]	tmsg_nppayload_ep;
	 	
	logic [MAXPCTRGT:0]	tmsg_pccmpl_ep;
	logic [MAXNPTRGT:0]	tmsg_npvalid_ep;
	logic [MAXPCTRGT:0]	tmsg_pcvalid_ep;
	 	
	logic [MAXPCMSTR:0]	mmsg_pcirdy_ip;
	logic [MAXNPMSTR:0]	mmsg_npirdy_ip;
    logic [MAXPCMSTR:0]	mmsg_pcparity_ip;
	logic [MAXNPMSTR:0]	mmsg_npparity_ip;
	logic [MAXPCMSTR:0]	mmsg_pceom_ip;
	logic [MAXNPMSTR:0]	mmsg_npeom_ip;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCMSTR):0]	mmsg_pcpayload_ip;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPMSTR):0]	mmsg_nppayload_ip;
	logic [MAXPCMSTR:0]	mmsg_pctrdy_ip;
	logic [MAXNPMSTR:0]	mmsg_nptrdy_ip;
	logic [MAXPCMSTR:0]	mmsg_pcmsgip_ip;
	logic [MAXNPMSTR:0]	mmsg_npmsgip_ip;
	logic [MAXPCMSTR:0]	mmsg_pcsel_ip;
	logic [MAXNPMSTR:0]	mmsg_npsel_ip;
	 	
	logic [MAXPCTRGT:0]	tmsg_pcfree_ip;
	logic [MAXNPTRGT:0]	tmsg_npfree_ip;
	logic [MAXNPTRGT:0]	tmsg_npclaim_ip;
    logic [MAXNPTRGT:0]	tmsg_npclaim_ff;
	logic [MAXPCTRGT:0]	tmsg_pcput_ip;
	logic [MAXNPTRGT:0]	tmsg_npput_ip;
    logic [MAXPCTRGT:0]	tmsg_pcparity_ip;
	logic [MAXNPTRGT:0]	tmsg_npparity_ip;
	logic [MAXPCTRGT:0]	tmsg_pcmsgip_ip;
	logic [MAXNPTRGT:0]	tmsg_npmsgip_ip;
	logic [MAXPCTRGT:0]	tmsg_pceom_ip;
	logic [MAXNPTRGT:0]	tmsg_npeom_ip;
	 	
	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_pcpayload_ip;
	//logic [`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT):0]	tmsg_nppayload_ip;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXPCTRGT):0]	tmsg_pcpayload_ip;
	logic [`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,MAXNPTRGT):0]	tmsg_nppayload_ip;
	 	
	logic [MAXPCTRGT:0]	tmsg_pccmpl_ip;
	logic [MAXNPTRGT:0]	tmsg_npvalid_ip;
	logic [MAXPCTRGT:0]	tmsg_pcvalid_ip;


    logic 				tmsg_pcput_inter;
    logic 				tmsg_npput_inter;
    logic               tmsg_pcparity_inter;
    logic               tmsg_npparity_inter;
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
    
    parameter EQUAL_BIT = (MAXNPMSTR == MAXPCMSTR)&&(MAXPCTRGT == MAXNPTRGT)&&(MAXNPMSTR == MAXPCTRGT);
 // Instantiate DUT(IP_VC-DUT-FABRIC_VC)

//***************************************************
generate
       if (IS_RATA_ENV) begin
`ifdef IS_TRGTREG
            sbetrgtreg #( // lintra s-80018
`else
            sbebulkrdwrwrapper #( // lintra s-80018
`endif			  
            .INTERNALPLDBIT        ( `PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT)),
            .SB_PARITY_REQUIRED    ( SB_PARITY_REQUIRED    ),
            .MAXTRGTADDR           ( MAXTRGTADDR           ),
            .MAXTRGTDATA           ( MAXTRGTDATA           ),
            .RX_EXT_HEADER_SUPPORT ( RX_EXT_HEADER_SUPPORT ),
            .NUM_RX_EXT_HEADERS    ( NUM_RX_EXT_HEADERS    ),
            .RX_EXT_HEADER_IDS     ( RX_EXT_HEADER_IDS     ),
            .NUM_TX_EXT_HEADERS    ( NUM_TX_EXT_HEADERS    ),
            .TX_EXT_HEADER_SUPPORT ( TX_EXT_HEADER_SUPPORT ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
            .UNIQUE_EXT_HEADERS    ( UNIQUE_EXT_HEADERS    ),
            .RSWIDTH               ( RSWIDTH               ),
            .SAIWIDTH              ( SAIWIDTH              ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
// Hier Bridge PCR
            .GLOBAL_EP_IS_STRAP   ( GLOBAL_EP_IS_STRAP      ),
            .GLOBAL_EP            ( GLOBAL_EP               )
            ) sbetrgtreg (
            .side_clk       ( gated_clk),
		    .side_rst_b     ( endpoint_reset && rst_b),
//		    .idle_trgtreg   ( idle_trgtreg                                     ),
`ifdef IS_TRGTREG
		    .sbe_sbi_idle   ( 'b0),
`else
		    .parity_err_from_base   ( 'b0),			  
`endif

		    .cfg_parityckdef( ep_intf.parity_defeature),
		    .ext_parity_err_detected  ( ep_intf.ext_parity_err_det),
//		    .treg_tmsg_parity_err_det ( treg_tmsg_parity_err_det               ),
		    .global_ep_strap( ep_intf.global_ep_strap),
		    .tmsg_pcput     ( ep_intf.tmsg_pcput),
		    .tmsg_npput     ( ep_intf.tmsg_npput),
		    .tmsg_pcmsgip   ( ep_intf.tmsg_pcmsgip),
		    .tmsg_npmsgip   ( ep_intf.tmsg_npmsgip),
		    .tmsg_pceom     ( ep_intf.tmsg_pceom),
		    .tmsg_npeom     ( ep_intf.tmsg_npeom),
		    .tmsg_pcpayload ( ep_intf.tmsg_pcpayload                              ),
		    .tmsg_nppayload ( ep_intf.tmsg_nppayload                               ),
		    .tmsg_pcparity  ( ep_intf.tmsg_pcparity                                ),
		    .tmsg_npparity  ( ep_intf.tmsg_npparity                                ),
		    .tmsg_pcfree    ( ep_intf.tmsg_pcfree[MAXPCTRGT:0]),
		    .tmsg_npfree    ( ep_intf.tmsg_npfree[MAXNPTRGT:0]),
		    .tmsg_npclaim   ( ep_intf.tmsg_npclaim[MAXNPTRGT:0]),
		    .mmsg_pcsel     ( ep_intf.mmsg_pcsel),
		    .mmsg_pctrdy    ( ep_intf.mmsg_pctrdy                              ),
			.mmsg_pcirdy    ( ep_intf.mmsg_pcirdy                         ),
			.mmsg_pceom     ( ep_intf.mmsg_pceom                           ),
			.mmsg_pcpayload ( ep_intf.mmsg_pcpayload                       ),
			.mmsg_pcparity  ( ep_intf.mmsg_pcparity                        ),
			.treg_trdy      ( ep_intf.treg_trdy),
			.treg_cerr      ( ep_intf.treg_cerr                                        ),
			.treg_rdata     ( ep_intf.treg_rdata[MAXTRGTDATA:0]),
			.treg_irdy      ( ep_intf.treg_irdy                                        ),
			.treg_np        ( ep_intf.treg_np                                          ),
			.treg_dest      ( ep_intf.treg_dest                                        ),
			.treg_source    ( ep_intf.treg_source                                      ),
			.treg_opcode    ( ep_intf.treg_opcode                                      ),
			.treg_addrlen   ( ep_intf.treg_addrlen                                     ),
			.treg_bar       ( ep_intf.treg_bar                                         ),
			.treg_tag       ( ep_intf.treg_tag                                         ),
			.treg_be        ( ep_intf.treg_be[`SBEREGB(MAXTRGTDATA):0]),
			.treg_fid       ( ep_intf.treg_fid                                         ),
			.treg_addr      ( ep_intf.treg_addr                                        ),
			.treg_wdata     ( ep_intf.treg_wdata[MAXTRGTDATA:0]),
			.treg_eh        ( ep_intf.treg_eh                                          ),
			.treg_ext_header( ep_intf.treg_ext_header                                  ),
			.treg_eh_discard( ep_intf.treg_eh_discard                                  ),
			// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
			.treg_csairs_valid  ( ep_intf.treg_csairs_valid                              ),
			.treg_csai          ( ep_intf.treg_csai                                      ),
			.treg_crs           ( ep_intf.treg_crs                                       ),
			.treg_rx_sairs_valid( ep_intf.treg_rx_sairs_valid                            ),
			.treg_rx_sai        ( ep_intf.treg_rx_sai                                    ),
			.treg_rx_rs         ( ep_intf.treg_rx_rs                                     ),
         // PCR 1409167250 RATA Completion Blocking
         //.treg_hold_cmp      ( ep_intf.treg_hold_cmp                                  ),
			// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
			.tx_ext_headers ( ep_intf.tx_ext_headers                                   ),
			// Hier Header PCR
			.tmsg_hdr_pcpayload  ( 'b0),
			.tmsg_hdr_pcput      ( 'b0),
			.tmsg_hdr_pcmsgip    ( 'b0),
			.tmsg_hdr_pceom      ( 'b0),
			.tmsg_hdr_pcparity   ( 'b0),
			.tmsg_hdr_nppayload  ( 'b0),
			.tmsg_hdr_npput      ( 'b0),
			.tmsg_hdr_npmsgip    ( 'b0),
			.tmsg_hdr_npeom      ( 'b0),
			.tmsg_hdr_npparity   ( 'b0),
			.treg_hier_destid    ( ep_intf.treg_hier_dest                              ),
			.treg_hier_srcid     ( ep_intf.treg_hier_source                               )
//			.np_hier_destid      ( np_hier_destid_trgtreg                        ),
//			.np_hier_srcid       ( np_hier_srcid_trgtreg                         ),
//			.dbgbus         ( dbg_trgt                                         )
            );


       end
       else begin

hqm_sbendpoint#(
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
  .RELATIVE_PLACEMENT_EN(RELATIVE_PLACEMENT_EN),
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
  .CLAIM_DELAY(TOTAL_CLAIM_DELAY),
  .CLKREQDEFAULT (CLKREQDEFAULT),
  .SB_PARITY_REQUIRED(SB_PARITY_REQUIRED),
  .DO_SERR_MASTER(DO_SERR_MASTER),
  .GLOBAL_EP(GLOBAL_EP),
  .GLOBAL_EP_IS_STRAP(GLOBAL_EP_IS_STRAP),
  .BULKRDWR(BULKRDWR),
  .BULK_PERF(BULK_PERF)
)                                        
hqm_sbendpoint (                                    
  .side_clk ( gated_side_clk),
  .side_rst_b ( endpoint_reset && rst_b),
                                     
  .agent_clk(gated_clk),
  //.agent_rst_b(reset1),     

  .usyncselect(ep_intf.usync_sel),
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
                                                                    
  .tmsg_pcfree(tmsg_pcfree_ep),
  .tmsg_npfree(tmsg_npfree_ep),
  .tmsg_npclaim(tmsg_npclaim_ep),
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
  .tmsg_pcparity(tmsg_pcparity_inter),
  .tmsg_npparity(tmsg_npparity_inter),

  .ur_csairs_valid  ( ep_intf.ur_csairs_valid ),
  .ur_csai          ( ep_intf.ur_csai),
  .ur_crs           ( ep_intf.ur_crs),
  .ur_rx_sairs_valid( ep_intf.ur_rx_sairs_valid),
  .ur_rx_sai        ( ep_intf.ur_rx_sai),
  .ur_rx_rs         ( ep_intf.ur_rx_rs),
                                     
  .mmsg_pcirdy(mmsg_pcirdy_ep),
  .mmsg_npirdy(mmsg_npirdy_ep),
  .mmsg_pceom(mmsg_pceom_ep),
  .mmsg_npeom(mmsg_npeom_ep),
  .mmsg_pcpayload(mmsg_pcpayload_ep),
  .mmsg_nppayload (mmsg_nppayload_ep),
  .mmsg_pctrdy(mmsg_pctrdy_inter),
  .mmsg_nptrdy(mmsg_nptrdy_inter),
  .mmsg_pcmsgip(mmsg_pcmsgip_inter),
  .mmsg_npmsgip(mmsg_npmsgip_inter),
  .mmsg_pcsel(mmsg_pcsel_ep),
  .mmsg_npsel(mmsg_npsel_ep),
  .mmsg_pcparity(mmsg_pcparity_ep),
  .mmsg_npparity(mmsg_npparity_ep),

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
  .treg_ext_header(ep_intf.treg_ext_header),
  .treg_eh_discard(ep_intf.treg_eh_discard),                                              
  .treg_csairs_valid(ep_intf.treg_csairs_valid),
  .treg_csai(ep_intf.treg_csai),
  .treg_crs(ep_intf.treg_crs),
  .treg_rx_sairs_valid(ep_intf.treg_rx_sairs_valid),
  .treg_rx_sai        (ep_intf.treg_rx_sai),
  .treg_rx_rs         (ep_intf.treg_rx_rs ),
  .treg_hier_destid(ep_intf.treg_hier_dest),
  .treg_hier_srcid(ep_intf.treg_hier_source),
  // PCR 1409167250 RATA Completion Blocking
  //.treg_hold_cmp(ep_intf.treg_hold_cmp),
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
  .mreg_hier_destid(ep_intf.mreg_hier_dest),
  .mreg_hier_srcid(ep_intf.mreg_hier_source),
  .do_serr_srcid_strap(ep_intf.srcid_strap),
  .do_serr_dstid_strap(ep_intf.dstid_strap),
  .do_serr_hier_srcid_strap(ep_intf.hier_srcid_strap),
  .do_serr_hier_dstid_strap(ep_intf.hier_dstid_strap),
  .do_serr_tag_strap(ep_intf.tag_strap),
  .global_ep_strap  (ep_intf.global_ep_strap),
  .do_serr_sairs_valid(ep_intf.sairs_valid_strap),
  .do_serr_sai(ep_intf.sai_strap),
  .do_serr_rs(ep_intf.rs_strap),
  .sbe_parity_err_out(ep_intf.parity_err_out),
  .ext_parity_err_detected(ep_intf.ext_parity_err_det),
  .fdfx_sbparity_def(ep_intf.parity_defeature),

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
       end
endgenerate

//***************************************************

generate 
	for( loop = 0 ; loop < MAXPCTRGT+(IS_RATA_ENV?0:1) ; loop++) begin
        assign tmsg_pcput_ep[loop] = tmsg_pcput_inter; 
        assign tmsg_pcparity_ep[loop] = tmsg_pcparity_inter;
        assign tmsg_pcmsgip_ep[loop] = tmsg_pcmsgip_inter;
        assign tmsg_pceom_ep[loop] = tmsg_pceom_inter;
        assign tmsg_pccmpl_ep[loop] = tmsg_pccmpl_inter;
        assign tmsg_pcvalid_ep[loop] = tmsg_pcvalid_inter;
        assign tmsg_pcpayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop)] = tmsg_pcpayload_inter;
    end
endgenerate

generate 
	for( loop = 0 ; loop < MAXNPTRGT+(IS_RATA_ENV?0:1) ; loop++) begin
        assign tmsg_npput_ep[loop] = tmsg_npput_inter;
        assign tmsg_npparity_ep[loop] = tmsg_npparity_inter;
        assign tmsg_npmsgip_ep[loop] = tmsg_npmsgip_inter;
        assign tmsg_npeom_ep[loop] = tmsg_npeom_inter;
        assign tmsg_npvalid_ep[loop] = tmsg_npvalid_inter;
        assign tmsg_nppayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,loop)] = tmsg_nppayload_inter;
    end
endgenerate

generate 
	for( loop = 0 ; loop < MAXPCMSTR+(IS_RATA_ENV?0:1) ; loop++) begin
        assign mmsg_pctrdy_ep[loop] = mmsg_pctrdy_inter;
        assign mmsg_pcmsgip_ep[loop] = mmsg_pcmsgip_inter;
    end
endgenerate

generate 
	for( loop = 0 ; loop < MAXNPMSTR+(IS_RATA_ENV?0:1) ; loop++) begin
        assign mmsg_nptrdy_ep[loop] = mmsg_nptrdy_inter;
        assign mmsg_npmsgip_ep[loop] = mmsg_npmsgip_inter;
    end
endgenerate

//***************************************************
generate
  if (!IS_RATA_ENV) begin

assign	mmsg_pcirdy_ip = ep_intf.mmsg_pcirdy;
assign	mmsg_npirdy_ip = ep_intf.mmsg_npirdy;
assign	mmsg_pcparity_ip = ep_intf.mmsg_pcparity;
assign	mmsg_npparity_ip = ep_intf.mmsg_npparity;
assign	mmsg_pceom_ip = ep_intf.mmsg_pceom;
assign	mmsg_npeom_ip = ep_intf.mmsg_npeom; 
assign	mmsg_pcpayload_ip = ep_intf.mmsg_pcpayload.payload;
assign	mmsg_nppayload_ip = ep_intf.mmsg_nppayload.payload;
assign	ep_intf.mmsg_pctrdy = mmsg_pctrdy_ip; 
assign  ep_intf.mmsg_nptrdy = mmsg_nptrdy_ip;
assign  ep_intf.mmsg_pcmsgip = mmsg_pcmsgip_ip;
assign  ep_intf.mmsg_npmsgip = mmsg_npmsgip_ip;
assign  ep_intf.mmsg_pcsel = mmsg_pcsel_ip;
assign  ep_intf.mmsg_npsel = mmsg_npsel_ip;


assign  ep_intf.tmsg_pcvalid = tmsg_pcvalid_ip;
assign  ep_intf.tmsg_npvalid = tmsg_npvalid_ip;
assign	tmsg_pcfree_ip = ep_intf.tmsg_pcfree;
assign	tmsg_npfree_ip = ep_intf.tmsg_npfree;
assign  tmsg_npclaim_ip = tmsg_npclaim_ff;
assign	ep_intf.tmsg_pcput = tmsg_pcput_ip;
assign	ep_intf.tmsg_npput = tmsg_npput_ip;
assign	ep_intf.tmsg_pcparity = tmsg_pcparity_ip;
assign	ep_intf.tmsg_npparity = tmsg_npparity_ip;
assign	ep_intf.tmsg_pcmsgip = tmsg_pcmsgip_ip;
assign  ep_intf.tmsg_npmsgip = tmsg_npmsgip_ip;
assign  ep_intf.tmsg_pceom = tmsg_pceom_ip;
assign  ep_intf.tmsg_npeom = tmsg_npeom_ip;
assign  ep_intf.tmsg_pcpayload = tmsg_pcpayload_ip;
assign	ep_intf.tmsg_nppayload = tmsg_nppayload_ip;
assign	ep_intf.tmsg_pccmpl = tmsg_pccmpl_ip;
  end
  else begin
assign	ep_intf.sbe_clkreq = 1;
// Disable tmsg_npvalid assertions (vr_ep_0073_prop in ep_base_chk_sig_ph2.svh) ; not implemented as sbtrgtreg does not use it
assign  ep_intf.tmsg_npvalid = 1;
assign  ep_intf.msg_intf.tmsg_npvalid = 1;
  end
endgenerate

//***************************************************
//npclaim repeater

    claim_rp #(
        .WIDTH(MAXNPTRGT),
        .NUM_REPEATER_FLOPS(`CLAIM_RP(VARIABLE_CLAIM_DELAY, NUM_CLAIM_REPEATER)))        
    i_claim_rp (
        .clk(ccu_if.clk[1]),
        .rst(endpoint_reset && rst_b),
        .tmsg_npclaim_in(ep_intf.tmsg_npclaim),
        .tmsg_npclaim_out(tmsg_npclaim_ff));            

//****************************************************
//instantiation of repeater
//****************************************************

generate
  if (!IS_RATA_ENV) begin
    if(EQUAL_BIT) begin
        for(agt = 0; agt < MAXPCMSTR + 1; agt++) begin
            rpt_module_wrap #(
            .INTERNALPLDBIT(`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT)),
            .MOD_NAME(0),
            .NUM_REPEATER_FLOPS(`CAL_FLOP (agt,NUM_REPEATER_FLOPS)))
            i_rpt_module_wrap (
            .clk(ccu_if.clk[1]),
            .rst(endpoint_reset && rst_b),
			.mmsg_pcirdy_ep (mmsg_pcirdy_ep[agt]),
			.mmsg_npirdy_ep (mmsg_npirdy_ep[agt]),
            .mmsg_pcparity_ep (mmsg_pcparity_ep[agt]),
			.mmsg_npparity_ep (mmsg_npparity_ep[agt]),
			.mmsg_pceom_ep (mmsg_pceom_ep[agt]),
			.mmsg_npeom_ep (mmsg_npeom_ep[agt]),
			.mmsg_pcpayload_ep (mmsg_pcpayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.mmsg_nppayload_ep (mmsg_nppayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.mmsg_pctrdy_ip (mmsg_pctrdy_ip[agt]),
			.mmsg_nptrdy_ip (mmsg_nptrdy_ip[agt]),
			.mmsg_pcmsgip_ip (mmsg_pcmsgip_ip[agt]),
			.mmsg_npmsgip_ip (mmsg_npmsgip_ip[agt]),
			.mmsg_pcsel_ip (mmsg_pcsel_ip[agt]),
			.mmsg_npsel_ip (mmsg_npsel_ip[agt]),
			
			.tmsg_pcfree_ep (tmsg_pcfree_ep[agt]),
			.tmsg_npfree_ep (tmsg_npfree_ep[agt]),
			.tmsg_npclaim_ep (tmsg_npclaim_ep[agt]),
			.tmsg_pcput_ip (tmsg_pcput_ip[agt]),
			.tmsg_npput_ip (tmsg_npput_ip[agt]),
            .tmsg_pcparity_ip (tmsg_pcparity_ip[agt]),
			.tmsg_npparity_ip (tmsg_npparity_ip[agt]),
			.tmsg_pcmsgip_ip (tmsg_pcmsgip_ip[agt]),
			.tmsg_npmsgip_ip (tmsg_npmsgip_ip[agt]),
			.tmsg_pceom_ip (tmsg_pceom_ip[agt]),
			.tmsg_npeom_ip (tmsg_npeom_ip[agt]),
			.tmsg_pcpayload_ip (tmsg_pcpayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_nppayload_ip (tmsg_nppayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_pccmpl_ip (tmsg_pccmpl_ip[agt]),
			.tmsg_npvalid_ip (tmsg_npvalid_ip[agt]),
			.tmsg_pcvalid_ip (tmsg_pcvalid_ip[agt]),
			
			.mmsg_pctrdy_ep (mmsg_pctrdy_ep[agt]),
			.mmsg_nptrdy_ep (mmsg_nptrdy_ep[agt]),
			.mmsg_pcmsgip_ep (mmsg_pcmsgip_ep[agt]),
			.mmsg_npmsgip_ep (mmsg_npmsgip_ep[agt]),
			.mmsg_pcsel_ep (mmsg_pcsel_ep[agt]),
			.mmsg_npsel_ep (mmsg_npsel_ep[agt]),
			.mmsg_pcirdy_ip (mmsg_pcirdy_ip[agt]),
			.mmsg_npirdy_ip (mmsg_npirdy_ip[agt]),
            .mmsg_pcparity_ip (mmsg_pcparity_ip[agt]),
			.mmsg_npparity_ip (mmsg_npparity_ip[agt]),
			.mmsg_pceom_ip (mmsg_pceom_ip[agt]),
			.mmsg_npeom_ip (mmsg_npeom_ip[agt]),
			.mmsg_pcpayload_ip (mmsg_pcpayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.mmsg_nppayload_ip (mmsg_nppayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			
			.tmsg_pcput_ep (tmsg_pcput_ep[agt]),
			.tmsg_npput_ep (tmsg_npput_ep[agt]),
            .tmsg_pcparity_ep (tmsg_pcparity_ep[agt]),
			.tmsg_npparity_ep (tmsg_npparity_ep[agt]),
			.tmsg_pcmsgip_ep (tmsg_pcmsgip_ep[agt]),
			.tmsg_npmsgip_ep (tmsg_npmsgip_ep[agt]),
			.tmsg_pceom_ep (tmsg_pceom_ep[agt]),
			.tmsg_npeom_ep (tmsg_npeom_ep[agt]),
			.tmsg_pcpayload_ep (tmsg_pcpayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_nppayload_ep (tmsg_nppayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_pccmpl_ep (tmsg_pccmpl_ep[agt]),
			.tmsg_npvalid_ep (tmsg_npvalid_ep[agt]),
			.tmsg_pcvalid_ep (tmsg_pcvalid_ep[agt]),
			.tmsg_pcfree_ip (tmsg_pcfree_ip[agt]),
			.tmsg_npfree_ip (tmsg_npfree_ip[agt]),
			.tmsg_npclaim_ip (tmsg_npclaim_ip[agt])
			);
            
        end
    end
    else begin
        for(agt = 0; agt < MAXNPMSTR + 1; agt++) begin
            rpt_module_wrap #(
            .INTERNALPLDBIT(`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT)),
            .MOD_NAME(0),
            .NUM_REPEATER_FLOPS(`CAL_FLOP (agt,NUM_REPEATER_FLOPS)))
            rpt_module_npmstr (
            .clk(ccu_if.clk[1]),
            .rst(endpoint_reset && rst_b),
			.mmsg_pcirdy_ep (),
			.mmsg_npirdy_ep (mmsg_npirdy_ep[agt]),
            .mmsg_pcparity_ep (),
			.mmsg_npparity_ep (mmsg_npparity_ep[agt]),
			.mmsg_pceom_ep (),
			.mmsg_npeom_ep (mmsg_npeom_ep[agt]),
			.mmsg_pcpayload_ep (),
			.mmsg_nppayload_ep (mmsg_nppayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.mmsg_pctrdy_ip (),
			.mmsg_nptrdy_ip (mmsg_nptrdy_ip[agt]),
			.mmsg_pcmsgip_ip (),
			.mmsg_npmsgip_ip (mmsg_npmsgip_ip[agt]),
			.mmsg_pcsel_ip (),
			.mmsg_npsel_ip (mmsg_npsel_ip[agt]),
			
			.tmsg_pcfree_ep (),
			.tmsg_npfree_ep (),
			.tmsg_npclaim_ep (),
			.tmsg_pcput_ip (),
			.tmsg_npput_ip (),
            .tmsg_pcparity_ip (),
			.tmsg_npparity_ip (),
			.tmsg_pcmsgip_ip (),
			.tmsg_npmsgip_ip (),
			.tmsg_pceom_ip (),
			.tmsg_npeom_ip (),
			.tmsg_pcpayload_ip (),
			.tmsg_nppayload_ip (),
			.tmsg_pccmpl_ip (),
			.tmsg_npvalid_ip (),
			.tmsg_pcvalid_ip (),
			
			.mmsg_pctrdy_ep (1'b0),
			.mmsg_nptrdy_ep (mmsg_nptrdy_ep[agt]),
			.mmsg_pcmsgip_ep (1'b0),
			.mmsg_npmsgip_ep (mmsg_npmsgip_ep[agt]),
			.mmsg_pcsel_ep (1'b0),
			.mmsg_npsel_ep (mmsg_npsel_ep[agt]),
			.mmsg_pcirdy_ip (1'b0),
			.mmsg_npirdy_ip (mmsg_npirdy_ip[agt]),
            .mmsg_pcparity_ip (1'b0),
			.mmsg_npparity_ip (mmsg_npparity_ip[agt]),
			.mmsg_pceom_ip (1'b0),
			.mmsg_npeom_ip (mmsg_npeom_ip[agt]),
			.mmsg_pcpayload_ip ('h0),
			.mmsg_nppayload_ip (mmsg_nppayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			
			.tmsg_pcput_ep (1'b0),
			.tmsg_npput_ep (1'b0),
            .tmsg_pcparity_ep (1'b0),
			.tmsg_npparity_ep (1'b0),
			.tmsg_pcmsgip_ep (1'b0),
			.tmsg_npmsgip_ep (1'b0),
			.tmsg_pceom_ep (1'b0),
			.tmsg_npeom_ep (1'b0),
			.tmsg_pcpayload_ep ('h0),
			.tmsg_nppayload_ep ('h0),
			.tmsg_pccmpl_ep (1'b0),
			.tmsg_npvalid_ep (1'b0),
			.tmsg_pcvalid_ep (1'b0),
			.tmsg_pcfree_ip (1'b0),
			.tmsg_npfree_ip (1'b0),
			.tmsg_npclaim_ip (1'b0)
			);
            
        end
        
        for(agt = 0; agt < MAXPCMSTR + 1; agt++) begin
            rpt_module_wrap #(
            .INTERNALPLDBIT(`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT)),
            .MOD_NAME(0),
            .NUM_REPEATER_FLOPS(`CAL_FLOP (agt,NUM_REPEATER_FLOPS)))
            rpt_module_pcmstr (
            .clk(ccu_if.clk[1]),
            .rst(endpoint_reset && rst_b),
			.mmsg_pcirdy_ep (mmsg_pcirdy_ep[agt]),
			.mmsg_npirdy_ep (),
            .mmsg_pcparity_ep (mmsg_pcparity_ep[agt]),
			.mmsg_npparity_ep (),
			.mmsg_pceom_ep (mmsg_pceom_ep[agt]),
			.mmsg_npeom_ep (),
			.mmsg_pcpayload_ep (mmsg_pcpayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.mmsg_nppayload_ep (),
			.mmsg_pctrdy_ip (mmsg_pctrdy_ip[agt]),
			.mmsg_nptrdy_ip (),
			.mmsg_pcmsgip_ip (mmsg_pcmsgip_ip[agt]),
			.mmsg_npmsgip_ip (),
			.mmsg_pcsel_ip (mmsg_pcsel_ip[agt]),
			.mmsg_npsel_ip (),
			
			.tmsg_pcfree_ep (),
			.tmsg_npfree_ep (),
			.tmsg_npclaim_ep (),
			.tmsg_pcput_ip (),
			.tmsg_npput_ip (),
            .tmsg_pcparity_ip (),
			.tmsg_npparity_ip (),
			.tmsg_pcmsgip_ip (),
			.tmsg_npmsgip_ip (),
			.tmsg_pceom_ip (),
			.tmsg_npeom_ip (),
			.tmsg_pcpayload_ip (),
			.tmsg_nppayload_ip (),
			.tmsg_pccmpl_ip (),
			.tmsg_npvalid_ip (),
			.tmsg_pcvalid_ip (),
			
			.mmsg_pctrdy_ep (mmsg_pctrdy_ep[agt]),
			.mmsg_nptrdy_ep (1'b0),
			.mmsg_pcmsgip_ep (mmsg_pcmsgip_ep[agt]),
			.mmsg_npmsgip_ep (1'b0),
			.mmsg_pcsel_ep (mmsg_pcsel_ep[agt]),
			.mmsg_npsel_ep (1'b0),
			.mmsg_pcirdy_ip (mmsg_pcirdy_ip[agt]),
			.mmsg_npirdy_ip (1'b0),
            .mmsg_pcparity_ip (mmsg_pcparity_ip[agt]),
			.mmsg_npparity_ip (1'b0),
			.mmsg_pceom_ip (mmsg_pceom_ip[agt]),
			.mmsg_npeom_ip (1'b0),
			.mmsg_pcpayload_ip (mmsg_pcpayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.mmsg_nppayload_ip ('h0),
			
			.tmsg_pcput_ep (1'b0),
			.tmsg_npput_ep (1'b0),
            .tmsg_pcparity_ep (1'b0),
			.tmsg_npparity_ep (1'b0),
			.tmsg_pcmsgip_ep (1'b0),
			.tmsg_npmsgip_ep (1'b0),
			.tmsg_pceom_ep (1'b0),
			.tmsg_npeom_ep (1'b0),
			.tmsg_pcpayload_ep ('h0),
			.tmsg_nppayload_ep ('h0),
			.tmsg_pccmpl_ep (1'b0),
			.tmsg_npvalid_ep (1'b0),
			.tmsg_pcvalid_ep (1'b0),
			.tmsg_pcfree_ip (1'b0),
			.tmsg_npfree_ip (1'b0),
			.tmsg_npclaim_ip (1'b0)
			);
            
        end
        
        for(agt = 0; agt < MAXNPTRGT + 1; agt++) begin
            rpt_module_wrap #(
            .INTERNALPLDBIT(`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT)),
            .MOD_NAME(0),
            .NUM_REPEATER_FLOPS(`CAL_FLOP (agt,NUM_REPEATER_FLOPS)))
            rpt_module_nptrgt (
            .clk(ccu_if.clk[1]),
            .rst(endpoint_reset && rst_b),
			.mmsg_pcirdy_ep (),
			.mmsg_npirdy_ep (),
            .mmsg_pcparity_ep (),
			.mmsg_npparity_ep (),
			.mmsg_pceom_ep (),
			.mmsg_npeom_ep (),
			.mmsg_pcpayload_ep (),
			.mmsg_nppayload_ep (),
			.mmsg_pctrdy_ip (),
			.mmsg_nptrdy_ip (),
			.mmsg_pcmsgip_ip (),
			.mmsg_npmsgip_ip (),
			.mmsg_pcsel_ip (),
			.mmsg_npsel_ip (),
			
			.tmsg_pcfree_ep (),
			.tmsg_npfree_ep (tmsg_npfree_ep[agt]),
			.tmsg_npclaim_ep (tmsg_npclaim_ep[agt]),
			.tmsg_pcput_ip (),
			.tmsg_npput_ip (tmsg_npput_ip[agt]),
            .tmsg_pcparity_ip (),
			.tmsg_npparity_ip (tmsg_npparity_ip[agt]),
			.tmsg_pcmsgip_ip (),
			.tmsg_npmsgip_ip (tmsg_npmsgip_ip[agt]),
			.tmsg_pceom_ip (),
			.tmsg_npeom_ip (tmsg_npeom_ip[agt]),
			.tmsg_pcpayload_ip (),
			.tmsg_nppayload_ip (tmsg_nppayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_pccmpl_ip (),
			.tmsg_npvalid_ip (tmsg_npvalid_ip[agt]),
			.tmsg_pcvalid_ip (),
			
			.mmsg_pctrdy_ep (1'b0),
			.mmsg_nptrdy_ep (1'b0),
			.mmsg_pcmsgip_ep (1'b0),
			.mmsg_npmsgip_ep (1'b0),
			.mmsg_pcsel_ep (1'b0),
			.mmsg_npsel_ep (1'b0),
			.mmsg_pcirdy_ip (1'b0),
			.mmsg_npirdy_ip (1'b0),
            .mmsg_pcparity_ip (1'b0),
			.mmsg_npparity_ip (1'b0),
			.mmsg_pceom_ip (1'b0),
			.mmsg_npeom_ip (1'b0),
			.mmsg_pcpayload_ip ('h0),
			.mmsg_nppayload_ip ('h0),
			
			.tmsg_pcput_ep (1'b0),
			.tmsg_npput_ep (tmsg_npput_ep[agt]),
            .tmsg_pcparity_ep (1'b0),
			.tmsg_npparity_ep (tmsg_npparity_ep[agt]),
			.tmsg_pcmsgip_ep (1'b0),
			.tmsg_npmsgip_ep (tmsg_npmsgip_ep[agt]),
			.tmsg_pceom_ep (1'b0),
			.tmsg_npeom_ep (tmsg_npeom_ep[agt]),
			.tmsg_pcpayload_ep ('h0),
			.tmsg_nppayload_ep (tmsg_nppayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_pccmpl_ep (1'b0),
			.tmsg_npvalid_ep (tmsg_npvalid_ep[agt]),
			.tmsg_pcvalid_ep (1'b0),
			.tmsg_pcfree_ip (1'b0),
			.tmsg_npfree_ip (tmsg_npfree_ip[agt]),
			.tmsg_npclaim_ip (tmsg_npclaim_ip[agt])
			);
            
        end
        
        for(agt = 0; agt < MAXPCTRGT + 1; agt++) begin
            rpt_module_wrap #(
            .INTERNALPLDBIT(`PLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT)),
            .MOD_NAME(0),
            .NUM_REPEATER_FLOPS(`CAL_FLOP (agt,NUM_REPEATER_FLOPS)))
            rpt_module_pctrgt (
            .clk(ccu_if.clk[1]),
            .rst(endpoint_reset && rst_b),
			.mmsg_pcirdy_ep (),
			.mmsg_npirdy_ep (),
            .mmsg_pcparity_ep (),
			.mmsg_npparity_ep (),
			.mmsg_pceom_ep (),
			.mmsg_npeom_ep (),
			.mmsg_pcpayload_ep (),
			.mmsg_nppayload_ep (),
			.mmsg_pctrdy_ip (),
			.mmsg_nptrdy_ip (),
			.mmsg_pcmsgip_ip (),
			.mmsg_npmsgip_ip (),
			.mmsg_pcsel_ip (),
			.mmsg_npsel_ip (),
			
			.tmsg_pcfree_ep (tmsg_pcfree_ep[agt]),
			.tmsg_npfree_ep (),
			.tmsg_npclaim_ep (),
			.tmsg_pcput_ip (tmsg_pcput_ip[agt]),
			.tmsg_npput_ip (),
            .tmsg_pcparity_ip (tmsg_pcparity_ip[agt]),
			.tmsg_npparity_ip (),
			.tmsg_pcmsgip_ip (tmsg_pcmsgip_ip[agt]),
			.tmsg_npmsgip_ip (),
			.tmsg_pceom_ip (tmsg_pceom_ip[agt]),
			.tmsg_npeom_ip (),
			.tmsg_pcpayload_ip (tmsg_pcpayload_ip[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_nppayload_ip (),
			.tmsg_pccmpl_ip (tmsg_pccmpl_ip[agt]),
			.tmsg_npvalid_ip (),
			.tmsg_pcvalid_ip (tmsg_pcvalid_ip[agt]),
			
			.mmsg_pctrdy_ep (1'b0),
			.mmsg_nptrdy_ep (1'b0),
			.mmsg_pcmsgip_ep (1'b0),
			.mmsg_npmsgip_ep (1'b0),
			.mmsg_pcsel_ep (1'b0),
			.mmsg_npsel_ep (1'b0),
			.mmsg_pcirdy_ip (1'b0),
			.mmsg_npirdy_ip (1'b0),
            .mmsg_pcparity_ip (1'b0),
			.mmsg_npparity_ip (1'b0),
			.mmsg_pceom_ip (1'b0),
			.mmsg_npeom_ip (1'b0),
			.mmsg_pcpayload_ip ('h0),
			.mmsg_nppayload_ip ('h0),
			
			.tmsg_pcput_ep (tmsg_pcput_ep[agt]),
			.tmsg_npput_ep (1'b0),
            .tmsg_pcparity_ep (tmsg_pcparity_ep[agt]),
			.tmsg_npparity_ep (1'b0),
			.tmsg_pcmsgip_ep (tmsg_pcmsgip_ep[agt]),
			.tmsg_npmsgip_ep (1'b0),
			.tmsg_pceom_ep (tmsg_pceom_ep[agt]),
			.tmsg_npeom_ep (1'b0),
			.tmsg_pcpayload_ep (tmsg_pcpayload_ep[`MPLDW(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt):`LBWCAL(MATCHED_INTERNAL_WIDTH,MAXPLDBIT,agt)]),
			.tmsg_nppayload_ep ('h0),
			.tmsg_pccmpl_ep (tmsg_pccmpl_ep[agt]),
			.tmsg_npvalid_ep (1'b0),
			.tmsg_pcvalid_ep (tmsg_pcvalid_ep[agt]),
			.tmsg_pcfree_ip (tmsg_pcfree_ip[agt]),
			.tmsg_npfree_ip (1'b0),
			.tmsg_npclaim_ip (1'b0)
			);
            
        end

    end
  end
endgenerate

//****************************************************


//****************************************************
generate
       if (!IS_RATA_ENV) begin

	property sbe_comp_exp_prop;
		@(posedge hqm_sbendpoint.side_clk)
		disable iff (hqm_sbendpoint.side_rst_b !== 1'b1) 
		(hqm_sbendpoint.sbe_comp_exp == 1'b1 && ISM_COMPLETION_FENCING) |-> ##[1:7] (hqm_sbendpoint.side_ism_fabric == 3 && hqm_sbendpoint.side_ism_agent == 3);
	endproperty: sbe_comp_exp_prop

	assert property (sbe_comp_exp_prop)
	else begin
		string msg;
        $sformat(msg, {"%m: ERROR ISM are toggled",
                 "while sbe_comp_exp is asserted and ISM_COMPLETION_FENCING is setting to one."});
        $error("PCR007", msg);

	end

//****************************************************
localparam RATIO = (FAB_CLK_PERIOD > AGT_CLK_PERIOD) ? ((FAB_CLK_PERIOD/AGT_CLK_PERIOD) + 1) : ((AGT_CLK_PERIOD > FAB_CLK_PERIOD) ? ((AGT_CLK_PERIOD/FAB_CLK_PERIOD) + 1 ) : 1);

    property parity_err_out_prop;
        @(posedge hqm_sbendpoint.agent_clk)
		disable iff (hqm_sbendpoint.side_rst_b !== 1'b1) 
		$rose((hqm_sbendpoint.ext_parity_err_detected == 1'b1 || fabric_intf.tparity_error) && SB_PARITY_REQUIRED && (hqm_sbendpoint.fdfx_sbparity_def == 0) && (hqm_sbendpoint.sbe_parity_err_out == 0))  |-> ##[0:((4*RATIO)+3)] $rose(hqm_sbendpoint.sbe_parity_err_out == 1);
    endproperty: parity_err_out_prop

    assert property (parity_err_out_prop)
    else begin
        string msg;
        $sformat(msg, {"%m: ERROR parity_err_out is expected",
                 "while ext_parity_err or parity error detected from payload is seen"});
        $error("Parity", msg);    
    end


//****************************************************
    property parity_err_out_stable_prop;
        @(posedge hqm_sbendpoint.agent_clk)
		disable iff (hqm_sbendpoint.side_rst_b !== 1'b1) 
		$rose(hqm_sbendpoint.sbe_parity_err_out)  |-> ((hqm_sbendpoint.sbe_parity_err_out == 1) throughout hqm_sbendpoint.side_rst_b);
    endproperty: parity_err_out_stable_prop

    assert property (parity_err_out_stable_prop)
    else begin
        string msg;
        $sformat(msg, {"%m: ERROR parity_err_out should stay asserted",
                 "once rising edge of parity_err_out is seen "});
        $error("Parity", msg);    
    end

//****************************************************
    
    property parity_cup_prop;
        @(posedge hqm_sbendpoint.agent_clk)
		disable iff (hqm_sbendpoint.side_rst_b !== 1'b1) 
		$rose((hqm_sbendpoint.ext_parity_err_detected == 1'b1 || fabric_intf.tparity_error) && SB_PARITY_REQUIRED && (hqm_sbendpoint.fdfx_sbparity_def == 0) && (hqm_sbendpoint.sbe_parity_err_out == 0))  |-> ##[0:((4*RATIO)+3)] $rose(hqm_sbendpoint.sbe_parity_err_out == 1);
    endproperty:parity_cup_prop

    assert property (parity_cup_prop)
    else begin
        string msg;
        $sformat(msg, {"%m: ERROR tnpcup and traffic should stop",
                 "while parity_err_out is seen"});
        $error("CUP and Traffic Parity", msg);
    end
       end
endgenerate    
    
//****************************************************

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
                  .AGENT_MASTERING_SB_IF(0),
                  .CLKACK_SYNC_DELAY(4),
                  .IS_COMPMON(!IS_RATA_ENV),
                  .IOSF_COMPMON_SB_INCLUDE_USAGE_RULES(0)) 
   fabric_intf    ( .side_clk( ccu_if.clk[0]), 
                    .side_rst_b ( reset ), 
                    .gated_side_clk(gated_side_clk),
                    .agent_rst_b(reset1));
   `else
    iosf_sbc_intf fabric_intf ( .side_clk( ccu_if.clk[0]), 
                    .side_rst_b ( reset ), 
                    .gated_side_clk(gated_side_clk),
                    .agent_rst_b(reset1));
    
generate
       if (!IS_RATA_ENV) begin : gen_ep

    iosf_sb_ti #(.PAYLOAD_WIDTH(MAXPLDBIT+1), 
                 .AGENT_MASTERING_SB_IF(0),
                 .CLKACK_SYNC_DELAY(5),
                 .INPUT_FLOP(PIPEINPS),
                 .DEASSERT_CLK_SIGS_DEFAULT(DEASSERT_CLK_SIGS),
                 .IOSF_COMPMON_SB_INCLUDE_USAGE_RULES(0),
                 .MAX_PENDING_REQUESTS(512)) fabric_ti(.iosf_sbc_intf(fabric_intf));
       end
endgenerate
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
  `endif

   ep_ti #(
             .MASTERREG(MASTERREG),
             .TARGETREG(TARGETREG),
             .MAXPCMSTR(MAXPCMSTR),
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
             .UNIQUE_EXT_HEADERS(UNIQUE_EXT_HEADERS),
	     .IS_RATA_ENV(IS_RATA_ENV),
			 .MATCHED_INTERNAL_WIDTH(MATCHED_INTERNAL_WIDTH)) ep_ti(.iosf_ep_intf(ep_intf));



//  `endif //IOSF_SB_PH2
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
      `ifndef IOSFSBM_ASSERT_OFF
      if(!IS_RATA_ENV && CLKREQDEFAULT) begin
        fabric_intf.disableProperty(0275,1,1);
        fabric_intf.disableProperty(0235,1,1);
      end  
      `endif
    end
    
    always @(posedge ep_intf.assert_reset_all)
       begin
          reset1 = 1'b1;
          reset = 1'b1;
       end
    always @(negedge ep_intf.assert_reset_all)
       begin
          reset1 = 1'b0;
          reset = 1'b0;
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
     always @(posedge fabric_intf.control_ep_reset or posedge ep_intf.control_ep_reset)
       begin
          @(negedge ccu_if.clk[0] );          
          reset = 1'b1;
       end
     always @(negedge fabric_intf.control_ep_reset or negedge ep_intf.control_ep_reset)
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
      reset = 1'bx;
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
   
	//assign fabric_intf.mparity = 1'b0;   
   
  // Instantiate the top level environment
  initial
  begin :MAIN_INIT_BLK


   // Dummy reference to trigger factory registration for tests
   iosftest_pkg::base_test dummy;
   `ifndef IOSF_SB_PH2
    //Interface Wrappers for each i/f type used

    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(MAXPLDBIT+1), 
                                      .AGENT_MASTERING_SB_IF(0),
                                      .CLKACK_SYNC_DELAY(4),
                  		      .IS_COMPMON(!IS_RATA_ENV),
                                      .IOSF_COMPMON_SB_INCLUDE_USAGE_RULES(0)) wrapper_fbrc; 
     
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
     
   if (!IS_RATA_ENV) begin
   //Now fill up bundle with the i/f wrapper, connecting
   //actual interfaces to the virtual ones in the bundle
   wrapper_fbrc = new(fabric_intf);
   vintfBundle.setData ("fabric_intf" , wrapper_fbrc);
   end 
    
    //Pass config info to the environment
    //pass comm_intf name string
    ovm_pkg::set_config_string("*", "comm_intf_name", "comm_intf_i");      
            
    //pass Bundle
    ovm_pkg::set_config_object("*", SB_VINTF_BUNDLE_NAME, vintfBundle, 0);
    
   
     
  `endif
    ovm_default_printer = ovm_default_line_printer;

    // Execute test
    xvm_pkg::run_test("env", "", xvm_pkg::xvm::EOP_OVM);

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

  initial begin
     if($test$plusargs("SB_EN_VPD")) begin    
        $vcdpluson();
        $vcdplusmemon();
     end 
  end 

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
       `ifndef IS_RATA_ENV
       if (MAXPLDBIT == 31)
         begin
           `ifndef IOSF_SB_PH2
            $assertoff(0, fabric_intf.genblk.sbc_compliance.agent_flow_compliance.SBMI_ValidPayloadSize.SBMI_ValidPayloadSize_ASSERT);
            $assertoff(0, fabric_intf.genblk.sbc_compliance.fabric_flow_compliance.SBMI_ValidPayloadSize.SBMI_ValidPayloadSize_ASSERT);
           `endif  
         end       
       `endif
    end
   
endmodule :tb_top

