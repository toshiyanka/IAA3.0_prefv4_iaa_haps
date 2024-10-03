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
`ifndef IP_VC_BASE_TEST
`define IP_VC_BASE_TEST 

/**
 * Tests basic test flow for the IOSF sideband interface fabric 
 */
class base_test extends ovm_test;
  // ============================================================================
  // Data members 
  // ============================================================================
  iosfsbm_ip_env::env_ip env_i;
  
  `ifndef IOSF_SB_PH2          
   svlib_pkg::VintfBundle vintfBundle;
   virtual iosf_sbc_intf #(.PAYLOAD_WIDTH(MAXPLDBIT+1), 
                           .AGENT_MASTERING_SB_IF(0),
                           .CLKACK_SYNC_DELAY(4),
                           .DEASSERT_CLK_SIGS_DEFAULT(DEASSERT_CLK_SIGS),
                           .INPUT_FLOP(PIPEINPS),
                           .IOSF_COMPMON_SB_INCLUDE_USAGE_RULES(1)) fabric_vintf;
   virtual iosf_ep_intf #(`IOSFSB_EP_PARAMS) ep_vintf;
  `else
   virtual iosf_sbc_intf fabric_vintf;
   virtual iosf_ep_intf ep_vintf;
  `endif

  // ============================================================================
  //Configuration
  // ============================================================================
  iosfsbm_fbrc::fbrcvc_cfg fabric_cfg_i;
  iosfsbm_ipvc::epvc_cfg agent_cfg_i;
  iosfsbm_cm::checks_control_cfg checks_control_cfg_i;
  ccu_vc_cfg ccu_vc_cfg_i;
  iosfsbm_cm::pid_t strap_dest_ports[$];
  iosfsbm_cm::pid_t local_my_port[$];
  iosfsbm_cm::pid_t local_other_port[$];
  iosfsbm_cm::pid_t local_port[$];
  ovm_event mparity_err;
  ovm_event tparity_err;
  ovm_event ext_parity_err;
  bit global_ep_strap_val = 0;

  // ============================================================================
  // Standard Methods 
  // ============================================================================
  extern function new(string name, ovm_component parent);
  extern function void build();
  extern virtual function void end_of_elaboration();
  extern virtual task run();
  extern function void get_intf();
  extern function void set_parity_cfg();
  extern function void start_of_simulation();
  extern function void assign_port_id();

  `ovm_component_utils(iosftest_pkg::base_test)

  // ============================================================================
  // APIs 
  // ============================================================================
 
  // ============================================================================
  // Helper 
  // ============================================================================

endclass :base_test

/**
 * base_test class constructor
 * @param name  OVM name
 * @param parent  OVM parent reference
 * @return Constructed component of type base_test
 */
function base_test::new(string name, ovm_component parent);
  // Parent caller
  super.new(name, parent);
  mparity_err = new(name);
  tparity_err = new(name);
  ext_parity_err = new(name);

  // Populate plusagrs
  //iosfsbm_cm::plus_args::populate();
  
endfunction :new 

function void base_test::assign_port_id();
    iosfsbm_cm::pid_t local_port_id[$];
    int half_idx = 0;
    int idx[$];

    for(int i=0; i<254; i++)
        local_port_id.push_back(i);
    foreach(local_port[i]) begin
        idx = local_port_id.find_first_index() with (item == local_port[i]);
        if(idx.size != 0)
            local_port_id.delete(idx[0]);
    end
    
    half_idx = local_port_id.size/2;

    for(int i=0; i<half_idx; i++) begin
        local_my_port.push_back(local_port_id[i]);
        local_other_port.push_back(local_port_id[half_idx+i]);
    end    
    
endfunction

/**
 * Standard OVM Component build function.
 */
function void base_test::build();
  // Locals
  string ep_name;
  string comp_name;
  iosfsbm_cm::pid_t agt_my_ports[$], agt_other_ports[$], agt_mcast_ports[$]; 
  iosfsbm_cm::opcode_t agt_supp_opcodes[$];
  iosfsbm_cm::pid_t fab_my_ports[$], fab_other_ports[$], fab_mcast_ports[$]; 
  iosfsbm_cm::opcode_t fab_supp_opcodes[$];
  int div_ratio;
  bit half_div;


  // Super builder
  super.build();
  // Create network
  assert( $cast(fabric_cfg_i, create_object("iosfsbm_fbrc::fbrcvc_cfg", "fabric_cfg_i")) )
    else ovm_report_fatal("CASTING", "Type mismatch");
  
  assert( $cast(agent_cfg_i, create_object("iosfsbm_ipvc::epvc_cfg", "agent_cfg_i")) )
    else ovm_report_fatal("CASTING", "Type mismatch");

  assert( $cast(checks_control_cfg_i, create_object("iosfsbm_cm::checks_control_cfg", "checks_control_cfg_i")) )
    else ovm_report_fatal("CASTING", "Type mismatch");
  
  ccu_vc_cfg_i = ccu_vc_cfg::type_id::create ("ccu_vc_cfg_i");

  set_config_object ("*ccu_vc_i*", "CCU_VC_CFG", ccu_vc_cfg_i, 0);

  ovm_report_info("BASE TEST", "Create Network");

  // Create env
  ovm_report_info("BASE TEST", "Create Test Environment");
  assert( $cast(env_i, create_component("iosfsbm_ip_env::env_ip", "env")) )
    else  ovm_report_fatal("CASTING", "Type mismatch");

  //Configure Agent config descriptor
  //User can randomize payload_width, crd_buffers, 
  //crd_update_delay, compl_Delay etc.  
  
  agt_my_ports = '{'hAA, 'hBB, 'hA1, 'hB1, 'hC1, 'hD1, 'hE1, 'hF1, 'hA2, 'hB2, 'hC2, 'hD2, 'hE2, 'hF2, 'hA3, 'hCC};   
  agt_other_ports = '{'h11, 'h22, 'h44, 'h55, 'h66, 'h77, 'h88, 'h99, 'h12, 'h13, 'h14, 'h15, 'h16, 'h17, 'h18};

  fab_my_ports = '{'h11, 'h22, 'h44, 'h55, 'h66, 'h77, 'h88, 'h99, 'h12, 'h13, 'h14, 'h15, 'h16, 'h17, 'h18, 'h33};
  strap_dest_ports = '{'h69,'h95,'h20,'h30};
  fab_my_ports = {fab_my_ports, strap_dest_ports};
  fab_other_ports = '{'hAA, 'hBB, 'hA1, 'hB1, 'hC1, 'hD1, 'hE1, 'hF1, 'hA2, 'hB2, 'hC2, 'hD2, 'hE2, 'hF2, 'hA3};
  
  local_port = {agt_my_ports, fab_my_ports};
  assign_port_id();

  foreach(local_my_port[i])
    agt_my_ports.push_back(local_my_port[i]);
  
  foreach(local_other_port[i])
    agt_other_ports.push_back(local_other_port[i]);
  
  foreach(local_other_port[i])
    fab_my_ports.push_back(local_other_port[i]);
  
  foreach(local_my_port[i])
    fab_other_ports.push_back(local_my_port[i]);

  agt_mcast_ports = '{};
  //agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES; 
  agt_supp_opcodes = { iosfsbm_cm::DEFAULT_SIMPLE_OPCODES, iosfsbm_cm::DEFAULT_MSGD_OPCODES, 8'd32, 8'd33, 
                       iosfsbm_cm::DEFAULT_REGIO_OPCODES, iosfsbm_cm::SIMPLE_EPSPEC_OPCODE_START };
  //for(int i = `iosfsbm_cm::REGIO_GLOBAL_OPCODE_START; i <= `iosfsbm_cm::SIMPLE_EPSPEC_OPCODE_END; ++i)
  //   agt_supp_opcodes.push_back(i);
  //agent_cfg_i.rata_comp_blocking_en = $urandom_range(1,0);
  agent_cfg_i.tparity_err = tparity_err;
  agent_cfg_i.ext_parity_err = ext_parity_err;
  agent_cfg_i.mparity_err = mparity_err;
  global_ep_strap_val = $urandom_range(1,0);
  agent_cfg_i.global_intf_en = (GLOBAL_EP && !GLOBAL_EP_IS_STRAP) || (GLOBAL_EP_IS_STRAP && global_ep_strap_val) ;
  assert (agent_cfg_i.randomize with {
                                      num_tx_ext_headers == NUM_TX_EXT_HEADERS;                                      
                                      my_ports.size() == agt_my_ports.size();
                                      other_ports.size() == agt_other_ports.size();
                                      mcast_ports.size() == agt_mcast_ports.size();
                                      foreach (agt_my_ports[i])
                                        my_ports[i] == agt_my_ports[i];
                                      foreach (agt_other_ports[i])
                                        other_ports[i] == agt_other_ports[i];
                                      foreach (agt_mcast_ports[i])
                                        mcast_ports[i] == agt_mcast_ports[i];
                                      supported_opcodes.size == agt_supp_opcodes.size;
                                      foreach (agt_supp_opcodes[i])
                                        supported_opcodes[i] == agt_supp_opcodes[i];
                                      }) else
    ovm_report_error("RND", "Randomization failed", iosfsbm_cm::VERBOSE_ERROR);
      
  //Configure Fabric config descriptor
  //User can randomize payload_width, crd_buffers, 
  //crd_update_delay, compl_Delay etc. 

  fab_mcast_ports = '{};
  //fab_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES;             
  fab_supp_opcodes = { iosfsbm_cm::DEFAULT_SIMPLE_OPCODES, iosfsbm_cm::DEFAULT_MSGD_OPCODES, 8'd32, 8'd33, 
                       iosfsbm_cm::DEFAULT_REGIO_OPCODES, iosfsbm_cm::SIMPLE_EPSPEC_OPCODE_START };
  //for(int i = `iosfsbm_cm::REGIO_GLOBAL_OPCODE_START; i <= `iosfsbm_cm::SIMPLE_EPSPEC_OPCODE_END; ++i)
  //   fab_supp_opcodes.push_back(i);
  fabric_cfg_i.tparity_err = tparity_err;
  fabric_cfg_i.mparity_err = mparity_err;
  fabric_cfg_i.global_intf_en = (GLOBAL_EP && !GLOBAL_EP_IS_STRAP) || (GLOBAL_EP_IS_STRAP && global_ep_strap_val);
  //fabric_cfg_i.compmon_incl_usage = 1;
  //fabric_cfg_i.clkack_sync_delay = 4;
  fabric_cfg_i.default_deassert_clk_sigs = DEASSERT_CLK_SIGS;
  fabric_cfg_i.input_flop = PIPEINPS;
  assert (fabric_cfg_i.randomize with {
                                       num_tx_ext_headers == NUM_RX_EXT_HEADERS;
                                       payload_width == MAXPLDBIT+1;
                                       my_ports.size() == fab_my_ports.size();
                                       other_ports.size() == fab_other_ports.size();
                                       mcast_ports.size() == fab_mcast_ports.size();
                                       foreach (fab_my_ports[i])
                                         my_ports[i] == fab_my_ports[i];
                                       foreach (agt_other_ports[i])
                                         other_ports[i] == fab_other_ports[i];
                                       foreach (fab_mcast_ports[i])
                                         mcast_ports[i] == fab_mcast_ports[i];
                                      supported_opcodes.size == fab_supp_opcodes.size;
                                       foreach (fab_supp_opcodes[i])
                                         supported_opcodes[i] == fab_supp_opcodes[i];
                                       }) else
                                                 
     	   ovm_report_error("RND", "Randomization failed", 
                            iosfsbm_cm::VERBOSE_ERROR);      

  //set IOSF Spec Version 
//  if (IOSFSB_EP_SPEC_REV == 090)
//    agent_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_090);
//  else if (IOSFSB_EP_SPEC_REV == 1)
//    agent_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_1);
//  else
//    agent_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_083);
//
//  if (IOSFSB_FBRC_SPEC_REV == 090)
//    fabric_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_090);
//  else if (IOSFSB_FBRC_SPEC_REV == 1)
//    fabric_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_1);
//  else
//    fabric_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_083);

  fabric_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_11);
  agent_cfg_i.set_iosfspec_ver(iosfsbm_cm::IOSF_11);

  if(UNIQUE_EXT_HEADERS == 1) begin
  if(AGT_EXT_HEADER_SUPPORT == 1) begin
  agent_cfg_i.rs_support = 1;
  end
  end

    

  //Set ext_header_support bit
  if (agent_cfg_i.iosfsb_spec_rev >= IOSF_090)    
    begin
       agent_cfg_i.ext_header_support = AGT_EXT_HEADER_SUPPORT;
       //Added only for config related covergroups
       agent_cfg_i.tx_ext_header_support = TX_EXT_HEADER_SUPPORT;
       agent_cfg_i.rx_ext_header_support = RX_EXT_HEADER_SUPPORT;
       agent_cfg_i.num_rx_ext_headers = NUM_RX_EXT_HEADERS; 
    end
      
  if (fabric_cfg_i.iosfsb_spec_rev >= IOSF_090)    
    begin
       fabric_cfg_i.ctrl_ext_header_support = FBRC_EXT_HEADER_SUPPORT;
       fabric_cfg_i.ext_header_support = TX_EXT_HEADER_SUPPORT;
       fabric_cfg_i.agt_ext_header_support = TX_EXT_HEADER_SUPPORT;
       //fabric_cfg_i.rs_support = TX_EXT_HEADER_SUPPORT;
	   fabric_cfg_i.rs_support = FBRC_EXT_HEADER_SUPPORT;
       //if(TX_EXT_HEADER_SUPPORT == 1) begin
	   if(FBRC_EXT_HEADER_SUPPORT == 1) begin
         fabric_cfg_i.sai_width = SAIWIDTH;
         fabric_cfg_i.rs_width = RSWIDTH;
       end
      else begin
         fabric_cfg_i.sai_width = 0;
         fabric_cfg_i.rs_width = 0;
      end
    end
  fabric_cfg_i.set_parity_en(SB_PARITY_REQUIRED);
  fabric_cfg_i.fab_parity_chk = 1;
  fabric_cfg_i.agt_parity_chk = 1;
  fabric_cfg_i.fab_parity_defeature = 0;
  fabric_cfg_i.agt_parity_defeature = 0;
  fabric_cfg_i.iosf_endpoint = 1;

  if(DISABLE_COMPLETION_FENCING) begin
    fabric_cfg_i.disable_compmon_assertion("SBMI_085_REQUESTCOMPLETIONTAGMATCH");
    fabric_cfg_i.disable_compmon_assertion("SBMI_123");
    fabric_cfg_i.disable_compmon_assertion("SBMI_029_032_052");
    fabric_cfg_i.disable_compmon_assertion("SBMI_035_REGISTERWRITECOMPLETEWITH1DW");
    fabric_cfg_i.disable_completion_fence = 1;
  end
  //fabric_cfg_i.disable_compmon_assertion("SBMI_BULKREGISTERREADCOMPLETELENNOTMATCH");
  if(BULKRDWR) begin
    fabric_cfg_i.disable_compmon_assertion("SBMI_BULKREGISTERREADCOMPLETELENNOTMATCH_AGT");
    fabric_cfg_i.disable_compmon_assertion("SBMI_040_AllNONPOSTEDSMUSTEVENTUALLYBECOMPLETED");
    fabric_cfg_i.disable_compmon_assertion("SBMI_157_COMPLETIONHASREQUEST_AGT");
    fabric_cfg_i.disable_compmon_assertion("SBMI_157_COMPLETIONHASREQUEST_FAB");
    fabric_cfg_i.disable_compmon_assertion("SBMI_085_REQUESTCOMPLETIONTAGMATCH");
  end 
  // **Warning waive it for now**
  /*
  if(CLKREQDEFAULT) begin
    fabric_cfg_i.disable_compmon_assertion("ISMPM_SBMI_062_PRI_157_STATEINITIALIZATION_CLKREQ");
    fabric_cfg_i.disable_compmon_assertion("ISMPM_SBMI_062_PRI_157_STATEINITIALIZATION_CLKACK");
    fabric_cfg_i.disable_compmon_assertion("SBMI_062_CLKACKVALIDFROMRESET");
    fabric_cfg_i.disable_compmon_assertion("SBMI_062_CLKREQVALIDFROMRESET");
  end
  */
  if (IS_RATA_ENV) begin
     fabric_cfg_i.set_vc_type(iosfsbm_cm::RATA);
     fabric_cfg_i.bulk_mode = BULKRDWR;
   `ifndef IOSF_SB_PH2          
     fabric_cfg_i.num_pcmstr = MAXPCMSTR;
     fabric_cfg_i.num_npmstr = MAXNPMSTR;
     fabric_cfg_i.num_pctrgt = MAXPCTRGT;
     fabric_cfg_i.num_nptrgt = MAXNPTRGT;
     fabric_cfg_i.maxtrgtaddr          = MAXTRGTADDR;
     fabric_cfg_i.maxtrgtdata          = MAXTRGTDATA;
     fabric_cfg_i.maxmstraddr          = MAXMSTRADDR;
     fabric_cfg_i.maxmstrdata          = MAXMSTRDATA;
     fabric_cfg_i.num_rx_ext_headers   = NUM_RX_EXT_HEADERS;
     fabric_cfg_i.num_tx_ext_headers   = NUM_TX_EXT_HEADERS;
     fabric_cfg_i.sai_width             = SAIWIDTH;
     fabric_cfg_i.rs_width              = RSWIDTH;
     fabric_cfg_i.maxpldbit                        = MAXPLDBIT;
     fabric_cfg_i.matched_internal_width           = MATCHED_INTERNAL_WIDTH;
   `endif
     fabric_cfg_i.intf_name = "sb_msg_intf";
  end
  //reg access present
  agent_cfg_i.mreg_present=MASTERREG;
  agent_cfg_i.treg_present=TARGETREG;
  agent_cfg_i.bulk_mode = BULKRDWR;

  //Added for covergroups
  agent_cfg_i.num_pcmstr = MAXPCMSTR;
  agent_cfg_i.num_npmstr = MAXNPMSTR;
  agent_cfg_i.num_pctrgt = MAXPCTRGT;
  agent_cfg_i.num_nptrgt = MAXNPTRGT;
  agent_cfg_i.maxtrgtaddr = MAXTRGTADDR;
  agent_cfg_i.maxtrgtdata = MAXTRGTDATA;
  agent_cfg_i.maxmstraddr = MAXMSTRADDR;
  agent_cfg_i.maxmstrdata = MAXMSTRDATA; 
  agent_cfg_i.NPQUEUEDEPTH =NPQUEUEDEPTH;
  agent_cfg_i.PCQUEUEDEPTH= PCQUEUEDEPTH;
  agent_cfg_i.ASYNCEQDEPTH= ASYNCEQDEPTH;
  agent_cfg_i.ASYNCIQDEPTH= ASYNCIQDEPTH;
  agent_cfg_i.ASYNCENDPT= ASYNCENDPT;
  agent_cfg_i.DUT_TX_EXT_HEADER_SUPPORT= TX_EXT_HEADER_SUPPORT;
  agent_cfg_i.DUT_RX_EXT_HEADER_SUPPORT= RX_EXT_HEADER_SUPPORT;
  agent_cfg_i.DUT_NUM_RX_EXT_HEADERS= NUM_RX_EXT_HEADERS;
  agent_cfg_i.DUT_NUM_TX_EXT_HEADERS= NUM_TX_EXT_HEADERS;
  agent_cfg_i.MAXPLDBIT=MAXPLDBIT;
  agent_cfg_i.DISABLE_COMPLETION_FENCING = DISABLE_COMPLETION_FENCING;
  agent_cfg_i.LATCHQUEUES = LATCHQUEUES;
  agent_cfg_i.SKIP_ACTIVEREQ = SKIP_ACTIVEREQ;
  agent_cfg_i.FAB_CLK_PERIOD = FAB_CLK_PERIOD;
  agent_cfg_i.AGT_CLK_PERIOD = AGT_CLK_PERIOD;
  agent_cfg_i.PIPEISMS = PIPEISMS;
  agent_cfg_i.PIPEINPS = PIPEINPS;
  agent_cfg_i.usync_en = USYNC_ENABLE;
  agent_cfg_i.side_usync_delay = SIDE_USYNC_DELAY;
  agent_cfg_i.agent_usync_delay = AGENT_USYNC_DELAY;
  agent_cfg_i.intf_name = "ep_intf" ;
  agent_cfg_i.ism_lock_support = 1;
   
  //PCN 006
  agent_cfg_i.SAIWIDTH = SAIWIDTH;
  agent_cfg_i.RSWIDTH = RSWIDTH;
  agent_cfg_i.maxpldbit = MAXPLDBIT;
  agent_cfg_i.matched_internal_width = MATCHED_INTERNAL_WIDTH;
  agent_cfg_i.UNIQUE_EH_SAIRS_INPUTS = UNIQUE_EXT_HEADERS;
  agent_cfg_i.default_deassert_clk_sigs = DEASSERT_CLK_SIGS;

  if(VARIABLE_CLAIM_DELAY) begin
    agent_cfg_i.disable_order_check = 1;
    agent_cfg_i.disable_idle = 1;
	//agent_cfg_i.en_clk_gate = 0;
  end
  set_parity_cfg(); 
  //Set ep_cfg
  agent_cfg_i.set_ep_cfg(); 
  if (IS_RATA_ENV) begin
    agent_cfg_i.set_vc_type(iosfsbm_cm::RATA);
    agent_cfg_i.disable_order_check = 1;
  end
  
//  `ifdef IOSF_SB_PH2
  agent_cfg_i.inst_name = "tb_top.ep_ti";
  if (IS_RATA_ENV)
    fabric_cfg_i.inst_name = "";//tb_top.ep_ti.sb_msg_ti"; 
  else
    fabric_cfg_i.inst_name = "tb_top.gen_ep.fabric_ti"; 
    
