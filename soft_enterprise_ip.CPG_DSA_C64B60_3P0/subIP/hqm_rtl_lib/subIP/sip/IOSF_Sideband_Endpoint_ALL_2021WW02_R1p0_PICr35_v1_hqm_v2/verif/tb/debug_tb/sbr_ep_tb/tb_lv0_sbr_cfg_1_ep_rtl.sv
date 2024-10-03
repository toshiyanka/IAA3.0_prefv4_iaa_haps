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

import ovm_pkg::*;
import svlib_pkg::*;

`ifdef ACE_RUN
 `include "sbr.sv" 

module tb_top;
`else   
module tb_lv0_sbr_cfg_1_ep_rtl ;
`endif
   
  // misc wires.
   logic clk, clk1, reset, reset1, gated_side_clk, gated_clk;
   int reset_cnt1, reset_cnt2;  
   string ep_intf_name;

  // Instantiate DUT
sbr sbr (
  .fscan_latchopen ( 1'b0 ),
  .fscan_latchclosed_b ( 1'b1 ),
  .fscan_clkungate (1'b0),
  .fscan_rstbypen  (1'b0),
  .clk  ( sbr_pmu_vintf.sbr_clks[0][0]  ),
  .rstb  ( sbr_pmu_vintf.resets[0]  ),
  .p0_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][0] ),
  .p0_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][0] ),
  .sbr_ep0_side_ism_fabric ( sbr_ep0_vintf.side_ism_fabric ),
  .ep0_sbr_side_ism_agent  ( sbr_ep0_vintf.side_ism_agent  ),
  .sbr_ep0_pccup (  sbr_ep0_vintf.mpccup  ), 
  .ep0_sbr_pccup (  sbr_ep0_vintf.tpccup  ), 
  .sbr_ep0_npcup (  sbr_ep0_vintf.mnpcup  ), 
  .ep0_sbr_npcup (  sbr_ep0_vintf.tnpcup  ), 
  .sbr_ep0_pcput (  sbr_ep0_vintf.tpcput  ), 
  .ep0_sbr_pcput (  sbr_ep0_vintf.mpcput  ), 
  .sbr_ep0_npput (  sbr_ep0_vintf.tnpput  ), 
  .ep0_sbr_npput (  sbr_ep0_vintf.mnpput  ), 
  .sbr_ep0_eom (  sbr_ep0_vintf.teom  ), 
  .ep0_sbr_eom (  sbr_ep0_vintf.meom  ), 
  .sbr_ep0_payload (  sbr_ep0_vintf.tpayload  ), 
  .ep0_sbr_payload (  sbr_ep0_vintf.mpayload  ), 
  .p1_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][1] ),
  .p1_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][1] ),
  .pd1_pwrgd ( u_power_intf.powergood[1] ), 
  .sbr_ep1_side_ism_fabric ( sbr_ep1_vintf.side_ism_fabric ),
  .ep1_sbr_side_ism_agent  ( sbr_ep1_vintf.side_ism_agent  ),
  .sbr_ep1_pccup (  sbr_ep1_vintf.mpccup  ), 
  .ep1_sbr_pccup (  sbr_ep1_vintf.tpccup  ), 
  .sbr_ep1_npcup (  sbr_ep1_vintf.mnpcup  ), 
  .ep1_sbr_npcup (  sbr_ep1_vintf.tnpcup  ), 
  .sbr_ep1_pcput (  sbr_ep1_vintf.tpcput  ), 
  .ep1_sbr_pcput (  sbr_ep1_vintf.mpcput  ), 
  .sbr_ep1_npput (  sbr_ep1_vintf.tnpput  ), 
  .ep1_sbr_npput (  sbr_ep1_vintf.mnpput  ), 
  .sbr_ep1_eom (  sbr_ep1_vintf.teom  ), 
  .ep1_sbr_eom (  sbr_ep1_vintf.meom  ), 
  .sbr_ep1_payload (  sbr_ep1_vintf.tpayload  ), 
  .ep1_sbr_payload (  sbr_ep1_vintf.mpayload  ), 
  .p2_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][2] ),
  .p2_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][2] ),
  .sbr_ep2_side_ism_fabric ( sbr_ep2_vintf.side_ism_fabric ),
  .ep2_sbr_side_ism_agent  ( sbr_ep2_vintf.side_ism_agent  ),
  .sbr_ep2_pccup (  sbr_ep2_vintf.mpccup  ), 
  .ep2_sbr_pccup (  sbr_ep2_vintf.tpccup  ), 
  .sbr_ep2_npcup (  sbr_ep2_vintf.mnpcup  ), 
  .ep2_sbr_npcup (  sbr_ep2_vintf.tnpcup  ), 
  .sbr_ep2_pcput (  sbr_ep2_vintf.tpcput  ), 
  .ep2_sbr_pcput (  sbr_ep2_vintf.mpcput  ), 
  .sbr_ep2_npput (  sbr_ep2_vintf.tnpput  ), 
  .ep2_sbr_npput (  sbr_ep2_vintf.mnpput  ), 
  .sbr_ep2_eom (  sbr_ep2_vintf.teom  ), 
  .ep2_sbr_eom (  sbr_ep2_vintf.meom  ), 
  .sbr_ep2_payload (  sbr_ep2_vintf.tpayload  ), 
  .ep2_sbr_payload (  sbr_ep2_vintf.mpayload  ), 
  .p3_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][3] ),
  .p3_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][3] ),
  .sbr_ep3_side_ism_fabric ( sbr_ep3_vintf.side_ism_fabric ),
  .ep3_sbr_side_ism_agent  ( sbr_ep3_vintf.side_ism_agent  ),
  .sbr_ep3_pccup (  sbr_ep3_vintf.mpccup  ), 
  .ep3_sbr_pccup (  sbr_ep3_vintf.tpccup  ), 
  .sbr_ep3_npcup (  sbr_ep3_vintf.mnpcup  ), 
  .ep3_sbr_npcup (  sbr_ep3_vintf.tnpcup  ), 
  .sbr_ep3_pcput (  sbr_ep3_vintf.tpcput  ), 
  .ep3_sbr_pcput (  sbr_ep3_vintf.mpcput  ), 
  .sbr_ep3_npput (  sbr_ep3_vintf.tnpput  ), 
  .ep3_sbr_npput (  sbr_ep3_vintf.mnpput  ), 
  .sbr_ep3_eom (  sbr_ep3_vintf.teom  ), 
  .ep3_sbr_eom (  sbr_ep3_vintf.meom  ), 
  .sbr_ep3_payload (  sbr_ep3_vintf.tpayload  ), 
  .ep3_sbr_payload (  sbr_ep3_vintf.mpayload  ), 
  .p4_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][4] ),
  .p4_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][4] ),
  .sbr_ep4_side_ism_fabric ( sbr_ep4_vintf.side_ism_fabric ),
  .ep4_sbr_side_ism_agent  ( sbr_ep4_vintf.side_ism_agent  ),
  .sbr_ep4_pccup (  sbr_ep4_vintf.mpccup  ), 
  .ep4_sbr_pccup (  sbr_ep4_vintf.tpccup  ), 
  .sbr_ep4_npcup (  sbr_ep4_vintf.mnpcup  ), 
  .ep4_sbr_npcup (  sbr_ep4_vintf.tnpcup  ), 
  .sbr_ep4_pcput (  sbr_ep4_vintf.tpcput  ), 
  .ep4_sbr_pcput (  sbr_ep4_vintf.mpcput  ), 
  .sbr_ep4_npput (  sbr_ep4_vintf.tnpput  ), 
  .ep4_sbr_npput (  sbr_ep4_vintf.mnpput  ), 
  .sbr_ep4_eom (  sbr_ep4_vintf.teom  ), 
  .ep4_sbr_eom (  sbr_ep4_vintf.meom  ), 
  .sbr_ep4_payload (  sbr_ep4_vintf.tpayload  ), 
  .ep4_sbr_payload (  sbr_ep4_vintf.mpayload  ), 
  .p5_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][5] ),
  .p5_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][5] ),
  .sbr_ep5_side_ism_fabric ( sbr_ep5_vintf.side_ism_fabric ),
  .ep5_sbr_side_ism_agent  ( sbr_ep5_vintf.side_ism_agent  ),
  .sbr_ep5_pccup (  sbr_ep5_vintf.mpccup  ), 
  .ep5_sbr_pccup (  sbr_ep5_vintf.tpccup  ), 
  .sbr_ep5_npcup (  sbr_ep5_vintf.mnpcup  ), 
  .ep5_sbr_npcup (  sbr_ep5_vintf.tnpcup  ), 
  .sbr_ep5_pcput (  sbr_ep5_vintf.tpcput  ), 
  .ep5_sbr_pcput (  sbr_ep5_vintf.mpcput  ), 
  .sbr_ep5_npput (  sbr_ep5_vintf.tnpput  ), 
  .ep5_sbr_npput (  sbr_ep5_vintf.mnpput  ), 
  .sbr_ep5_eom (  sbr_ep5_vintf.teom  ), 
  .ep5_sbr_eom (  sbr_ep5_vintf.meom  ), 
  .sbr_ep5_payload (  sbr_ep5_vintf.tpayload  ), 
  .ep5_sbr_payload (  sbr_ep5_vintf.mpayload  ), 
  .p6_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][6] ),
  .p6_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][6] ),
  .sbr_ep6_side_ism_fabric ( sbr_ep6_vintf.side_ism_fabric ),
  .ep6_sbr_side_ism_agent  ( sbr_ep6_vintf.side_ism_agent  ),
  .sbr_ep6_pccup (  sbr_ep6_vintf.mpccup  ), 
  .ep6_sbr_pccup (  sbr_ep6_vintf.tpccup  ), 
  .sbr_ep6_npcup (  sbr_ep6_vintf.mnpcup  ), 
  .ep6_sbr_npcup (  sbr_ep6_vintf.tnpcup  ), 
  .sbr_ep6_pcput (  sbr_ep6_vintf.tpcput  ), 
  .ep6_sbr_pcput (  sbr_ep6_vintf.mpcput  ), 
  .sbr_ep6_npput (  sbr_ep6_vintf.tnpput  ), 
  .ep6_sbr_npput (  sbr_ep6_vintf.mnpput  ), 
  .sbr_ep6_eom (  sbr_ep6_vintf.teom  ), 
  .ep6_sbr_eom (  sbr_ep6_vintf.meom  ), 
  .sbr_ep6_payload (  sbr_ep6_vintf.tpayload  ), 
  .ep6_sbr_payload (  sbr_ep6_vintf.mpayload  ), 
  .p7_fab_init_idle_exit            ( sbr_pmu_vintf.fab_init_idle_exit[0][7] ),
  .p7_fab_init_idle_exit_ack        ( sbr_pmu_vintf.fab_init_idle_exit_ack[0][7] ),
  .sbr_ep7_side_ism_fabric ( sbr_ep7_vintf.side_ism_fabric ),
  .ep7_sbr_side_ism_agent  ( sbr_ep7_vintf.side_ism_agent  ),
  .sbr_ep7_pccup (  sbr_ep7_vintf.mpccup  ), 
  .ep7_sbr_pccup (  sbr_ep7_vintf.tpccup  ), 
  .sbr_ep7_npcup (  sbr_ep7_vintf.mnpcup  ), 
  .ep7_sbr_npcup (  sbr_ep7_vintf.tnpcup  ), 
  .sbr_ep7_pcput (  sbr_ep7_vintf.tpcput  ), 
  .ep7_sbr_pcput (  sbr_ep7_vintf.mpcput  ), 
  .sbr_ep7_npput (  sbr_ep7_vintf.tnpput  ), 
  .ep7_sbr_npput (  sbr_ep7_vintf.mnpput  ), 
  .sbr_ep7_eom (  sbr_ep7_vintf.teom  ), 
  .ep7_sbr_eom (  sbr_ep7_vintf.meom  ), 
  .sbr_ep7_payload (  sbr_ep7_vintf.tpayload  ), 
  .ep7_sbr_payload (  sbr_ep7_vintf.mpayload  ), 
  .sbr_idle    ( sbr_pmu_vintf.sbr_idle[0]  ));


   sbendpoint#(
  .NPQUEUEDEPTH (1),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (1),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (7),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep0 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][0]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep0_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep0_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep0_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep0_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep0_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep0_vintf.tpccup  ), 
  .mpccup (  sbr_ep0_vintf.mpccup  ), 
  .tnpcup (  sbr_ep0_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep0_vintf.mnpcup  ), 
  .mpcput (  sbr_ep0_vintf.mpcput  ), 
  .tpcput (  sbr_ep0_vintf.tpcput  ), 
  .mnpput (  sbr_ep0_vintf.mnpput  ), 
  .tnpput (  sbr_ep0_vintf.tnpput  ), 
  .meom (  sbr_ep0_vintf.meom  ), 
  .teom (  sbr_ep0_vintf.teom  ), 
  .mpayload (  sbr_ep0_vintf.mpayload  ), 
  .tpayload (  sbr_ep0_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep0_vintf.agent_clkreq),
  .agent_idle(ep0_vintf.agent_idle),
  .sbe_clkreq(ep0_vintf.sbe_clkreq),
  .sbe_idle(ep0_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep0_vintf.tmsg_pcfree),
  .tmsg_npfree(ep0_vintf.tmsg_npfree),
  .tmsg_npclaim(ep0_vintf.tmsg_npclaim),
  .tmsg_pcput(ep0_vintf.tmsg_pcput),
  .tmsg_npput(ep0_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep0_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep0_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep0_vintf.tmsg_pceom),
  .tmsg_npeom(ep0_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep0_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep0_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep0_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep0_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep0_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep0_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep0_vintf.mmsg_npirdy),
  .mmsg_pceom(ep0_vintf.mmsg_pceom),
  .mmsg_npeom(ep0_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep0_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep0_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep0_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep0_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep0_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep0_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep0_vintf.mmsg_pcsel),
  .mmsg_npsel(ep0_vintf.mmsg_npsel),

  .treg_trdy(ep0_vintf.treg_trdy),
  .treg_cerr(ep0_vintf.treg_cerr),
  .treg_rdata(ep0_vintf.treg_rdata),
  .treg_irdy(ep0_vintf.treg_irdy),
  .treg_np(ep0_vintf.treg_np),
  .treg_dest(ep0_vintf.treg_dest),
  .treg_source(ep0_vintf.treg_source),
  .treg_opcode(ep0_vintf.treg_opcode),
  .treg_addrlen(ep0_vintf.treg_addrlen),
  .treg_bar(ep0_vintf.treg_bar),
  .treg_tag(ep0_vintf.treg_tag),
  .treg_be(ep0_vintf.treg_be),
  .treg_fid(ep0_vintf.treg_fid),
  .treg_addr(ep0_vintf.treg_addr),
  .treg_wdata(ep0_vintf.treg_wdata),
  .treg_eh(ep0_vintf.treg_eh),
  .treg_ext_header(ep0_vintf.treg_ext_header),
  .treg_eh_discard(ep0_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep0_vintf.mreg_irdy),
  .mreg_npwrite(ep0_vintf.mreg_npwrite),
  .mreg_dest(ep0_vintf.mreg_dest),
  .mreg_source(ep0_vintf.mreg_source),
  .mreg_opcode(ep0_vintf.mreg_opcode),
  .mreg_addrlen(ep0_vintf.mreg_addrlen),
  .mreg_bar(ep0_vintf.mreg_bar),
  .mreg_tag(ep0_vintf.mreg_tag),
  .mreg_be(ep0_vintf.mreg_be),
  .mreg_fid(ep0_vintf.mreg_fid),
  .mreg_addr(ep0_vintf.mreg_addr),
  .mreg_wdata(ep0_vintf.mreg_wdata),
  .mreg_trdy(ep0_vintf.mreg_trdy),
  .mreg_pmsgip(ep0_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep0_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep0_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);

