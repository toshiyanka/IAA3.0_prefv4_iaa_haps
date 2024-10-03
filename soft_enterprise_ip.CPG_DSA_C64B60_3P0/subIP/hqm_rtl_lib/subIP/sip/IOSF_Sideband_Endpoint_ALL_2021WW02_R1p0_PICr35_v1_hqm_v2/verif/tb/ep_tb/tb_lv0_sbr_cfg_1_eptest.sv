import ovm_pkg::*;
import svlib_pkg::*;

//  single pattsburg router dut testbench

module tb_lv0_sbr_cfg_1 ;

  // misc wires.
  wire [2:0]sbr_ep0_side_ism_fabric; //sbr_ep0_responder.ism_state ),
  wire [2:0]ep0_sbr_side_ism_agent; //sbr_ep0_driver.ism_state ),
  wire ep0_sbr_clkreq; //.clkreq ),
  wire sbr_ep0_pccup; //sbr_ep0_driver.pccup  ), 
  wire ep0_sbr_pccup; //sbr_ep0_responder.pccup  ), 
  wire sbr_ep0_npcup; //sbr_ep0_driver.npcup  ), 
  wire ep0_sbr_npcup; //sbr_ep0_responder.npcup  ), 
  wire sbr_ep0_pcput; //sbr_ep0_responder.pcput  ), 
  wire ep0_sbr_pcput; //sbr_ep0_driver.pcput  ), 
  wire sbr_ep0_npput; //sbr_ep0_responder.npput  ), 
  wire ep0_sbr_npput; //sbr_ep0_driver.npput  ), 
  wire sbr_ep0_eom; //sbr_ep0_responder.eom  ), 
  wire ep0_sbr_eom; //sbr_ep0_driver.eom  ), 
  wire [7:0] sbr_ep0_payload; //sbr_ep0_responder.payload  ), 
  wire [7:0] ep0_sbr_payload; //sbr_ep0_driver.payload  ), 
  wire       sbr_ep0_clkack;

  // Instantiate DUT