//  `endif
  //Pass fabric_cfg and agent_cfg 
  set_config_object("*", "fabric_cfg", fabric_cfg_i, 0);
  set_config_object("*", "epvc_cfg", agent_cfg_i, 0);

  //turn off bcast/mcast related covergroups
  checks_control_cfg_i.disable_covergroups ('{"vr_sbc_0303", 
                                              "vr_sbc_0305", 
                                              "vr_sbc_0309_a", 
                                              "vr_sbc_0151", 
                                              "vr_sbc_0152", 
                                              "vr_sbc_0158", 
                                              "vr_sbc_0137"});
      
  if(checks_control_cfg_i != null)
    set_config_object("*", "checks_control_cfg", checks_control_cfg_i, 0);
  
  div_ratio = 2**$urandom_range(4,1);
  half_div = $urandom_range(1,0);

  ccu_vc_cfg_i.add_clk_source(0, "SB_CLK", agent_cfg_i.FAB_CLK_PERIOD);
  ccu_vc_cfg_i.set_global_usync_counter(20);
  ccu_vc_cfg_i.set_ref_clk_src(0);
  ccu_vc_cfg_i.add_slice(0, "FABRIC_CLK", 0, ccu_types::CLK_UNGATED, ccu_types::DIV_1,0,1,1,1,1,1,.usync_enabled(USYNC_ENABLE));

  if(ASYNCENDPT == 1) begin
    if(USYNC_ENABLE == 1) begin
        ccu_vc_cfg_i.add_slice(1, "AGT_CLK", 0, ccu_types::CLK_UNGATED, ccu_types::DIV_2,0,1,1,1,1,1,.usync_enabled(USYNC_ENABLE));
    end
    else begin
        ccu_vc_cfg_i.add_clk_source(1, "SB_CLK1", agent_cfg_i.AGT_CLK_PERIOD);
        ccu_vc_cfg_i.add_slice(1, "AGT_CLK", 1, ccu_types::CLK_UNGATED, ccu_types::DIV_1,0,1,1,1,1,1,.usync_enabled(USYNC_ENABLE));
    end
  end
  else begin
    ccu_vc_cfg_i.add_slice(1, "AGT_CLK", 0, ccu_types::CLK_UNGATED, ccu_types::DIV_1,0,1,1,1,1,1,.usync_enabled(USYNC_ENABLE));
  end

  get_intf();