sbendpoint#(
  .NPQUEUEDEPTH (2),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (2),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (7),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep1 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][1]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep1_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep1_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep1_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep1_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep1_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep1_vintf.tpccup  ), 
  .mpccup (  sbr_ep1_vintf.mpccup  ), 
  .tnpcup (  sbr_ep1_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep1_vintf.mnpcup  ), 
  .mpcput (  sbr_ep1_vintf.mpcput  ), 
  .tpcput (  sbr_ep1_vintf.tpcput  ), 
  .mnpput (  sbr_ep1_vintf.mnpput  ), 
  .tnpput (  sbr_ep1_vintf.tnpput  ), 
  .meom (  sbr_ep1_vintf.meom  ), 
  .teom (  sbr_ep1_vintf.teom  ), 
  .mpayload (  sbr_ep1_vintf.mpayload  ), 
  .tpayload (  sbr_ep1_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep1_vintf.agent_clkreq),
  .agent_idle(ep1_vintf.agent_idle),
  .sbe_clkreq(ep1_vintf.sbe_clkreq),
  .sbe_idle(ep1_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep1_vintf.tmsg_pcfree),
  .tmsg_npfree(ep1_vintf.tmsg_npfree),
  .tmsg_npclaim(ep1_vintf.tmsg_npclaim),
  .tmsg_pcput(ep1_vintf.tmsg_pcput),
  .tmsg_npput(ep1_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep1_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep1_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep1_vintf.tmsg_pceom),
  .tmsg_npeom(ep1_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep1_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep1_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep1_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep1_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep1_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep1_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep1_vintf.mmsg_npirdy),
  .mmsg_pceom(ep1_vintf.mmsg_pceom),
  .mmsg_npeom(ep1_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep1_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep1_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep1_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep1_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep1_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep1_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep1_vintf.mmsg_pcsel),
  .mmsg_npsel(ep1_vintf.mmsg_npsel),

  .treg_trdy(ep1_vintf.treg_trdy),
  .treg_cerr(ep1_vintf.treg_cerr),
  .treg_rdata(ep1_vintf.treg_rdata),
  .treg_irdy(ep1_vintf.treg_irdy),
  .treg_np(ep1_vintf.treg_np),
  .treg_dest(ep1_vintf.treg_dest),
  .treg_source(ep1_vintf.treg_source),
  .treg_opcode(ep1_vintf.treg_opcode),
  .treg_addrlen(ep1_vintf.treg_addrlen),
  .treg_bar(ep1_vintf.treg_bar),
  .treg_tag(ep1_vintf.treg_tag),
  .treg_be(ep1_vintf.treg_be),
  .treg_fid(ep1_vintf.treg_fid),
  .treg_addr(ep1_vintf.treg_addr),
  .treg_wdata(ep1_vintf.treg_wdata),
  .treg_eh(ep1_vintf.treg_eh),
  .treg_ext_header(ep1_vintf.treg_ext_header),
  .treg_eh_discard(ep1_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep1_vintf.mreg_irdy),
  .mreg_npwrite(ep1_vintf.mreg_npwrite),
  .mreg_dest(ep1_vintf.mreg_dest),
  .mreg_source(ep1_vintf.mreg_source),
  .mreg_opcode(ep1_vintf.mreg_opcode),
  .mreg_addrlen(ep1_vintf.mreg_addrlen),
  .mreg_bar(ep1_vintf.mreg_bar),
  .mreg_tag(ep1_vintf.mreg_tag),
  .mreg_be(ep1_vintf.mreg_be),
  .mreg_fid(ep1_vintf.mreg_fid),
  .mreg_addr(ep1_vintf.mreg_addr),
  .mreg_wdata(ep1_vintf.mreg_wdata),
  .mreg_trdy(ep1_vintf.mreg_trdy),
  .mreg_pmsgip(ep1_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep1_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep1_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);

   
