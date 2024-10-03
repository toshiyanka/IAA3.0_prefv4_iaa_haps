import ovm_pkg::*;
import svlib_pkg::*;
import lnc_sbbfm_pkg::*;
import lnc_sbbfm_tr_pkg::*;
import lnc_sbbfm_bfladap_pkg::*;



module tb_8port_lncbfm ;

  // misc wires.

wire [2:0] sbr8pt_ep7_side_ism_fabric_wire ;
wire [2:0] ep7_sbr8pt_side_ism_agent_wire ;
wire ep7_sbr8pt_clkreq_wire; 
wire sbr8pt_ep7_clkack_wire; 
wire sbr8pt_ep7_pccup_wire ;
wire ep7_sbr8pt_pccup_wire ;
wire sbr8pt_ep7_npcup_wire ;
wire ep7_sbr8pt_npcup_wire ;
wire sbr8pt_ep7_pcput_wire ;
wire ep7_sbr8pt_pcput_wire ;
wire sbr8pt_ep7_npput_wire ;
wire ep7_sbr8pt_npput_wire ;
wire sbr8pt_ep7_eom_wire ;
wire ep7_sbr8pt_eom_wire ;
wire [7:0] sbr8pt_ep7_payload_wire ;
wire [7:0] ep7_sbr8pt_payload_wire;
  
  // Instantiate DUT