sbr sbr (
  .dt_latchopen ( 1'b0 ),
  .dt_latchclosed_b ( 1'b1 ),
  .su_local_ugt (1'b0),
  .clk  ( u_clk_rst_intf.clocks[0]  ),
  .rstb  ( u_clk_rst_intf.resets[0]  ),
  .sbr_ep0_side_ism_fabric ( sbr_ep0_side_ism_fabric), 
  .ep0_sbr_side_ism_agent     ( ep0_sbr_side_ism_agent),
  .ep0_sbr_side_clkreq          ( ep0_sbr_clkreq), 
  .sbr_ep0_side_clkack          ( sbr_ep0_clkack), 

  .sbr_ep0_pccup (  sbr_ep0_pccup), //sbr_ep0_driver.pccup  ), 
  .ep0_sbr_pccup (  ep0_sbr_pccup), //sbr_ep0_responder.pccup  ), 
  .sbr_ep0_npcup (  sbr_ep0_npcup), //sbr_ep0_driver.npcup  ), 
  .ep0_sbr_npcup (  ep0_sbr_npcup), //sbr_ep0_responder.npcup  ), 
  .sbr_ep0_pcput (  sbr_ep0_pcput), //sbr_ep0_responder.pcput  ), 
  .ep0_sbr_pcput (  ep0_sbr_pcput), //sbr_ep0_driver.pcput  ), 
  .sbr_ep0_npput (  sbr_ep0_npput), //sbr_ep0_responder.npput  ), 
  .ep0_sbr_npput (  ep0_sbr_npput), //sbr_ep0_driver.npput  ), 
  .sbr_ep0_eom (  sbr_ep0_eom), //sbr_ep0_responder.eom  ), 
  .ep0_sbr_eom (  ep0_sbr_eom), //sbr_ep0_driver.eom  ), 
  .sbr_ep0_payload (  sbr_ep0_payload), //sbr_ep0_responder.payload  ), 
  .ep0_sbr_payload (  ep0_sbr_payload), //sbr_ep0_driver.payload  ), 
  .pd1_pwrgd ( u_power_intf.powergood[1] ), 
  .sbr_ep1_side_ism_fabric ( sbr_ep1_vintf.side_ism_fabric ),
  .ep1_sbr_side_ism_agent  ( sbr_ep1_vintf.side_ism_agent  ),
  .ep1_sbr_side_clkreq     ( sbr_ep1_vintf.side_clkreq ),
  .sbr_ep1_side_clkack     ( sbr_ep1_vintf.side_clkack ),
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
  .sbr_ep2_side_ism_fabric ( sbr_ep2_vintf.side_ism_fabric ),
  .ep2_sbr_side_ism_agent  ( sbr_ep2_vintf.side_ism_agent  ),
  .ep2_sbr_side_clkreq     ( sbr_ep2_vintf.side_clkreq ),
  .sbr_ep2_side_clkack     ( sbr_ep2_vintf.side_clkack ),
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
  .sbr_ep3_side_ism_fabric ( sbr_ep3_vintf.side_ism_fabric ),
  .ep3_sbr_side_ism_agent  ( sbr_ep3_vintf.side_ism_agent  ),
  .ep3_sbr_side_clkreq     ( sbr_ep3_vintf.side_clkreq ),
  .sbr_ep3_side_clkack     ( sbr_ep3_vintf.side_clkack ),
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
  .sbr_ep4_side_ism_fabric ( sbr_ep4_vintf.side_ism_fabric ),
  .ep4_sbr_side_ism_agent  ( sbr_ep4_vintf.side_ism_agent  ),
  .ep4_sbr_side_clkreq     ( sbr_ep4_vintf.side_clkreq ),
  .sbr_ep4_side_clkack     ( sbr_ep4_vintf.side_clkack ),
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
  .sbr_ep5_side_ism_fabric ( sbr_ep5_vintf.side_ism_fabric ),
  .ep5_sbr_side_ism_agent  ( sbr_ep5_vintf.side_ism_agent  ),
  .ep5_sbr_side_clkreq     ( sbr_ep5_vintf.side_clkreq ),
  .sbr_ep5_side_clkack     ( sbr_ep5_vintf.side_clkack ),
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
  .sbr_ep6_side_ism_fabric ( sbr_ep6_vintf.side_ism_fabric ),
  .ep6_sbr_side_ism_agent  ( sbr_ep6_vintf.side_ism_agent  ),
  .ep6_sbr_side_clkreq     ( sbr_ep6_vintf.side_clkreq ),
  .sbr_ep6_side_clkack     ( sbr_ep6_vintf.side_clkack ),
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
  .sbr_ep7_side_ism_fabric ( sbr_ep7_vintf.side_ism_fabric ),
  .ep7_sbr_side_ism_agent  ( sbr_ep7_vintf.side_ism_agent  ),
  .ep7_sbr_side_clkreq     ( sbr_ep7_vintf.side_clkreq ),
  .sbr_ep7_side_clkack     ( sbr_ep7_vintf.side_clkack ),
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
  .ep7_sbr_payload (  sbr_ep7_vintf.mpayload  ));

 // Instantiate DUT(back-2-back EP)
 //P0- Fabric Node
 //P1- Agent Node
 sbetb2port sbetest (
                      .side_clk ( u_clk_rst_intf.clocks[0] ),
                      .side_rst_b ( u_clk_rst_intf.resets[0] ),

                      .p0_side_ism_fabric ( sbr_ep0_vintf.side_ism_fabric ),
                      .p0_side_ism_agent  ( sbr_ep0_vintf.side_ism_agent ),
                      .p0_side_clkreq     ( sbr_ep0_vintf.side_clkreq ),
                      .p0_side_clkack     ( sbr_ep0_vintf.side_clkack ),
                      .p0_tpccup (  sbr_ep0_vintf.mpccup  ), 
                      .p0_mpccup (  sbr_ep0_vintf.tpccup  ), 
                      .p0_tnpcup (  sbr_ep0_vintf.mnpcup  ), 
                      .p0_mnpcup (  sbr_ep0_vintf.tnpcup  ), 
                      .p0_mpcput (  sbr_ep0_vintf.tpcput  ), 
                      .p0_tpcput (  sbr_ep0_vintf.mpcput  ), 
                      .p0_mnpput (  sbr_ep0_vintf.tnpput  ), 
                      .p0_tnpput (  sbr_ep0_vintf.mnpput  ), 
                      .p0_meom (  sbr_ep0_vintf.teom      ), 
                      .p0_teom (  sbr_ep0_vintf.meom      ), 
                      .p0_mpayload (  sbr_ep0_vintf.tpayload  ), 
                      .p0_tpayload (  sbr_ep0_vintf.mpayload  ),

                      .p1_side_ism_fabric ( sbr_ep0_side_ism_fabric ),
                      .p1_side_ism_agent  ( ep0_sbr_side_ism_agent  ),
                      .p1_side_clkreq     ( ep0_sbr_clkreq ),
                      .p1_side_clkack     ( sbr_ep0_clkack ),
                      .p1_mpccup (  sbr_ep0_pccup  ), 
                      .p1_tpccup (  ep0_sbr_pccup  ), 
                      .p1_mnpcup (  sbr_ep0_npcup  ), 
                      .p1_tnpcup (  ep0_sbr_npcup  ), 
                      .p1_tpcput (  sbr_ep0_pcput  ), 
                      .p1_mpcput (  ep0_sbr_pcput  ), 
                      .p1_tnpput (  sbr_ep0_npput  ), 
                      .p1_mnpput (  ep0_sbr_npput  ), 
                      .p1_teom (  sbr_ep0_eom  ), 
                      .p1_meom (  ep0_sbr_eom  ), 
                      .p1_tpayload (  sbr_ep0_payload  ), 
                      .p1_mpayload (  ep0_sbr_payload  ) );
                      


  // Communication matrix
  // ====================

  // Interface instances
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep0_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep1_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep2_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep3_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep4_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr_ep5_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep6_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.PAYLOAD_WIDTH(16), .AGENT_MASTERING_SB_IF(1) ) sbr_ep7_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );

  //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
  
  clk_rst_intf u_clk_rst_intf();
  power_intf   u_power_intf();
  comm_intf comm_intf_i();
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
       
    iosfsbm_rtr::pwr_intf_wrapper wrapper_pwr_intf;
    iosfsbm_cm::comm_intf_wrapper wrapper_comm_intf;
    iosfsbm_rtr::clk_rst_intf_wrapper wrapper_clkrst_intf;
    iosfsbm_debug::vintf_pmu_wrp wrapper_vintf_pmu_wrp;   

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

  wrapper_pwr_intf = new(u_power_intf);
  vintfBundle.setData ("power_intf_i", wrapper_pwr_intf);
       
  wrapper_clkrst_intf = new(u_clk_rst_intf);
  vintfBundle.setData ("clk_rst_intf_i", wrapper_clkrst_intf);
       
  wrapper_comm_intf = new(comm_intf_i);
  vintfBundle.setData ("comm_intf_i", wrapper_comm_intf);
     
    //Pass config info to the environment
    //pass comm_intf name string
    set_config_string("*", "comm_intf_name", "comm_intf_i");      

    //pass Bundle
    set_config_object("*", SB_VINTF_BUNDLE_NAME, vintfBundle, 0); 
    wrapper_vintf_pmu_wrp = new(pmu_sbr2_intf);
    vintfBundle.setData("pmu_sbr2_intf", wrapper_vintf_pmu_wrp);

    set_config_string("*", "iosf_pmu_intf","iosf_pmu_intf_i");
    set_config_object("*", "vintf_pmu_wrp", wrapper_vintf_pmu_wrp,0);   

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
 
  end   :INTF_WRAPPER_BLOCK



endmodule :tb_lv0_sbr_cfg_1

