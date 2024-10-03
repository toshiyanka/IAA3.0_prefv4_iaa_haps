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
//
module tb_top;
`else   
module tb_fpv_sbr ;
`endif
   
  // misc wires.


  // Instantiate DUT
sbr sbr (
  .fscan_latchopen ( 1'b0 ),
  .fscan_latchclosed_b ( 1'b1 ),
  .fscan_clkungate (1'b0),
  .fscan_rstbypen  ('0),
  .clk  ( iosf_pmu_vintf.fbrc_clks[0]  ),
  .rstb  ( iosf_pmu_vintf.resets[0]  ),
  .p0_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][0] ),
  .p0_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][0] ),
  .sbr_ep0_side_ism_fabric ( iosf_sbr_ti.sbr_ep0_side_ism_fabric ),
  .ep0_sbr_side_ism_agent  ( iosf_sbr_ti.sbr_ep0_side_ism_agent  ),
  .sbr_ep0_pccup (  iosf_sbr_ti.sbr_ep0_mpccup  ), 
  .ep0_sbr_pccup (  iosf_sbr_ti.sbr_ep0_tpccup  ), 
  .sbr_ep0_npcup (  iosf_sbr_ti.sbr_ep0_mnpcup  ), 
  .ep0_sbr_npcup (  iosf_sbr_ti.sbr_ep0_tnpcup  ), 
  .sbr_ep0_pcput (  iosf_sbr_ti.sbr_ep0_tpcput  ), 
  .ep0_sbr_pcput (  iosf_sbr_ti.sbr_ep0_mpcput  ), 
  .sbr_ep0_npput (  iosf_sbr_ti.sbr_ep0_tnpput  ), 
  .ep0_sbr_npput (  iosf_sbr_ti.sbr_ep0_mnpput  ), 
  .sbr_ep0_eom (  iosf_sbr_ti.sbr_ep0_teom  ), 
  .ep0_sbr_eom (  iosf_sbr_ti.sbr_ep0_meom  ), 
  .sbr_ep0_payload (  iosf_sbr_ti.sbr_ep0_tpayload  ), 
  .ep0_sbr_payload (  iosf_sbr_ti.sbr_ep0_mpayload  ), 
  .p1_fab_init_idle_exit            ( iosf_pmu_vintf.fab_init_idle_exit[0][1] ),
  .p1_fab_init_idle_exit_ack        ( iosf_pmu_vintf.fab_init_idle_exit_ack[0][1] ),
  .pd1_pwrgd ( u_power_intf.powergood[1] ), 
  .sbr_ep1_side_ism_fabric ( iosf_sbr_ti.sbr_ep1_side_ism_fabric ),
  .ep1_sbr_side_ism_agent  ( iosf_sbr_ti.sbr_ep1_side_ism_agent  ),
  .sbr_ep1_pccup (  iosf_sbr_ti.sbr_ep1_mpccup  ), 
  .ep1_sbr_pccup (  iosf_sbr_ti.sbr_ep1_tpccup  ), 
  .sbr_ep1_npcup (  iosf_sbr_ti.sbr_ep1_mnpcup  ), 
  .ep1_sbr_npcup (  iosf_sbr_ti.sbr_ep1_tnpcup  ), 
  .sbr_ep1_pcput (  iosf_sbr_ti.sbr_ep1_tpcput  ), 
  .ep1_sbr_pcput (  iosf_sbr_ti.sbr_ep1_mpcput  ), 
  .sbr_ep1_npput (  iosf_sbr_ti.sbr_ep1_tnpput  ), 
  .ep1_sbr_npput (  iosf_sbr_ti.sbr_ep1_mnpput  ), 
  .sbr_ep1_eom (  iosf_sbr_ti.sbr_ep1_teom  ), 
  .ep1_sbr_eom (  iosf_sbr_ti.sbr_ep1_meom  ), 
  .sbr_ep1_payload (  iosf_sbr_ti.sbr_ep1_tpayload  ), 
  .ep1_sbr_payload (  iosf_sbr_ti.sbr_ep1_mpayload  ), 
  .sbr_idle    ( iosf_pmu_vintf.fbrc_idle[0]  ));



  

  
  // Communication matrix
  // ====================

  // TestIsland instances
  iosf_sbr_ti iosf_sbr_ti(
  .sbr_ep0_side_clk(iosf_pmu_vintf.agt_clks[0][0]),
  .sbr_ep0_side_rst_b(iosf_pmu_vintf.resets[0]),
  .sbr_ep0_side_clkack(iosf_pmu_vintf.clkack[0][0]),
  .sbr_ep0_side_clkreq(iosf_pmu_vintf.clkreq[0][0]),

  .sbr_ep1_side_clk(iosf_pmu_vintf.agt_clks[0][1]),
  .sbr_ep1_side_rst_b(iosf_pmu_vintf.resets[0]),
  .sbr_ep1_side_clkack(iosf_pmu_vintf.clkack[0][1]),
  .sbr_ep1_side_clkreq(iosf_pmu_vintf.clkreq[0][1]));






 

  iosf_pmu_intf #( .NUM_OF_FBRCS(1)) iosf_pmu_vintf(.clocks(clk_rst_intf.clocks), .resets(clk_rst_intf.resets));

 

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
  //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
  
  power_intf   u_power_intf();
  comm_intf    u_comm_intf();
  iosf_sbr_pmu_intf pmu_sbr2_intf();
  clk_rst_intf clk_rst_intf();
   


  event vintf_init_done;
  
  initial
    begin :INTF_WRAPPER_BLOCK

    // Dummy reference to trigger factory registration for tests
    iosfsbm_rtr_tests::rtr_base_test dummy;
  
    iosfsbm_rtr::pwr_intf_wrapper wrapper_pwr_intf;
    iosfsbm_cm::comm_intf_wrapper wrapper_comm_intf;
    iosfsbm_debug::vintf_pmu_wrp wrapper_vintf_pmu_wrp;
    clk_rst::clk_rst_intf_wrapper wrapper_clk_rst_intf;
       

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
   iosf_pmu::iosf_pmu_wrapper #(.NUM_OF_FBRCS(1) ) iosf_pmu_wrapper;

       
    //Create Bundle
    vintfBundle = new("vintfBundle");

    //Now fill up bundle with the i/f wrapper, connecting
    //actual interfaces to the virtual ones in the bundle


  
    wrapper_pwr_intf = new(u_power_intf);
    vintfBundle.setData ("power_intf_i", wrapper_pwr_intf);

    wrapper_comm_intf = new(u_comm_intf);
    vintfBundle.setData ("comm_intf_i", wrapper_comm_intf);

    wrapper_clk_rst_intf = new(clk_rst_intf);
    vintfBundle.setData ("clk_rst_vintf", wrapper_clk_rst_intf);
       
    wrapper_vintf_pmu_wrp = new(pmu_sbr2_intf);
    vintfBundle.setData("pmu_sbr2_intf", wrapper_vintf_pmu_wrp);
    set_config_string("*", "iosf_sbr_pmu_intf","iosf_sbr_pmu_intf_i"); 
    set_config_object("*", "vintf_pmu_wrp", wrapper_vintf_pmu_wrp,0);     

    iosf_pmu_wrapper = new(iosf_pmu_vintf);
    vintfBundle.setData ("iosf_pmu_vintf", iosf_pmu_wrapper);

  
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
      $fsdbDumpvars(0,"tb_fpv_sbr");
   end
 `endif


   //Need to turn off "payload size = 8/16", 
   //ism state and sai related assertions assertions for rtr-rtr link  
   initial
     begin
        
     end

endmodule 

module iosf_sbr_ti (

  //port declaration for sbr_ep0 link
  input wire sbr_ep0_side_clk, 
  input wire sbr_ep0_side_rst_b, 
  input wire [2:0] sbr_ep0_side_ism_fabric,
  output wire [2:0] sbr_ep0_side_ism_agent,
  output wire sbr_ep0_side_clkreq, 
  input wire sbr_ep0_side_clkack, 
  input wire sbr_ep0_mpccup, 
  output wire sbr_ep0_tpccup, 
  input wire sbr_ep0_mnpcup, 
  output wire sbr_ep0_tnpcup, 
  input wire  sbr_ep0_tpcput, 
  output wire sbr_ep0_mpcput, 
  input wire  sbr_ep0_tnpput, 
  output wire sbr_ep0_mnpput, 
  input wire  sbr_ep0_teom, 
  output wire sbr_ep0_meom, 
  input wire [7:0] sbr_ep0_tpayload, 
  output wire [7:0] sbr_ep0_mpayload, 

  //port declaration for sbr_ep1 link
  input wire sbr_ep1_side_clk, 
  input wire sbr_ep1_side_rst_b, 
  input wire [2:0] sbr_ep1_side_ism_fabric,
  output wire [2:0] sbr_ep1_side_ism_agent,
  output wire sbr_ep1_side_clkreq, 
  input wire sbr_ep1_side_clkack, 
  input wire sbr_ep1_mpccup, 
  output wire sbr_ep1_tpccup, 
  input wire sbr_ep1_mnpcup, 
  output wire sbr_ep1_tnpcup, 
  input wire  sbr_ep1_tpcput, 
  output wire sbr_ep1_mpcput, 
  input wire  sbr_ep1_tnpput, 
  output wire sbr_ep1_mnpput, 
  input wire  sbr_ep1_teom, 
  output wire sbr_ep1_meom, 
  input wire [7:0] sbr_ep1_tpayload, 
  output wire [7:0] sbr_ep1_mpayload);



  //Test Island instance for sbr_ep0 link
  iosf_sb_ti #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1), .INTF_NAME("sbr_ep0_vintf"), .IS_ACTIVE(1) ) sbr_ep0_ti(
  .side_clk(iosf_sbr_ti.sbr_ep0_side_clk),
  .side_rst_b(iosf_sbr_ti.sbr_ep0_side_rst_b),
  .side_ism_fabric(iosf_sbr_ti.sbr_ep0_side_ism_fabric), 
  .side_ism_agent(iosf_sbr_ti.sbr_ep0_side_ism_agent), 
  .side_clkack(iosf_sbr_ti.sbr_ep0_side_clkack), 
  .side_clkreq(iosf_sbr_ti.sbr_ep0_side_clkreq), 
  .mpccup(iosf_sbr_ti.sbr_ep0_mpccup),  
  .tpccup(iosf_sbr_ti.sbr_ep0_tpccup),  
  .mnpcup(iosf_sbr_ti.sbr_ep0_mnpcup),  
  .tnpcup(iosf_sbr_ti.sbr_ep0_tnpcup),  
  .mpcput(iosf_sbr_ti.sbr_ep0_mpcput), 
  .tpcput(iosf_sbr_ti.sbr_ep0_tpcput), 
  .mnpput(iosf_sbr_ti.sbr_ep0_mnpput), 
  .tnpput(iosf_sbr_ti.sbr_ep0_tnpput), 
  .meom(iosf_sbr_ti.sbr_ep0_meom), 
  .teom(iosf_sbr_ti.sbr_ep0_teom), 
  .tpayload(iosf_sbr_ti.sbr_ep0_tpayload), 
  .mpayload(iosf_sbr_ti.sbr_ep0_mpayload));


  //Test Island instance for sbr_ep1 link
  iosf_sb_ti #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1), .INTF_NAME("sbr_ep1_vintf"), .IS_ACTIVE(1) ) sbr_ep1_ti(
  .side_clk(iosf_sbr_ti.sbr_ep1_side_clk),
  .side_rst_b(iosf_sbr_ti.sbr_ep1_side_rst_b),
  .side_ism_fabric(iosf_sbr_ti.sbr_ep1_side_ism_fabric), 
  .side_ism_agent(iosf_sbr_ti.sbr_ep1_side_ism_agent), 
  .side_clkack(iosf_sbr_ti.sbr_ep1_side_clkack), 
  .side_clkreq(iosf_sbr_ti.sbr_ep1_side_clkreq), 
  .mpccup(iosf_sbr_ti.sbr_ep1_mpccup),  
  .tpccup(iosf_sbr_ti.sbr_ep1_tpccup),  
  .mnpcup(iosf_sbr_ti.sbr_ep1_mnpcup),  
  .tnpcup(iosf_sbr_ti.sbr_ep1_tnpcup),  
  .mpcput(iosf_sbr_ti.sbr_ep1_mpcput), 
  .tpcput(iosf_sbr_ti.sbr_ep1_tpcput), 
  .mnpput(iosf_sbr_ti.sbr_ep1_mnpput), 
  .tnpput(iosf_sbr_ti.sbr_ep1_tnpput), 
  .meom(iosf_sbr_ti.sbr_ep1_meom), 
  .teom(iosf_sbr_ti.sbr_ep1_teom), 
  .tpayload(iosf_sbr_ti.sbr_ep1_tpayload), 
  .mpayload(iosf_sbr_ti.sbr_ep1_mpayload));

 endmodule

 