sbr8pt sbr8pt (
  .dt_latchopen ( 1'b0 ),
  .dt_latchclosed_b ( 1'b1 ),
  .su_local_ugt (1'b0),
  .clk  ( u_clk_rst_intf.clocks[0]  ),
  .rstb  ( u_clk_rst_intf.resets[0]  ),
  .sbr8pt_ep0_side_ism_fabric ( sbr8pt_ep0_vintf.side_ism_fabric ),
  .ep0_sbr8pt_side_ism_agent  ( sbr8pt_ep0_vintf.side_ism_agent  ),
  .ep0_sbr8pt_side_clkreq     ( sbr8pt_ep0_vintf.side_clkreq ),
  .sbr8pt_ep0_side_clkack     ( sbr8pt_ep0_vintf.side_clkack ),
  .sbr8pt_ep0_pccup (  sbr8pt_ep0_vintf.mpccup  ), 
  .ep0_sbr8pt_pccup (  sbr8pt_ep0_vintf.tpccup  ), 
  .sbr8pt_ep0_npcup (  sbr8pt_ep0_vintf.mnpcup  ), 
  .ep0_sbr8pt_npcup (  sbr8pt_ep0_vintf.tnpcup  ), 
  .sbr8pt_ep0_pcput (  sbr8pt_ep0_vintf.tpcput  ), 
  .ep0_sbr8pt_pcput (  sbr8pt_ep0_vintf.mpcput  ), 
  .sbr8pt_ep0_npput (  sbr8pt_ep0_vintf.tnpput  ), 
  .ep0_sbr8pt_npput (  sbr8pt_ep0_vintf.mnpput  ), 
  .sbr8pt_ep0_eom (  sbr8pt_ep0_vintf.teom  ), 
  .ep0_sbr8pt_eom (  sbr8pt_ep0_vintf.meom  ), 
  .sbr8pt_ep0_payload (  sbr8pt_ep0_vintf.tpayload  ), 
  .ep0_sbr8pt_payload (  sbr8pt_ep0_vintf.mpayload  ), 
  .sbr8pt_ep1_side_ism_fabric ( sbr8pt_ep1_vintf.side_ism_fabric ),
  .ep1_sbr8pt_side_ism_agent  ( sbr8pt_ep1_vintf.side_ism_agent  ),
  .ep1_sbr8pt_side_clkreq     ( sbr8pt_ep1_vintf.side_clkreq ),
  .sbr8pt_ep1_side_clkack     ( sbr8pt_ep1_vintf.side_clkack ),
  .sbr8pt_ep1_pccup (  sbr8pt_ep1_vintf.mpccup  ), 
  .ep1_sbr8pt_pccup (  sbr8pt_ep1_vintf.tpccup  ), 
  .sbr8pt_ep1_npcup (  sbr8pt_ep1_vintf.mnpcup  ), 
  .ep1_sbr8pt_npcup (  sbr8pt_ep1_vintf.tnpcup  ), 
  .sbr8pt_ep1_pcput (  sbr8pt_ep1_vintf.tpcput  ), 
  .ep1_sbr8pt_pcput (  sbr8pt_ep1_vintf.mpcput  ), 
  .sbr8pt_ep1_npput (  sbr8pt_ep1_vintf.tnpput  ), 
  .ep1_sbr8pt_npput (  sbr8pt_ep1_vintf.mnpput  ), 
  .sbr8pt_ep1_eom (  sbr8pt_ep1_vintf.teom  ), 
  .ep1_sbr8pt_eom (  sbr8pt_ep1_vintf.meom  ), 
  .sbr8pt_ep1_payload (  sbr8pt_ep1_vintf.tpayload  ), 
  .ep1_sbr8pt_payload (  sbr8pt_ep1_vintf.mpayload  ), 
  .sbr8pt_ep2_side_ism_fabric ( sbr8pt_ep2_vintf.side_ism_fabric ),
  .ep2_sbr8pt_side_ism_agent  ( sbr8pt_ep2_vintf.side_ism_agent  ),
  .ep2_sbr8pt_side_clkreq     ( sbr8pt_ep2_vintf.side_clkreq ),
  .sbr8pt_ep2_side_clkack     ( sbr8pt_ep2_vintf.side_clkack ),
  .sbr8pt_ep2_pccup (  sbr8pt_ep2_vintf.mpccup  ), 
  .ep2_sbr8pt_pccup (  sbr8pt_ep2_vintf.tpccup  ), 
  .sbr8pt_ep2_npcup (  sbr8pt_ep2_vintf.mnpcup  ), 
  .ep2_sbr8pt_npcup (  sbr8pt_ep2_vintf.tnpcup  ), 
  .sbr8pt_ep2_pcput (  sbr8pt_ep2_vintf.tpcput  ), 
  .ep2_sbr8pt_pcput (  sbr8pt_ep2_vintf.mpcput  ), 
  .sbr8pt_ep2_npput (  sbr8pt_ep2_vintf.tnpput  ), 
  .ep2_sbr8pt_npput (  sbr8pt_ep2_vintf.mnpput  ), 
  .sbr8pt_ep2_eom (  sbr8pt_ep2_vintf.teom  ), 
  .ep2_sbr8pt_eom (  sbr8pt_ep2_vintf.meom  ), 
  .sbr8pt_ep2_payload (  sbr8pt_ep2_vintf.tpayload  ), 
  .ep2_sbr8pt_payload (  sbr8pt_ep2_vintf.mpayload  ), 
  .sbr8pt_ep3_side_ism_fabric ( sbr8pt_ep3_vintf.side_ism_fabric ),
  .ep3_sbr8pt_side_ism_agent  ( sbr8pt_ep3_vintf.side_ism_agent  ),
  .ep3_sbr8pt_side_clkreq     ( sbr8pt_ep3_vintf.side_clkreq ),
  .sbr8pt_ep3_side_clkack     ( sbr8pt_ep3_vintf.side_clkack ),
  .sbr8pt_ep3_pccup (  sbr8pt_ep3_vintf.mpccup  ), 
  .ep3_sbr8pt_pccup (  sbr8pt_ep3_vintf.tpccup  ), 
  .sbr8pt_ep3_npcup (  sbr8pt_ep3_vintf.mnpcup  ), 
  .ep3_sbr8pt_npcup (  sbr8pt_ep3_vintf.tnpcup  ), 
  .sbr8pt_ep3_pcput (  sbr8pt_ep3_vintf.tpcput  ), 
  .ep3_sbr8pt_pcput (  sbr8pt_ep3_vintf.mpcput  ), 
  .sbr8pt_ep3_npput (  sbr8pt_ep3_vintf.tnpput  ), 
  .ep3_sbr8pt_npput (  sbr8pt_ep3_vintf.mnpput  ), 
  .sbr8pt_ep3_eom (  sbr8pt_ep3_vintf.teom  ), 
  .ep3_sbr8pt_eom (  sbr8pt_ep3_vintf.meom  ), 
  .sbr8pt_ep3_payload (  sbr8pt_ep3_vintf.tpayload  ), 
  .ep3_sbr8pt_payload (  sbr8pt_ep3_vintf.mpayload  ), 
  .sbr8pt_ep4_side_ism_fabric ( sbr8pt_ep4_vintf.side_ism_fabric ),
  .ep4_sbr8pt_side_ism_agent  ( sbr8pt_ep4_vintf.side_ism_agent  ),
  .ep4_sbr8pt_side_clkreq     ( sbr8pt_ep4_vintf.side_clkreq ),
  .sbr8pt_ep4_side_clkack     ( sbr8pt_ep4_vintf.side_clkack ),
  .sbr8pt_ep4_pccup (  sbr8pt_ep4_vintf.mpccup  ), 
  .ep4_sbr8pt_pccup (  sbr8pt_ep4_vintf.tpccup  ), 
  .sbr8pt_ep4_npcup (  sbr8pt_ep4_vintf.mnpcup  ), 
  .ep4_sbr8pt_npcup (  sbr8pt_ep4_vintf.tnpcup  ), 
  .sbr8pt_ep4_pcput (  sbr8pt_ep4_vintf.tpcput  ), 
  .ep4_sbr8pt_pcput (  sbr8pt_ep4_vintf.mpcput  ), 
  .sbr8pt_ep4_npput (  sbr8pt_ep4_vintf.tnpput  ), 
  .ep4_sbr8pt_npput (  sbr8pt_ep4_vintf.mnpput  ), 
  .sbr8pt_ep4_eom (  sbr8pt_ep4_vintf.teom  ), 
  .ep4_sbr8pt_eom (  sbr8pt_ep4_vintf.meom  ), 
  .sbr8pt_ep4_payload (  sbr8pt_ep4_vintf.tpayload  ), 
  .ep4_sbr8pt_payload (  sbr8pt_ep4_vintf.mpayload  ), 
  .sbr8pt_ep5_side_ism_fabric ( sbr8pt_ep5_vintf.side_ism_fabric ),
  .ep5_sbr8pt_side_ism_agent  ( sbr8pt_ep5_vintf.side_ism_agent  ),
  .ep5_sbr8pt_side_clkreq     ( sbr8pt_ep5_vintf.side_clkreq ),
  .sbr8pt_ep5_side_clkack     ( sbr8pt_ep5_vintf.side_clkack ),
  .sbr8pt_ep5_pccup (  sbr8pt_ep5_vintf.mpccup  ), 
  .ep5_sbr8pt_pccup (  sbr8pt_ep5_vintf.tpccup  ), 
  .sbr8pt_ep5_npcup (  sbr8pt_ep5_vintf.mnpcup  ), 
  .ep5_sbr8pt_npcup (  sbr8pt_ep5_vintf.tnpcup  ), 
  .sbr8pt_ep5_pcput (  sbr8pt_ep5_vintf.tpcput  ), 
  .ep5_sbr8pt_pcput (  sbr8pt_ep5_vintf.mpcput  ), 
  .sbr8pt_ep5_npput (  sbr8pt_ep5_vintf.tnpput  ), 
  .ep5_sbr8pt_npput (  sbr8pt_ep5_vintf.mnpput  ), 
  .sbr8pt_ep5_eom (  sbr8pt_ep5_vintf.teom  ), 
  .ep5_sbr8pt_eom (  sbr8pt_ep5_vintf.meom  ), 
  .sbr8pt_ep5_payload (  sbr8pt_ep5_vintf.tpayload  ), 
  .ep5_sbr8pt_payload (  sbr8pt_ep5_vintf.mpayload  ),
               
  .sbr8pt_ep6_side_ism_fabric ( sbr8pt_ep6_vintf.side_ism_fabric ),
  .ep6_sbr8pt_side_ism_agent  ( sbr8pt_ep6_vintf.side_ism_agent  ),
  .ep6_sbr8pt_side_clkreq     ( sbr8pt_ep6_vintf.side_clkreq ),
  .sbr8pt_ep6_side_clkack     ( sbr8pt_ep6_vintf.side_clkack ),
  .sbr8pt_ep6_pccup (  sbr8pt_ep6_vintf.mpccup  ), 
  .ep6_sbr8pt_pccup (  sbr8pt_ep6_vintf.tpccup  ), 
  .sbr8pt_ep6_npcup (  sbr8pt_ep6_vintf.mnpcup  ), 
  .ep6_sbr8pt_npcup (  sbr8pt_ep6_vintf.tnpcup  ), 
  .sbr8pt_ep6_pcput (  sbr8pt_ep6_vintf.tpcput  ), 
  .ep6_sbr8pt_pcput (  sbr8pt_ep6_vintf.mpcput  ), 
  .sbr8pt_ep6_npput (  sbr8pt_ep6_vintf.tnpput  ), 
  .ep6_sbr8pt_npput (  sbr8pt_ep6_vintf.mnpput  ), 
  .sbr8pt_ep6_eom (  sbr8pt_ep6_vintf.teom  ), 
  .ep6_sbr8pt_eom (  sbr8pt_ep6_vintf.meom  ), 
  .sbr8pt_ep6_payload (  sbr8pt_ep6_vintf.tpayload  ), 
  .ep6_sbr8pt_payload (  sbr8pt_ep6_vintf.mpayload  ),
               
 /* .sbr8pt_ep7_side_ism_fabric ( sbr8pt_ep7_vintf.side_ism_fabric ),
  .ep7_sbr8pt_side_ism_agent  ( sbr8pt_ep7_vintf.side_ism_agent  ),
  .ep7_sbr8pt_side_clkreq     ( sbr8pt_ep7_vintf.side_clkreq ),
  .sbr8pt_ep7_side_clkack     ( sbr8pt_ep7_vintf.side_clkack ),
  .sbr8pt_ep7_pccup (  sbr8pt_ep7_vintf.mpccup  ), 
  .ep7_sbr8pt_pccup (  sbr8pt_ep7_vintf.tpccup  ), 
  .sbr8pt_ep7_npcup (  sbr8pt_ep7_vintf.mnpcup  ), 
  .ep7_sbr8pt_npcup (  sbr8pt_ep7_vintf.tnpcup  ), 
  .sbr8pt_ep7_pcput (  sbr8pt_ep7_vintf.tpcput  ), 
  .ep7_sbr8pt_pcput (  sbr8pt_ep7_vintf.mpcput  ), 
  .sbr8pt_ep7_npput (  sbr8pt_ep7_vintf.tnpput  ), 
  .ep7_sbr8pt_npput (  sbr8pt_ep7_vintf.mnpput  ), 
  .sbr8pt_ep7_eom (  sbr8pt_ep7_vintf.teom  ), 
  .ep7_sbr8pt_eom (  sbr8pt_ep7_vintf.meom  ), 
  .sbr8pt_ep7_payload (  sbr8pt_ep7_vintf.tpayload  ), 
  .ep7_sbr8pt_payload (  sbr8pt_ep7_vintf.mpayload  ));   */
               
   .sbr8pt_ep7_side_ism_fabric ( sbr8pt_ep7_side_ism_fabric_wire ),
  .ep7_sbr8pt_side_ism_agent  ( ep7_sbr8pt_side_ism_agent_wire),
  .ep7_sbr8pt_side_clkreq     ( ep7_sbr8pt_clkreq_wire ),
  .sbr8pt_ep7_side_clkack     ( sbr8pt_ep7_clkack_wire ),
  .sbr8pt_ep7_pccup (  sbr8pt_ep7_pccup_wire  ), 
  .ep7_sbr8pt_pccup (  ep7_sbr8pt_pccup_wire), 
  .sbr8pt_ep7_npcup (  sbr8pt_ep7_npcup_wire ), 
  .ep7_sbr8pt_npcup (  ep7_sbr8pt_npcup_wire  ), 
  .sbr8pt_ep7_pcput (  sbr8pt_ep7_pcput_wire  ), 
  .ep7_sbr8pt_pcput (  ep7_sbr8pt_pcput_wire  ), 
  .sbr8pt_ep7_npput (  sbr8pt_ep7_npput_wire  ), 
  .ep7_sbr8pt_npput (  ep7_sbr8pt_npput_wire  ), 
  .sbr8pt_ep7_eom (  sbr8pt_ep7_eom_wire  ), 
  .ep7_sbr8pt_eom (  ep7_sbr8pt_eom_wire  ), 
  .sbr8pt_ep7_payload (  sbr8pt_ep7_payload_wire  ), 
  .ep7_sbr8pt_payload (  ep7_sbr8pt_payload_wire  ));                 
            
  assign  sbr8pt_ep7_vintf.side_ism_fabric = sbr8pt_ep7_side_ism_fabric_wire;
  assign  sbr8pt_ep7_vintf.side_ism_agent = ep7_sbr8pt_side_ism_agent_wire;
  assign  sbr8pt_ep7_vintf.side_clkreq = ep7_sbr8pt_clkreq_wire;
  assign  sbr8pt_ep7_vintf.side_clkack = sbr8pt_ep7_clkack_wire;
  assign  sbr8pt_ep7_vintf.mpccup  =  sbr8pt_ep7_pccup_wire;
  assign  sbr8pt_ep7_vintf.tpccup  = ep7_sbr8pt_pccup_wire;
  assign  sbr8pt_ep7_vintf.mnpcup  = sbr8pt_ep7_npcup_wire;
  assign  sbr8pt_ep7_vintf.tnpcup = ep7_sbr8pt_npcup_wire;
  assign  sbr8pt_ep7_vintf.tpcput =  sbr8pt_ep7_pcput_wire;
  assign  sbr8pt_ep7_vintf.mpcput= ep7_sbr8pt_pcput_wire;
  assign  sbr8pt_ep7_vintf.tnpput = sbr8pt_ep7_npput_wire;
  assign  sbr8pt_ep7_vintf.mnpput = ep7_sbr8pt_npput_wire;
  assign  sbr8pt_ep7_vintf.teom = sbr8pt_ep7_eom_wire;
  assign  sbr8pt_ep7_vintf.meom  = ep7_sbr8pt_eom_wire;
  assign  sbr8pt_ep7_vintf.tpayload = sbr8pt_ep7_payload_wire;
  assign  sbr8pt_ep7_vintf.mpayload =  ep7_sbr8pt_payload_wire;
  
  assign lnc_ep7_responder.pcput = sbr8pt_ep7_pcput_wire;
  assign lnc_ep7_responder.npput = sbr8pt_ep7_npput_wire;
  assign lnc_ep7_responder.eom = sbr8pt_ep7_eom_wire;
  assign lnc_ep7_responder.payload = sbr8pt_ep7_payload_wire;
  assign lnc_ep7_responder.idle_sm_state = sbr8pt_ep7_side_ism_fabric_wire;
   
  assign ep7_sbr8pt_pccup_wire = lnc_ep7_responder.pccup;
  assign ep7_sbr8pt_npcup_wire = lnc_ep7_responder.npcup;

  assign lnc_ep7_driver.npcup = sbr8pt_ep7_npcup_wire;
  assign lnc_ep7_driver.pccup = sbr8pt_ep7_pccup_wire;
    
  assign ep7_sbr8pt_npput_wire = lnc_ep7_driver.npput; 
  assign ep7_sbr8pt_pcput_wire = lnc_ep7_driver.pcput;  
  assign ep7_sbr8pt_eom_wire = lnc_ep7_driver.eom;
  assign ep7_sbr8pt_payload_wire = lnc_ep7_driver.payload;
  assign ep7_sbr8pt_side_ism_agent_wire = lnc_ep7_driver.idle_sm_state;
   
  assign lnc_ep7_responder.clk = u_clk_rst_intf.clocks[0];
  assign lnc_ep7_driver.clk =  u_clk_rst_intf.clocks[0];
  assign lnc_ep7_responder.reset = u_clk_rst_intf.resets[0];
  assign lnc_ep7_driver.reset =  u_clk_rst_intf.resets[0];  

  // Communication matrix
  // ====================

  // Interface instances
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep0_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep1_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep2_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep3_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep4_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep5_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep6_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );
  iosf_sbc_intf #(.WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) sbr8pt_ep7_vintf    ( .side_clk( u_clk_rst_intf.clocks[0] ), .side_rst_b ( u_clk_rst_intf.resets[0] ) );


   lnc_sbbfm_if  lnc_ep7_driver();
   lnc_sbbfm_if  lnc_ep7_responder();
   lnc_sbbfm_agent_gasket lncsbbfm;
   lnc_sbbfm_agent m_lnc_sbbfm_agent;

  clk_rst_intf u_clk_rst_intf();
  power_intf   u_power_intf();
  comm_intf    u_comm_intf();

  //Interface Bundle
  svlib_pkg::VintfBundle vintfBundle;
  
  event vintf_init_done;
  
  initial
    begin :INTF_WRAPPER_BLOCK
    
    // Dummy reference to trigger factory registration for tests
    iosfsbm_rtr_tests::rtr_base_test dummy;

    //Interface Wrappers for each i/f type used
    iosfsbm_cm::iosfsb_intf_wrapper #(.PAYLOAD_WIDTH(8), .AGENT_MASTERING_SB_IF(1) ) wrapper_agt_8bit; 

    iosfsbm_cm::pwr_intf_wrapper wrapper_pwr_intf;
    iosfsbm_cm::comm_intf_wrapper wrapper_comm_intf;
    iosfsbm_cm::clk_rst_intf_wrapper wrapper_clkrst_intf;
       
        
     //Now fill up bundle with the i/f wrapper, connecting
    //actual interfaces to the virtual ones in the bundle
  wrapper_agt_8bit = new(sbr8pt_ep0_vintf);
  vintfBundle.setData ("sbr8pt_0_xact_intf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr8pt_ep1_vintf);
  vintfBundle.setData ("sbr8pt_1_xact_intf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr8pt_ep2_vintf);
  vintfBundle.setData ("sbr8pt_2_xact_intf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr8pt_ep3_vintf);
  vintfBundle.setData ("sbr8pt_3_xact_intf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr8pt_ep4_vintf);
  vintfBundle.setData ("sbr8pt_4_xact_intf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr8pt_ep5_vintf);
  vintfBundle.setData ("sbr8pt_5_xact_intf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr8pt_ep6_vintf);
  vintfBundle.setData ("sbr8pt_6_xact_intf" , wrapper_agt_8bit);
  wrapper_agt_8bit = new(sbr8pt_ep7_vintf);
  vintfBundle.setData ("sbr8pt_7_xact_intf" , wrapper_agt_8bit);
     
      //Pass config info to the environment
    //pass comm_intf name string
    set_config_string("*", "comm_intf_name", "comm_intf_i");      

    //pass Bundle
    set_config_object("*", VINTF_BUNDLE_NAME, vintfBundle, 0);    

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
   

   initial
     begin: LNC_INIT_BLOCK
       lncsbbfm = new (lnc_ep7_driver, lnc_ep7_responder, "lncsbbfm", 0, " ");
       fork
         lncsbbfm.run(); 
         //execute; //include this task in case you want to send xactions from avm bfm to ovm bfm,
         // also make sure that run task of ovm test is empty
          
         
       join
     end : LNC_INIT_BLOCK
       

   task execute;

  lncsbbfm.sbbfm.sbbfm_stim.start;        
  #500ns;
      
   lncsbbfm.sbbfm.sbbfm_stim.send_meta_request(
    .port    (8'h0c ),
    .sourceid (8'h0d),                                      
    .opcode  (8'h05 ),
    .addresslen (2'b00),                                                
    .address (16'hf001),
    .be      (8'h0f ),
    .data    ( 32'h0000ffff )  
   );
      
    #500ns;
    lncsbbfm.sbbfm.sbbfm_stim.send_meta_request(   
    .port    (8'h0c ),
    .sourceid (8'h0d),                                         
    .opcode  (8'h04 ),
    .addresslen (2'b00),                                                   
    .address (16'h0009),
    .be      (8'h0f )      
   );
    #500ns;
    lncsbbfm.sbbfm.sbbfm_stim.send_meta_request(
    .port    (8'h0c ),
    .sourceid (8'h0d),                                      
    .opcode  (8'h05 ),
    .addresslen (2'b00),                                                
    .address (16'h0404),
    .be      (8'h0f ),
    .data    ( 32'h0000f4aa )  
   );
    #500ns;
    lncsbbfm.sbbfm.sbbfm_stim.send_meta_request(   
    .port    (8'h0c ),
    .sourceid (8'h0d),                                         
    .opcode  (8'h04 ),
     .addresslen (2'b00),                                                  
    .address (16'h0404),
    .be      (8'h0f )      
   );   
      
  /* #500ns;
    lncsbbfm.sbbfm.sbbfm_stim.send_meta_request(
    .port    (8'h0c ),
    .sourceid (8'h0d),                          
    .opcode  (8'h05 ),
    .addresslen (2'b00),
    .address (16'h0909),
    .be      (8'h0f ),
    .data    (32'h00000400 ),
    .tag ( 3'b000),
    .posted_type (1)                                             
    //.rid     (8'h00),    
    //.addresslen (2'b01)                                         
   );*/
  #500ns;       
  lncsbbfm.sbbfm.sbbfm_stim.stop;
  terminate;  
endtask: execute

task terminate;
//   #100000;
//   $finish;
endtask : terminate     
endmodule :tb_8port_lncbfm