sbendpoint#(
  .NPQUEUEDEPTH (5),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (8),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (15),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep2 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][2]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep2_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep2_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep2_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep2_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep2_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep2_vintf.tpccup  ), 
  .mpccup (  sbr_ep2_vintf.mpccup  ), 
  .tnpcup (  sbr_ep2_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep2_vintf.mnpcup  ), 
  .mpcput (  sbr_ep2_vintf.mpcput  ), 
  .tpcput (  sbr_ep2_vintf.tpcput  ), 
  .mnpput (  sbr_ep2_vintf.mnpput  ), 
  .tnpput (  sbr_ep2_vintf.tnpput  ), 
  .meom (  sbr_ep2_vintf.meom  ), 
  .teom (  sbr_ep2_vintf.teom  ), 
  .mpayload (  sbr_ep2_vintf.mpayload  ), 
  .tpayload (  sbr_ep2_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep2_vintf.agent_clkreq),
  .agent_idle(ep2_vintf.agent_idle),
  .sbe_clkreq(ep2_vintf.sbe_clkreq),
  .sbe_idle(ep2_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep2_vintf.tmsg_pcfree),
  .tmsg_npfree(ep2_vintf.tmsg_npfree),
  .tmsg_npclaim(ep2_vintf.tmsg_npclaim),
  .tmsg_pcput(ep2_vintf.tmsg_pcput),
  .tmsg_npput(ep2_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep2_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep2_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep2_vintf.tmsg_pceom),
  .tmsg_npeom(ep2_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep2_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep2_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep2_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep2_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep2_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep2_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep2_vintf.mmsg_npirdy),
  .mmsg_pceom(ep2_vintf.mmsg_pceom),
  .mmsg_npeom(ep2_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep2_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep2_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep2_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep2_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep2_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep2_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep2_vintf.mmsg_pcsel),
  .mmsg_npsel(ep2_vintf.mmsg_npsel),

  .treg_trdy(ep2_vintf.treg_trdy),
  .treg_cerr(ep2_vintf.treg_cerr),
  .treg_rdata(ep2_vintf.treg_rdata),
  .treg_irdy(ep2_vintf.treg_irdy),
  .treg_np(ep2_vintf.treg_np),
  .treg_dest(ep2_vintf.treg_dest),
  .treg_source(ep2_vintf.treg_source),
  .treg_opcode(ep2_vintf.treg_opcode),
  .treg_addrlen(ep2_vintf.treg_addrlen),
  .treg_bar(ep2_vintf.treg_bar),
  .treg_tag(ep2_vintf.treg_tag),
  .treg_be(ep2_vintf.treg_be),
  .treg_fid(ep2_vintf.treg_fid),
  .treg_addr(ep2_vintf.treg_addr),
  .treg_wdata(ep2_vintf.treg_wdata),
  .treg_eh(ep2_vintf.treg_eh),
  .treg_ext_header(ep2_vintf.treg_ext_header),
  .treg_eh_discard(ep2_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep2_vintf.mreg_irdy),
  .mreg_npwrite(ep2_vintf.mreg_npwrite),
  .mreg_dest(ep2_vintf.mreg_dest),
  .mreg_source(ep2_vintf.mreg_source),
  .mreg_opcode(ep2_vintf.mreg_opcode),
  .mreg_addrlen(ep2_vintf.mreg_addrlen),
  .mreg_bar(ep2_vintf.mreg_bar),
  .mreg_tag(ep2_vintf.mreg_tag),
  .mreg_be(ep2_vintf.mreg_be),
  .mreg_fid(ep2_vintf.mreg_fid),
  .mreg_addr(ep2_vintf.mreg_addr),
  .mreg_wdata(ep2_vintf.mreg_wdata),
  .mreg_trdy(ep2_vintf.mreg_trdy),
  .mreg_pmsgip(ep2_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep2_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep2_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);