endfunction :build

/**
 * Standard OVM Component end_of_elaboration function.
 */
function void base_test::end_of_elaboration();
  string ep_name;
  ovm_report_info("BASE TEST", "Starting test ...");

  //Print TEST parameters
  ovm_report_info ( "BASE TEST", 
                    $psprintf("\n\n NPQUEUEDEPTH=%0d;\n PCQUEUEDEPTH=%0d;\n MAXNPMSTR=%0d;\n MAXPCMSTR=%0d;\n MAXNPTRGT=%0d;\n MAXPCTRGT=%0d;\n TARGETREG=%0d;\n MASTERREG=%0d;\n ASYNCEQDEPTH=%0d;\n ASYNCIQDEPTH=%0d;\n ASYNCENDPT=%0d;\n MAXTRGTADDR=%0d;\n MAXMSTRADDR=%0d;\n MAXMSTRDATA=%0d;\n MAXTRGTDATA=%0d;\n MAXPLDBIT=%0d;\n TX_EXT_HEADER_SUPPORT=%0d;\n RX_EXT_HEADER_SUPPORT=%0d;\n AGT_EXT_HEADER_SUPPORT=%0d;\n FBRC_EXT_HEADER_SUPPORT=%0d;\n NUM_RX_EXT_HEADERS=%0d;\n NUM_TX_EXT_HEADERS=%0d;\n RX_EXT_HEADER_IDS=%0p;\n DISABLE_COMPLETION_FENCING=%0d;\n LATCHQUEUES=%0d;\n SKIP_ACTIVEREQ=%0d;\n PIPEISMS=%0d;\n PIPEINPS=%0d;\n AGT_CLK_PERIOD=%0dps;\n FAB_CLK_PERIOD=%0dps;\n USYNC_ENABLE=%0d;\n SIDE_USYNC_DELAY=%0d;\n AGENT_USYNC_DELAY=%0d;\n SAIWIDTH=%d;\n RSWIDTH=%d;\n UNIQUE_EXT_HEADERS=%d;\n ", 
                              NPQUEUEDEPTH,
                              PCQUEUEDEPTH, 
                              MAXNPMSTR, 
                              MAXPCMSTR, 
                              MAXNPTRGT,
                              MAXPCTRGT,
                              TARGETREG, 
                              MASTERREG, 
                              ASYNCEQDEPTH, 
                              ASYNCIQDEPTH,
                              ASYNCENDPT ,
                              MAXTRGTADDR, 
                              MAXMSTRADDR, 
                              MAXMSTRDATA, 
                              MAXTRGTDATA, 
                              MAXPLDBIT,  
                              TX_EXT_HEADER_SUPPORT,
                              RX_EXT_HEADER_SUPPORT,
                              AGT_EXT_HEADER_SUPPORT,
                              FBRC_EXT_HEADER_SUPPORT,
                              NUM_RX_EXT_HEADERS,
                              NUM_TX_EXT_HEADERS,
                              RX_EXT_HEADER_IDS,
                              DISABLE_COMPLETION_FENCING,
                              LATCHQUEUES,
                              SKIP_ACTIVEREQ,
                              PIPEISMS,
                              PIPEINPS,
                              AGT_CLK_PERIOD,
                              FAB_CLK_PERIOD,
                              USYNC_ENABLE,
                              SIDE_USYNC_DELAY,
                              AGENT_USYNC_DELAY,
                              SAIWIDTH,
                              RSWIDTH,
                              UNIQUE_EXT_HEADERS), 0);

      if(DISABLE_COMPLETION_FENCING)
        begin
           ovm_report_info("BASE TEST", "VC is set to claim all np messages", 0);     
           env_i.iosf_sbc_ip_vc_i.vc_set_to_claim_all_msg(1);
        end
