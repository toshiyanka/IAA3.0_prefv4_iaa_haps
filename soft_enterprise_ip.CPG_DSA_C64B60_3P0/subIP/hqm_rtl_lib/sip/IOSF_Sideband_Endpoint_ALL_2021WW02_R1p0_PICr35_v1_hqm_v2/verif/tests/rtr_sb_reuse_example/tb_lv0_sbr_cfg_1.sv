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

module tb_lv0_sbr_cfg_1 ;
   
  // misc wires.


  // Instantiate DUT and provide port connections
sbr sbr (
  .fscan_latchopen ( 1'b0 ),
  .fscan_latchclosed_b ( 1'b1 ),
  .fscan_clkungate (1'b0),
  .fscan_rstbypen  ('0),
  .clk  ( iosf_pmu_vintf.fbrc_clks[0]  ),
  .rstb  ( iosf_pmu_vintf.resets[0]  ),
  .p0_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][0] ),
  .p0_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][0] ),
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
  .p1_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][1] ),
  .p1_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][1] ),
  .pd1_pwrgd ( 1'b1), 
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
  .p2_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][2] ),
  .p2_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][2] ),
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
  .p3_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][3] ),
  .p3_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][3] ),
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
  .p4_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][4] ),
  .p4_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][4] ),
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
  .p5_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][5] ),
  .p5_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][5] ),
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
  .p6_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][6] ),
  .p6_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][6] ),
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
  .p7_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][7] ),
  .p7_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][7] ),
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
  .sbr_idle    ( iosf_pmu_vintf.fbrc_idle[0]  ));



  

  
  // Communication matrix
  // ====================

  // Interface instances for each agent
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep0_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][0] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep1_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][1] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep2_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][2] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep3_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][3] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep4_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][4] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep5_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][5] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep6_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][6] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep7_vintf    ( .side_clk( iosf_pmu_vintf.agt_clks[0][7] ), .side_rst_b ( iosf_pmu_vintf.resets[0] ) );



 
  //ignore this since you are not using pmu_vc
  iosf_pmu_intf #( .NUM_OF_FBRCS(1)) iosf_pmu_vintf(.clocks(clk_rst_intf.clocks), .resets(clk_rst_intf.resets));
  clk_rst_intf clk_rst_intf();
   



    //ignore this as well, since this is required for pmu vc only.
     //but you will need to provideside_clkack input to the VV
    assign sbr_ep0_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][0];
    assign iosf_pmu_vintf.side_clkreq[0][0] = sbr_ep0_vintf.side_clkreq;

    assign sbr_ep1_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][1];
    assign iosf_pmu_vintf.side_clkreq[0][1] = sbr_ep1_vintf.side_clkreq;

    assign sbr_ep2_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][2];
    assign iosf_pmu_vintf.side_clkreq[0][2] = sbr_ep2_vintf.side_clkreq;

    assign sbr_ep3_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][3];
    assign iosf_pmu_vintf.side_clkreq[0][3] = sbr_ep3_vintf.side_clkreq;

    assign sbr_ep4_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][4];
    assign iosf_pmu_vintf.side_clkreq[0][4] = sbr_ep4_vintf.side_clkreq;

    assign sbr_ep5_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][5];
    assign iosf_pmu_vintf.side_clkreq[0][5] = sbr_ep5_vintf.side_clkreq;

    assign sbr_ep6_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][6];
    assign iosf_pmu_vintf.side_clkreq[0][6] = sbr_ep6_vintf.side_clkreq;

    assign sbr_ep7_vintf.side_clkack = iosf_pmu_vintf.side_clkack[0][7];
    assign iosf_pmu_vintf.side_clkreq[0][7] = sbr_ep7_vintf.side_clkreq;
 

   
  //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
 
  event vintf_init_done;
  
  initial
    begin :INTF_WRAPPER_BLOCK

    // Dummy reference to trigger factory registration for tests
    iosfsbm_rtr_tests::rtr_base_test dummy;

    //Interface Wrappers for each i/f type used
    // for this example tb, I haveinterfaces with 2 differente
    //payload width and both are agent interface so
    // i need to create 2 wrappers
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_8bit; 
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_16bit; 
 
       //ignore this since clk_rst and pmu VC are not being reused
       clk_rst::clk_rst_intf_wrapper wrapper_clk_rst_intf;         
       iosf_pmu::iosf_pmu_wrapper #(.NUM_OF_FBRCS(1) ) iosf_pmu_wrapper;

       
    //Create the Bundle
    vintfBundle = new("vintfBundle");

    //Now fill up bundle with the i/f wrapper, connecting
    //actual interfaces to the virtual ones in the bundle
  wrapper_agt_8bit = new(sbr_ep0_vintf);
  vintfBundle.setData ("sbr_ep0_vintf" , wrapper_agt_8bit); //"sbr_ep0_vintf" should match with the intf_name config object of the agent VC
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

   //ignore this, only used for clk_rst and PMU VC.   
    wrapper_clk_rst_intf = new(clk_rst_intf);
    vintfBundle.setData ("clk_rst_vintf", wrapper_clk_rst_intf);
   iosf_pmu_wrapper = new(iosf_pmu_vintf);
    vintfBundle.setData ("iosf_pmu_vintf", iosf_pmu_wrapper);
        
    

    //pass Bundle to all VCs
    set_config_object("*", SB_VINTF_BUNDLE_NAME, vintfBundle, 0);    

    ovm_default_printer = ovm_default_line_printer;
  
 
    // Execute test
    run_test();

 
     // Print Test Result
     svlib_pkg::ovm_report_utils::printTestStatus();


    // Finish gracefully
    
 end   :INTF_WRAPPER_BLOCK 

 `ifdef FSDB  
 initial
   begin
      $fsdbDumpvars(0,"tb_lv0_sbr_cfg_1");
   end
 `endif


   //Need to turn off "payload size = 8/16", 
   //ism state and sai related assertions assertions for rtr-rtr link  
   initial
     begin
        
     end

endmodule 