sbendpoint#(
  .NPQUEUEDEPTH (9),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (2),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (15),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep3 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][3]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep3_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep3_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep3_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep3_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep3_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep3_vintf.tpccup  ), 
  .mpccup (  sbr_ep3_vintf.mpccup  ), 
  .tnpcup (  sbr_ep3_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep3_vintf.mnpcup  ), 
  .mpcput (  sbr_ep3_vintf.mpcput  ), 
  .tpcput (  sbr_ep3_vintf.tpcput  ), 
  .mnpput (  sbr_ep3_vintf.mnpput  ), 
  .tnpput (  sbr_ep3_vintf.tnpput  ), 
  .meom (  sbr_ep3_vintf.meom  ), 
  .teom (  sbr_ep3_vintf.teom  ), 
  .mpayload (  sbr_ep3_vintf.mpayload  ), 
  .tpayload (  sbr_ep3_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep3_vintf.agent_clkreq),
  .agent_idle(ep3_vintf.agent_idle),
  .sbe_clkreq(ep3_vintf.sbe_clkreq),
  .sbe_idle(ep3_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep3_vintf.tmsg_pcfree),
  .tmsg_npfree(ep3_vintf.tmsg_npfree),
  .tmsg_npclaim(ep3_vintf.tmsg_npclaim),
  .tmsg_pcput(ep3_vintf.tmsg_pcput),
  .tmsg_npput(ep3_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep3_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep3_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep3_vintf.tmsg_pceom),
  .tmsg_npeom(ep3_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep3_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep3_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep3_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep3_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep3_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep3_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep3_vintf.mmsg_npirdy),
  .mmsg_pceom(ep3_vintf.mmsg_pceom),
  .mmsg_npeom(ep3_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep3_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep3_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep3_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep3_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep3_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep3_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep3_vintf.mmsg_pcsel),
  .mmsg_npsel(ep3_vintf.mmsg_npsel),

  .treg_trdy(ep3_vintf.treg_trdy),
  .treg_cerr(ep3_vintf.treg_cerr),
  .treg_rdata(ep3_vintf.treg_rdata),
  .treg_irdy(ep3_vintf.treg_irdy),
  .treg_np(ep3_vintf.treg_np),
  .treg_dest(ep3_vintf.treg_dest),
  .treg_source(ep3_vintf.treg_source),
  .treg_opcode(ep3_vintf.treg_opcode),
  .treg_addrlen(ep3_vintf.treg_addrlen),
  .treg_bar(ep3_vintf.treg_bar),
  .treg_tag(ep3_vintf.treg_tag),
  .treg_be(ep3_vintf.treg_be),
  .treg_fid(ep3_vintf.treg_fid),
  .treg_addr(ep3_vintf.treg_addr),
  .treg_wdata(ep3_vintf.treg_wdata),
  .treg_eh(ep3_vintf.treg_eh),
  .treg_ext_header(ep3_vintf.treg_ext_header),
  .treg_eh_discard(ep3_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep3_vintf.mreg_irdy),
  .mreg_npwrite(ep3_vintf.mreg_npwrite),
  .mreg_dest(ep3_vintf.mreg_dest),
  .mreg_source(ep3_vintf.mreg_source),
  .mreg_opcode(ep3_vintf.mreg_opcode),
  .mreg_addrlen(ep3_vintf.mreg_addrlen),
  .mreg_bar(ep3_vintf.mreg_bar),
  .mreg_tag(ep3_vintf.mreg_tag),
  .mreg_be(ep3_vintf.mreg_be),
  .mreg_fid(ep3_vintf.mreg_fid),
  .mreg_addr(ep3_vintf.mreg_addr),
  .mreg_wdata(ep3_vintf.mreg_wdata),
  .mreg_trdy(ep3_vintf.mreg_trdy),
  .mreg_pmsgip(ep3_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep3_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep3_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);
   