endfunction :end_of_elaboration

/**
 * Standard OVM run task.
 */
task base_test::run();
    ovm_report_warning("BASE TEST", "Test run is not defined !!", iosfsbm_cm::VERBOSE_WARNING);
      
 
endtask :run

function void base_test::start_of_simulation();
    ep_vintf.parity_defeature = agent_cfg_i.parity_defeature;
    ep_vintf.tag_strap = agent_cfg_i.strap_tag;
    ep_vintf.srcid_strap = agent_cfg_i.strap_srcid;
    ep_vintf.dstid_strap = agent_cfg_i.strap_destid;
    ep_vintf.hier_srcid_strap = agent_cfg_i.strap_hier_srcid;
    ep_vintf.hier_dstid_strap = agent_cfg_i.strap_hier_destid;
    ep_vintf.sairs_valid_strap = agent_cfg_i.strap_sai_valid;
    ep_vintf.sai_strap = agent_cfg_i.strap_sai;
    ep_vintf.rs_strap = agent_cfg_i.strap_rs;
    ep_vintf.global_ep_strap = global_ep_strap_val;
endfunction

function void base_test::set_parity_cfg();
    strap_dest_ports.shuffle();
    agent_cfg_i.set_parity_en(SB_PARITY_REQUIRED);
    agent_cfg_i.do_serr = DO_SERR_MASTER;
    agent_cfg_i.strap_destid = strap_dest_ports[0];
    agent_cfg_i.strap_srcid = agent_cfg_i.my_ports[0];
    agent_cfg_i.strap_hier_destid = strap_dest_ports[1];
    agent_cfg_i.strap_hier_srcid = strap_dest_ports[2];
    agent_cfg_i.strap_tag = $urandom_range(7,0);
    agent_cfg_i.set_agt_parity_defeature(0);
    agent_cfg_i.strap_rs = $urandom_range(0,(2**RSWIDTH - 1));
    agent_cfg_i.strap_sai = $urandom_range(0,(2**SAIWIDTH - 1));
    agent_cfg_i.strap_sai_valid = 1;//$urandom_range(0,1);
endfunction

function void base_test::get_intf();
    string ip_intf_name,fab_intf_name;

    `ifndef IOSF_SB_PH2
    ovm_object vintfBundle_obj; 
    ipvc_vintf_wrp #(`IOSFSB_EP_PARAMS)wrapper;
    iosfsbm_cm::iosfsb_intf_wrapper#(.PAYLOAD_WIDTH(MAXPLDBIT+1), 
                                     .AGENT_MASTERING_SB_IF(0),
                                     .CLKACK_SYNC_DELAY(4),
                                     .DEASSERT_CLK_SIGS_DEFAULT(DEASSERT_CLK_SIGS),
                                     .INPUT_FLOP(PIPEINPS),
                                     .IOSF_COMPMON_SB_INCLUDE_USAGE_RULES(1)) sbc_wrapper;

    if(!get_config_object("sb_vintfbundle", vintfBundle_obj, 0)) 
        ovm_report_fatal("CFG", "Interface bundle not passed");
    if(! $cast(vintfBundle, vintfBundle_obj)) 
        ovm_report_fatal("CASTING", "Type mismatch");
 
    // Get virtual interface from bundle
    assert( $cast (wrapper, vintfBundle.getData("ep_intf") ) ) else
        ovm_report_fatal("CFG", "Interface wrapper is of incorrect type");
    ep_vintf = wrapper.intf;

    if (!IS_RATA_ENV) begin
    // Get virtual interface from bundle
    assert( $cast (sbc_wrapper, vintfBundle.getData("fabric_intf") ) ) else
      ovm_report_fatal("CFG", "Interface wrapper is of incorrect type");
   
    fabric_vintf= sbc_wrapper.intf;                                 
    end
    `else

    $sformat(ip_intf_name, "%s.iosfsb_ep_intf",agent_cfg_i.inst_name);
    ep_vintf = sip_vintf_pkg::sip_vintf_proxy #(virtual iosf_ep_intf)::get(ip_intf_name, `__FILE__, `__LINE__);

    if (!IS_RATA_ENV) begin
    $sformat(fab_intf_name, "%s.iosfsb_intf", fabric_cfg_i.inst_name);
    fabric_vintf = sip_vintf_pkg::sip_vintf_proxy #(virtual iosf_sbc_intf)::get(fab_intf_name, `__FILE__, `__LINE__);
    end
    `endif

endfunction

`endif //IP_VC_BASE_TEST