sbendpoint#(
  .NPQUEUEDEPTH (1),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (2),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (7),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep4 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][4]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep4_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep4_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep4_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep4_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep4_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep4_vintf.tpccup  ), 
  .mpccup (  sbr_ep4_vintf.mpccup  ), 
  .tnpcup (  sbr_ep4_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep4_vintf.mnpcup  ), 
  .mpcput (  sbr_ep4_vintf.mpcput  ), 
  .tpcput (  sbr_ep4_vintf.tpcput  ), 
  .mnpput (  sbr_ep4_vintf.mnpput  ), 
  .tnpput (  sbr_ep4_vintf.tnpput  ), 
  .meom (  sbr_ep4_vintf.meom  ), 
  .teom (  sbr_ep4_vintf.teom  ), 
  .mpayload (  sbr_ep4_vintf.mpayload  ), 
  .tpayload (  sbr_ep4_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep4_vintf.agent_clkreq),
  .agent_idle(ep4_vintf.agent_idle),
  .sbe_clkreq(ep4_vintf.sbe_clkreq),
  .sbe_idle(ep4_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep4_vintf.tmsg_pcfree),
  .tmsg_npfree(ep4_vintf.tmsg_npfree),
  .tmsg_npclaim(ep4_vintf.tmsg_npclaim),
  .tmsg_pcput(ep4_vintf.tmsg_pcput),
  .tmsg_npput(ep4_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep4_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep4_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep4_vintf.tmsg_pceom),
  .tmsg_npeom(ep4_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep4_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep4_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep4_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep4_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep4_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep4_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep4_vintf.mmsg_npirdy),
  .mmsg_pceom(ep4_vintf.mmsg_pceom),
  .mmsg_npeom(ep4_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep4_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep4_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep4_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep4_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep4_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep4_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep4_vintf.mmsg_pcsel),
  .mmsg_npsel(ep4_vintf.mmsg_npsel),

  .treg_trdy(ep4_vintf.treg_trdy),
  .treg_cerr(ep4_vintf.treg_cerr),
  .treg_rdata(ep4_vintf.treg_rdata),
  .treg_irdy(ep4_vintf.treg_irdy),
  .treg_np(ep4_vintf.treg_np),
  .treg_dest(ep4_vintf.treg_dest),
  .treg_source(ep4_vintf.treg_source),
  .treg_opcode(ep4_vintf.treg_opcode),
  .treg_addrlen(ep4_vintf.treg_addrlen),
  .treg_bar(ep4_vintf.treg_bar),
  .treg_tag(ep4_vintf.treg_tag),
  .treg_be(ep4_vintf.treg_be),
  .treg_fid(ep4_vintf.treg_fid),
  .treg_addr(ep4_vintf.treg_addr),
  .treg_wdata(ep4_vintf.treg_wdata),
  .treg_eh(ep4_vintf.treg_eh),
  .treg_ext_header(ep4_vintf.treg_ext_header),
  .treg_eh_discard(ep4_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep4_vintf.mreg_irdy),
  .mreg_npwrite(ep4_vintf.mreg_npwrite),
  .mreg_dest(ep4_vintf.mreg_dest),
  .mreg_source(ep4_vintf.mreg_source),
  .mreg_opcode(ep4_vintf.mreg_opcode),
  .mreg_addrlen(ep4_vintf.mreg_addrlen),
  .mreg_bar(ep4_vintf.mreg_bar),
  .mreg_tag(ep4_vintf.mreg_tag),
  .mreg_be(ep4_vintf.mreg_be),
  .mreg_fid(ep4_vintf.mreg_fid),
  .mreg_addr(ep4_vintf.mreg_addr),
  .mreg_wdata(ep4_vintf.mreg_wdata),
  .mreg_trdy(ep4_vintf.mreg_trdy),
  .mreg_pmsgip(ep4_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep4_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep4_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);


sbendpoint#(
  .NPQUEUEDEPTH (2),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (4),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (7),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep5 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][5]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep5_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep5_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep5_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep5_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep5_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep5_vintf.tpccup  ), 
  .mpccup (  sbr_ep5_vintf.mpccup  ), 
  .tnpcup (  sbr_ep5_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep5_vintf.mnpcup  ), 
  .mpcput (  sbr_ep5_vintf.mpcput  ), 
  .tpcput (  sbr_ep5_vintf.tpcput  ), 
  .mnpput (  sbr_ep5_vintf.mnpput  ), 
  .tnpput (  sbr_ep5_vintf.tnpput  ), 
  .meom (  sbr_ep5_vintf.meom  ), 
  .teom (  sbr_ep5_vintf.teom  ), 
  .mpayload (  sbr_ep5_vintf.mpayload  ), 
  .tpayload (  sbr_ep5_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep5_vintf.agent_clkreq),
  .agent_idle(ep5_vintf.agent_idle),
  .sbe_clkreq(ep5_vintf.sbe_clkreq),
  .sbe_idle(ep5_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep5_vintf.tmsg_pcfree),
  .tmsg_npfree(ep5_vintf.tmsg_npfree),
  .tmsg_npclaim(ep5_vintf.tmsg_npclaim),
  .tmsg_pcput(ep5_vintf.tmsg_pcput),
  .tmsg_npput(ep5_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep5_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep5_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep5_vintf.tmsg_pceom),
  .tmsg_npeom(ep5_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep5_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep5_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep5_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep5_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep5_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep5_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep5_vintf.mmsg_npirdy),
  .mmsg_pceom(ep5_vintf.mmsg_pceom),
  .mmsg_npeom(ep5_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep5_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep5_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep5_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep5_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep5_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep5_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep5_vintf.mmsg_pcsel),
  .mmsg_npsel(ep5_vintf.mmsg_npsel),

  .treg_trdy(ep5_vintf.treg_trdy),
  .treg_cerr(ep5_vintf.treg_cerr),
  .treg_rdata(ep5_vintf.treg_rdata),
  .treg_irdy(ep5_vintf.treg_irdy),
  .treg_np(ep5_vintf.treg_np),
  .treg_dest(ep5_vintf.treg_dest),
  .treg_source(ep5_vintf.treg_source),
  .treg_opcode(ep5_vintf.treg_opcode),
  .treg_addrlen(ep5_vintf.treg_addrlen),
  .treg_bar(ep5_vintf.treg_bar),
  .treg_tag(ep5_vintf.treg_tag),
  .treg_be(ep5_vintf.treg_be),
  .treg_fid(ep5_vintf.treg_fid),
  .treg_addr(ep5_vintf.treg_addr),
  .treg_wdata(ep5_vintf.treg_wdata),
  .treg_eh(ep5_vintf.treg_eh),
  .treg_ext_header(ep5_vintf.treg_ext_header),
  .treg_eh_discard(ep5_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep5_vintf.mreg_irdy),
  .mreg_npwrite(ep5_vintf.mreg_npwrite),
  .mreg_dest(ep5_vintf.mreg_dest),
  .mreg_source(ep5_vintf.mreg_source),
  .mreg_opcode(ep5_vintf.mreg_opcode),
  .mreg_addrlen(ep5_vintf.mreg_addrlen),
  .mreg_bar(ep5_vintf.mreg_bar),
  .mreg_tag(ep5_vintf.mreg_tag),
  .mreg_be(ep5_vintf.mreg_be),
  .mreg_fid(ep5_vintf.mreg_fid),
  .mreg_addr(ep5_vintf.mreg_addr),
  .mreg_wdata(ep5_vintf.mreg_wdata),
  .mreg_trdy(ep5_vintf.mreg_trdy),
  .mreg_pmsgip(ep5_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep5_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep5_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);
   
sbendpoint#(
  .NPQUEUEDEPTH (8),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (2),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (15),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep6 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][6]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep6_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep6_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep6_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep6_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep6_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep6_vintf.tpccup  ), 
  .mpccup (  sbr_ep6_vintf.mpccup  ), 
  .tnpcup (  sbr_ep6_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep6_vintf.mnpcup  ), 
  .mpcput (  sbr_ep6_vintf.mpcput  ), 
  .tpcput (  sbr_ep6_vintf.tpcput  ), 
  .mnpput (  sbr_ep6_vintf.mnpput  ), 
  .tnpput (  sbr_ep6_vintf.tnpput  ), 
  .meom (  sbr_ep6_vintf.meom  ), 
  .teom (  sbr_ep6_vintf.teom  ), 
  .mpayload (  sbr_ep6_vintf.mpayload  ), 
  .tpayload (  sbr_ep6_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep6_vintf.agent_clkreq),
  .agent_idle(ep6_vintf.agent_idle),
  .sbe_clkreq(ep6_vintf.sbe_clkreq),
  .sbe_idle(ep6_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep6_vintf.tmsg_pcfree),
  .tmsg_npfree(ep6_vintf.tmsg_npfree),
  .tmsg_npclaim(ep6_vintf.tmsg_npclaim),
  .tmsg_pcput(ep6_vintf.tmsg_pcput),
  .tmsg_npput(ep6_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep6_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep6_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep6_vintf.tmsg_pceom),
  .tmsg_npeom(ep6_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep6_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep6_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep6_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep6_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep6_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep6_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep6_vintf.mmsg_npirdy),
  .mmsg_pceom(ep6_vintf.mmsg_pceom),
  .mmsg_npeom(ep6_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep6_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep6_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep6_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep6_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep6_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep6_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep6_vintf.mmsg_pcsel),
  .mmsg_npsel(ep6_vintf.mmsg_npsel),

  .treg_trdy(ep6_vintf.treg_trdy),
  .treg_cerr(ep6_vintf.treg_cerr),
  .treg_rdata(ep6_vintf.treg_rdata),
  .treg_irdy(ep6_vintf.treg_irdy),
  .treg_np(ep6_vintf.treg_np),
  .treg_dest(ep6_vintf.treg_dest),
  .treg_source(ep6_vintf.treg_source),
  .treg_opcode(ep6_vintf.treg_opcode),
  .treg_addrlen(ep6_vintf.treg_addrlen),
  .treg_bar(ep6_vintf.treg_bar),
  .treg_tag(ep6_vintf.treg_tag),
  .treg_be(ep6_vintf.treg_be),
  .treg_fid(ep6_vintf.treg_fid),
  .treg_addr(ep6_vintf.treg_addr),
  .treg_wdata(ep6_vintf.treg_wdata),
  .treg_eh(ep6_vintf.treg_eh),
  .treg_ext_header(ep6_vintf.treg_ext_header),
  .treg_eh_discard(ep6_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep6_vintf.mreg_irdy),
  .mreg_npwrite(ep6_vintf.mreg_npwrite),
  .mreg_dest(ep6_vintf.mreg_dest),
  .mreg_source(ep6_vintf.mreg_source),
  .mreg_opcode(ep6_vintf.mreg_opcode),
  .mreg_addrlen(ep6_vintf.mreg_addrlen),
  .mreg_bar(ep6_vintf.mreg_bar),
  .mreg_tag(ep6_vintf.mreg_tag),
  .mreg_be(ep6_vintf.mreg_be),
  .mreg_fid(ep6_vintf.mreg_fid),
  .mreg_addr(ep6_vintf.mreg_addr),
  .mreg_wdata(ep6_vintf.mreg_wdata),
  .mreg_trdy(ep6_vintf.mreg_trdy),
  .mreg_pmsgip(ep6_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep6_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep6_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);
   

sbendpoint#(
  .NPQUEUEDEPTH (3),//read it from xml crd_buffer size
  .PCQUEUEDEPTH (2),//read it from xml crd_buffer size
  .MAXTRGTADDR  (47),
  .MAXMSTRADDR  (47),
  .MAXMSTRDATA  (63),
  .MAXTRGTDATA  (63),
  .CUP2PUT1CYC  (1), //From xml 
  .ASYNCENDPT   (0),
  .ASYNCEQDEPTH (2),
  .ASYNCIQDEPTH (2),
  .TARGETREG    (1),
  .MASTERREG    (1),
  .MAXPCTRGT    (0),
  .MAXNPTRGT    (0),
  .MAXPCMSTR    (0), 
  .MAXNPMSTR    (0),
  .MAXPLDBIT    (15),    
  .RX_EXT_HEADER_SUPPORT(1),
  .TX_EXT_HEADER_SUPPORT(1),
  .NUM_RX_EXT_HEADERS(1),
  .NUM_TX_EXT_HEADERS(1),
  .RX_EXT_HEADER_IDS(7'h00)
            
)                                        
sbendpoint_ep7 (                                    
  .side_clk ( sbr_pmu_vintf.agent_clks[0][7]),
  .side_rst_b ( sbr_pmu_vintf.resets[0]),
                                     
  .agent_clk(ep7_gated_clk),
  //.agent_rst_b(reset1),     
                             
  //Fabric Node
  .side_ism_fabric ( sbr_ep7_vintf.side_ism_fabric ),
  .side_ism_agent  ( sbr_ep7_vintf.side_ism_agent ),
  .side_clkreq     ( sbr_ep7_vintf.side_clkreq ),
  .side_clkack     ( sbr_ep7_vintf.side_clkack ),                                   
  .tpccup (  sbr_ep7_vintf.tpccup  ), 
  .mpccup (  sbr_ep7_vintf.mpccup  ), 
  .tnpcup (  sbr_ep7_vintf.tnpcup  ), 
  .mnpcup (  sbr_ep7_vintf.mnpcup  ), 
  .mpcput (  sbr_ep7_vintf.mpcput  ), 
  .tpcput (  sbr_ep7_vintf.tpcput  ), 
  .mnpput (  sbr_ep7_vintf.mnpput  ), 
  .tnpput (  sbr_ep7_vintf.tnpput  ), 
  .meom (  sbr_ep7_vintf.meom  ), 
  .teom (  sbr_ep7_vintf.teom  ), 
  .mpayload (  sbr_ep7_vintf.mpayload  ), 
  .tpayload (  sbr_ep7_vintf.tpayload  ),

  //IP Node   
  .agent_clkreq(ep7_vintf.agent_clkreq),
  .agent_idle(ep7_vintf.agent_idle),
  .sbe_clkreq(ep7_vintf.sbe_clkreq),
  .sbe_idle(ep7_vintf.sbe_idle),
                                                                    
  .tmsg_pcfree(ep7_vintf.tmsg_pcfree),
  .tmsg_npfree(ep7_vintf.tmsg_npfree),
  .tmsg_npclaim(ep7_vintf.tmsg_npclaim),
  .tmsg_pcput(ep7_vintf.tmsg_pcput),
  .tmsg_npput(ep7_vintf.tmsg_npput),
  .tmsg_pcmsgip(ep7_vintf.tmsg_pcmsgip),
  .tmsg_npmsgip(ep7_vintf.tmsg_npmsgip),
  .tmsg_pceom(ep7_vintf.tmsg_pceom),
  .tmsg_npeom(ep7_vintf.tmsg_npeom),
  .tmsg_pcpayload(ep7_vintf.tmsg_pcpayload),
  .tmsg_nppayload(ep7_vintf.tmsg_nppayload),
  .tmsg_pccmpl(ep7_vintf.tmsg_pccmpl),
  .tmsg_npvalid(ep7_vintf.tmsg_npvalid),
  .tmsg_pcvalid(ep7_vintf.tmsg_pcvalid),
                                     
  .mmsg_pcirdy(ep7_vintf.mmsg_pcirdy),
  .mmsg_npirdy(ep7_vintf.mmsg_npirdy),
  .mmsg_pceom(ep7_vintf.mmsg_pceom),
  .mmsg_npeom(ep7_vintf.mmsg_npeom),
  .mmsg_pcpayload(ep7_vintf.mmsg_pcpayload),
  .mmsg_nppayload (ep7_vintf.mmsg_nppayload),
  .mmsg_pctrdy(ep7_vintf.mmsg_pctrdy),
  .mmsg_nptrdy(ep7_vintf.mmsg_nptrdy),
  .mmsg_pcmsgip(ep7_vintf.mmsg_pcmsgip),
  .mmsg_npmsgip(ep7_vintf.mmsg_npmsgip),
  .mmsg_pcsel(ep7_vintf.mmsg_pcsel),
  .mmsg_npsel(ep7_vintf.mmsg_npsel),

  .treg_trdy(ep7_vintf.treg_trdy),
  .treg_cerr(ep7_vintf.treg_cerr),
  .treg_rdata(ep7_vintf.treg_rdata),
  .treg_irdy(ep7_vintf.treg_irdy),
  .treg_np(ep7_vintf.treg_np),
  .treg_dest(ep7_vintf.treg_dest),
  .treg_source(ep7_vintf.treg_source),
  .treg_opcode(ep7_vintf.treg_opcode),
  .treg_addrlen(ep7_vintf.treg_addrlen),
  .treg_bar(ep7_vintf.treg_bar),
  .treg_tag(ep7_vintf.treg_tag),
  .treg_be(ep7_vintf.treg_be),
  .treg_fid(ep7_vintf.treg_fid),
  .treg_addr(ep7_vintf.treg_addr),
  .treg_wdata(ep7_vintf.treg_wdata),
  .treg_eh(ep7_vintf.treg_eh),
  .treg_ext_header(ep7_vintf.treg_ext_header),
  .treg_eh_discard(ep7_vintf.treg_eh_discard),                                              
                                        
  .mreg_irdy(ep7_vintf.mreg_irdy),
  .mreg_npwrite(ep7_vintf.mreg_npwrite),
  .mreg_dest(ep7_vintf.mreg_dest),
  .mreg_source(ep7_vintf.mreg_source),
  .mreg_opcode(ep7_vintf.mreg_opcode),
  .mreg_addrlen(ep7_vintf.mreg_addrlen),
  .mreg_bar(ep7_vintf.mreg_bar),
  .mreg_tag(ep7_vintf.mreg_tag),
  .mreg_be(ep7_vintf.mreg_be),
  .mreg_fid(ep7_vintf.mreg_fid),
  .mreg_addr(ep7_vintf.mreg_addr),
  .mreg_wdata(ep7_vintf.mreg_wdata),
  .mreg_trdy(ep7_vintf.mreg_trdy),
  .mreg_pmsgip(ep7_vintf.mreg_pmsgip),
  .mreg_nmsgip(ep7_vintf.mreg_nmsgip),
   
  .tx_ext_headers(ep7_vintf.tx_ext_headers),
                             
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
  .fscan_rstbypen          (1'b0)
);

  // Communication matrix
  // ====================


  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep0_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][0] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep0_gated_clk));

  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep1_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][1] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep1_gated_clk));
   
  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep2_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][2] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep2_gated_clk));

  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep3_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][3] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep3_gated_clk));

  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep4_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][4] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep4_gated_clk));

  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep5_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][5] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep5_gated_clk));
   
  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep6_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][6] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep6_gated_clk));


  iosf_ep_intf#(.MAXPCMSTR(0),
                .MAXNPMSTR(0),
                .MAXPCTRGT(0),
                .MAXNPTRGT(0),
                .MAXTRGTADDR(47),
                .MAXTRGTDATA(63),
                .MAXMSTRADDR(47),
                .MAXMSTRDATA(63),
                .NUM_TX_EXT_HEADERS(1),
                .NUM_RX_EXT_HEADERS(1))          
   ep7_vintf     ( .clk(sbr_pmu_vintf.agent_clks[0][7] ), .reset ( sbr_pmu_vintf.resets[0] ), .gated_clk(ep7_gated_clk));
   
   
   // Create module for factory registration 
   // --------------------------------------
   iosfsb_ep_mon #(.MAXPCMSTR(0),
                   .MAXNPMSTR(0),
                   .MAXPCTRGT(0),
                   .MAXNPTRGT(0),
                   .MAXTRGTADDR(47),
                   .MAXTRGTDATA(63),
                   .MAXMSTRADDR(47),
                   .MAXMSTRDATA(63),
                   .NUM_TX_EXT_HEADERS(1),
                   .NUM_RX_EXT_HEADERS(1),
                   .INST_NUM(0)) u_iosfsb_ep_mon();

  // Communication matrix
  // ====================

  // Interface instances
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep0_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][0] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep1_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][1] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep2_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][2] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep3_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][3] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep4_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][4] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep5_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][5] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep6_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][6] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep7_vintf    ( .side_clk( sbr_pmu_vintf.agent_clks[0][7] ), .side_rst_b ( sbr_pmu_vintf.resets[0] ) );

  

  iosf_sbr_pmu_intf #( .MAX_NUM_OF_CLKS(1), .MAX_NUM_OF_RTRS(1)) sbr_pmu_vintf();
  iosf_sbr_pmu_mon #( .MAX_NUM_OF_CLKS(1), .MAX_NUM_OF_RTRS(1)) sbr_pmu_mon();


    assign sbr_pmu_vintf.side_ism_agent[0][0] = sbr_ep0_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][0] = sbr_ep0_vintf.side_ism_fabric;

    assign sbr_ep0_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][0];
    assign sbr_pmu_vintf.side_clkreq[0][0] = sbr_ep0_vintf.side_clkreq;

    assign sbr_pmu_vintf.side_ism_agent[0][1] = sbr_ep1_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][1] = sbr_ep1_vintf.side_ism_fabric;

    assign sbr_ep1_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][1];
    assign sbr_pmu_vintf.side_clkreq[0][1] = sbr_ep1_vintf.side_clkreq;

    assign sbr_pmu_vintf.side_ism_agent[0][2] = sbr_ep2_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][2] = sbr_ep2_vintf.side_ism_fabric;

    assign sbr_ep2_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][2];
    assign sbr_pmu_vintf.side_clkreq[0][2] = sbr_ep2_vintf.side_clkreq;

    assign sbr_pmu_vintf.side_ism_agent[0][3] = sbr_ep3_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][3] = sbr_ep3_vintf.side_ism_fabric;

    assign sbr_ep3_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][3];
    assign sbr_pmu_vintf.side_clkreq[0][3] = sbr_ep3_vintf.side_clkreq;

    assign sbr_pmu_vintf.side_ism_agent[0][4] = sbr_ep4_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][4] = sbr_ep4_vintf.side_ism_fabric;

    assign sbr_ep4_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][4];
    assign sbr_pmu_vintf.side_clkreq[0][4] = sbr_ep4_vintf.side_clkreq;

    assign sbr_pmu_vintf.side_ism_agent[0][5] = sbr_ep5_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][5] = sbr_ep5_vintf.side_ism_fabric;

    assign sbr_ep5_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][5];
    assign sbr_pmu_vintf.side_clkreq[0][5] = sbr_ep5_vintf.side_clkreq;

    assign sbr_pmu_vintf.side_ism_agent[0][6] = sbr_ep6_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][6] = sbr_ep6_vintf.side_ism_fabric;

    assign sbr_ep6_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][6];
    assign sbr_pmu_vintf.side_clkreq[0][6] = sbr_ep6_vintf.side_clkreq;

    assign sbr_pmu_vintf.side_ism_agent[0][7] = sbr_ep7_vintf.side_ism_agent;
    assign sbr_pmu_vintf.side_ism_fabric[0][7] = sbr_ep7_vintf.side_ism_fabric;

    assign sbr_ep7_vintf.side_clkack = sbr_pmu_vintf.side_clkack[0][7];
    assign sbr_pmu_vintf.side_clkreq[0][7] = sbr_ep7_vintf.side_clkreq;
 
  
  //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
  
  power_intf   u_power_intf();
  comm_intf    u_comm_intf();
  iosf_pmu_intf pmu_sbr2_intf();


  event vintf_init_done;
  
  initial
    begin :INTF_WRAPPER_BLOCK

    // Dummy reference to trigger factory registration for tests
    iosfsbm_rtr_tests::rtr_base_test dummy;

    //Interface Wrappers for each i/f type used
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_8bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_16bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_32bit; 

    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(0) ) wrapper_fbrc_8bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(0) ) wrapper_fbrc_16bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(32), .AGENT_MASTERING_SB_IF(0) ) wrapper_fbrc_32bit; 
       
    iosfsbm_rtr::pwr_intf_wrapper wrapper_pwr_intf;
    iosfsbm_cm::comm_intf_wrapper wrapper_comm_intf;
    iosfsbm_debug::vintf_pmu_wrp wrapper_vintf_pmu_wrp;   

   iosfsbm_pmu::sbr_pmu_wrapper #(.MAX_NUM_OF_CLKS(1), .MAX_NUM_OF_RTRS(1) ) sbr_pmu_wrapper;

    //ep vintf wrapper
    iosfsbm_ipvc::ipvc_vintf_wrp#(.MAXPCMSTR(0),
                                  .MAXNPMSTR(0),
                                  .MAXPCTRGT(0),
                                  .MAXNPTRGT(0),
                                  .MAXTRGTADDR(47),
                                  .MAXTRGTDATA(63),
                                  .MAXMSTRADDR(47),
                                  .MAXMSTRDATA(63),
                                  .NUM_TX_EXT_HEADERS(1),
                                  .NUM_RX_EXT_HEADERS(1)) epvc_vintf_wrapper_i;
      
    //Create Bundle
    vintfBundle = new("vintfBundle");

    //Now fill up bundle with the i/f wrapper, connecting
    //actual interfaces to the virtual ones in the bundle
  wrapper_agt_8bit = new(sbr_ep0_vintf);
  vintfBundle.setData ("sbr_ep0_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_ep1_vintf);
  vintfBundle.setData ("sbr_ep1_vintf" , wrapper_agt_8bit);
  wrapper_agt_16bit = new(sbr_ep2_vintf);
  vintfBundle.setData ("sbr_ep2_vintf" , wrapper_agt_16bit);
  wrapper_agt_16bit = new(sbr_ep3_vintf);
  vintfBundle.setData ("sbr_ep3_vintf" , wrapper_agt_16bit);
  wrapper_agt_8bit = new(sbr_ep4_vintf);
  vintfBundle.setData ("sbr_ep4_vintf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr_ep5_vintf);
  vintfBundle.setData ("sbr_ep5_vintf" , wrapper_agt_8bit);
  wrapper_agt_16bit = new(sbr_ep6_vintf);
  vintfBundle.setData ("sbr_ep6_vintf" , wrapper_agt_16bit);
  wrapper_agt_16bit = new(sbr_ep7_vintf);
  vintfBundle.setData ("sbr_ep7_vintf" , wrapper_agt_16bit);

   //create ep interface wrapper, and pass interface name 
       epvc_vintf_wrapper_i = new(ep0_vintf);
       vintfBundle.setData ("ep0_vintf", epvc_vintf_wrapper_i);

       epvc_vintf_wrapper_i = new(ep1_vintf);
       vintfBundle.setData ("ep1_vintf", epvc_vintf_wrapper_i);
       
       epvc_vintf_wrapper_i = new(ep2_vintf);
       vintfBundle.setData ("ep2_vintf", epvc_vintf_wrapper_i);
       
       epvc_vintf_wrapper_i = new(ep3_vintf);
       vintfBundle.setData ("ep3_vintf", epvc_vintf_wrapper_i);
       
       epvc_vintf_wrapper_i = new(ep4_vintf);
       vintfBundle.setData ("ep4_vintf", epvc_vintf_wrapper_i);
       
       epvc_vintf_wrapper_i = new(ep5_vintf);
       vintfBundle.setData ("ep5_vintf", epvc_vintf_wrapper_i);
       
       epvc_vintf_wrapper_i = new(ep6_vintf);
       vintfBundle.setData ("ep6_vintf", epvc_vintf_wrapper_i);
       
       epvc_vintf_wrapper_i = new(ep7_vintf);
       vintfBundle.setData ("ep7_vintf", epvc_vintf_wrapper_i);
       
 
    wrapper_pwr_intf = new(u_power_intf);
    vintfBundle.setData ("power_intf_i", wrapper_pwr_intf);

    wrapper_comm_intf = new(u_comm_intf);
    vintfBundle.setData ("comm_intf_i", wrapper_comm_intf);

    wrapper_vintf_pmu_wrp = new(pmu_sbr2_intf);
    vintfBundle.setData("pmu_sbr2_intf", wrapper_vintf_pmu_wrp);
    set_config_string("*", "iosf_pmu_intf","iosf_pmu_intf_i"); 
    set_config_object("*", "vintf_pmu_wrp", wrapper_vintf_pmu_wrp,0);     

    sbr_pmu_wrapper = new(sbr_pmu_vintf);
    vintfBundle.setData ("sbr_pmu_vintf", sbr_pmu_wrapper);

  
    //Pass config info to the environment
    //pass comm_intf name string
    set_config_string("*", "comm_intf_name", "comm_intf_i");      

    //pass Bundle
    set_config_object("*", SB_VINTF_BUNDLE_NAME, vintfBundle, 0);    

    ovm_default_printer = ovm_default_line_printer;
  
    // Print header
     `ifdef OVM11
      ovm_top.report_header();
     `endif
    // Execute test
    run_test();

    // Print summary
    `ifdef OVM11
      ovm_top.report_summarize(); 
     `endif

     // Print Test Result
     svlib_pkg::ovm_report_utils::printTestStatus();


    // Finish gracefully
    
 end   :INTF_WRAPPER_BLOCK 

 `ifdef FSDB  
 initial
   begin
      $fsdbDumpvars(0,"tb_lv0_sbr_cfg_1_ep_rtl");
   end
 `endif


   //Need to turn off "payload size = 8/16" compmon assertion 
   //and also multiple np broadcast message related assertions for rtr-rtr link  
   initial
     begin
        
     end

endmodule 

