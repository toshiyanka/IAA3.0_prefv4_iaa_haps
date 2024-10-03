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
`ifndef INC_IOSF_SBC_ENV
`define INC_IOSF_SBC_ENV 

/**
 * The environment class is the top level component for the IOSF SBC verification
 * framework, it includes network generation as well as top level connections
 * 
 * This is example env created with one router with 8 agents
 * all agents are configured using do_create_network API
 * env instantiates iosf_sbc_agent_vc for each node (in this case total 8),
 * and also instantiates rtr_sb 
 * users need to configire agtvc_cfg for each agent based on its sideband network
 * users also need to configure rtr_cfg and common_cfg which is required for rtr_sb
 * gnerally we use XML file which specifes sideband network, but user can refer to 
 * their MAS/HAS for correct sideband network configuration
 * 
 * For this example i have used lv0_sbr_cfg_1.xml file which specified how
 * each agent is conencted to the router and each agent's config fields
 * for example, payload_width, and buffer sizes.
 * 
 * I would suggest you to first study this example env, xml and testbench 
 * and see how the different config members are configured based on the XML.
 * User will then have better idea about how to configure agtvc_cfg, rtr_cfg and common_cfg
 * 
 * If you have any question please email me at dhwani.daftary@intel.com
 * or call me at (480) 552-6393.
 */
class env extends ovm_env;
  // ============================================================================
  // Data members 
  // ============================================================================
  
  // Structural components
  // =====================
 
  //agtvc component
  iosfsbm_agent::iosfsbm_agtvc    iosf_sbc_agent_vc_i[iosfsbm_cm::nid_t];

  // Checking logic rtr_sb
  iosfsbm_rtr::rtr_sb    rtr_sb_i;

  // Config descriptors
  // ==================
  //for rtr_sb
  iosfsbm_rtr::rtr_cfg  rtr_cfg_i;
  iosfsbm_cm::common_cfg  common_cfg_i;

  //for agtvc
  iosfsbm_agent::agtvc_cfg agtvc_cfg_i[iosfsbm_cm::nid_t];

  //Ignore this part, since you are not using
  //out clk_rst and pmu VCs
  //pmu vc component
  iosf_pmu::iosf_pmu_vc iosf_pmu_vc_i;
  //clock reset VCS
  clk_rst::clk_rst_vc clk_rst_vc_i;

  //clk_rst VC cfg
  clk_rst::clk_rst_cfg clk_rst_cfg_i;

  //pmu_base_cfg and pmu_cfgs
  iosf_pmu::iosf_pmu_base_cfg iosf_pmu_base_cfg_i;
  iosf_pmu::iosf_pmu_cfg iosf_pmu_cfg_i;

  // ============================================================================
  // Standard functions 
  // ============================================================================
      extern function new(string name, ovm_named_component parent);
      extern function void build();
      extern function void connect();
      extern function void do_create_network();
      extern function void create_agtvc_cfg (iosfsbm_cm::nid_t nid,
                                         iosfsbm_cm::pid_t agt_my_ports[$],
                                         iosfsbm_cm::pid_t agt_other_ports[$],
                                         iosfsbm_cm::pid_t agt_mcast_ports[$],
                                         iosfsbm_cm::opcode_t agt_supp_opcodes[$],
                                         string intf_name, int pload_width,
                                         int np_crd_buffer,
                                         int pc_crd_buffer);  
      extern function void create_rtr_cfg();
      extern function void create_common_cfg();
      extern function void create_pmu_cfgs();
      extern function void create_clk_rst_cfg();
    
  extern task run();
  extern function void end_of_elaboration();
  
  // ============================================================================
  // APIs 
  // ============================================================================

  // ============================================================================
  // OVM Macros 
  // ============================================================================
  `ovm_component_utils(iosfsbm_rtr_env::env)
endclass :env

/**
 * Environment class constructor.
 * @param name input string - OVM name
 * @param parent input ovm_named_component - OVM parent reference
 * @return Constructed component of type env
 */
function env::new(string name, ovm_named_component parent);
  // Super constructor
  super.new(name, parent);

  // Populate parameters depending on plusargs 
  iosfsbm_cm::plus_args::populate();

endfunction :new

/**
 * Environment class constructor.
 * @param name input string - OVM name
 * @param parent input ovm_named_component - OVM parent reference
 * @return Constructed component of type env
 */

/**
 * Standard OVM Component build function.
 */
function void env::build();
  // Locals
  // ======
  ovm_object network_cfg_obj; 

  iosfsbm_cm::comm_intf_wrapper wrapper;
  ovm_object tmpObj;
  string comm_intf_name, pmu_name;
  string iosf_sbr_pmu_intf;
  string comp_name, rtr_name, other_name, cfg_name, temp_name;
  ovm_object checks_control_cfg_obj;
  iosfsbm_cm::nid_t rtr_nid, other_nid;
  string msg;
  iosfsbm_rtr::link tmp_link;
  iosfsbm_cm::nid_t nids[$];
  iosfsbm_rtr::rtr_cfg rtr_cfg_tmp;
  string pmu_driver_intf_name;
  iosfsbm_cm::abstraction_level_e other_abs;
  string dest_name;    
  string m_clk_intf_name, m_power_intf_name, m_iosf_sbr_pmu_intf;
  iosfsbm_cm::abstraction_level_e dest_abs_level;
  string pmu_sbr2_intf;
  string visited_rtrs[16];
  int rtr_idx;
        
  // Super builder
  // =============
  super.build();

  // Configuration
  // =============
  ovm_report_info("NETWORK BUILDER", "Create config members");
  
  do_create_network();      
      
  // Construction
  // ============
  ovm_report_info("NETWORK BUILDER", "Construction of components");

      //Build Agent VCs
      for (int nid=0; nid<8; nid++)
      begin
         $sformat(comp_name,"Agent_VC%0d", nid);
         $sformat(msg, "Creating Agent VC %s", comp_name);
         ovm_report_info("NETWORK BUILDER", msg, iosfsbm_cm::VERBOSE_PROGRESS);
         // Create component
         assert( $cast(iosf_sbc_agent_vc_i[nid], 
                       create_component("iosfsbm_agent::iosfsbm_agtvc", comp_name)) )
           else ovm_report_fatal("CASTING", "Type mismatch");  
       set_config_object(comp_name, "agent_cfg", agtvc_cfg_i[nid], 0);

      end // UNMATCHED !!      

      // Echo construction operation
      $sformat(msg, "Creating RTR Scoreboard %s", comp_name);
      ovm_report_info("NETWORK BUILDER", msg, iosfsbm_cm::VERBOSE_PROGRESS);

      // Create component
      assert( $cast(rtr_sb_i, create_component("iosfsbm_rtr::rtr_sb","rtr_sb")) )
        else ovm_report_fatal("CASTING", "Type mismatch");
    set_config_object("rtr_sb", "rtr_cfg", rtr_cfg_i, 0);
    set_config_object("rtr_sb", "common_cfg",common_cfg_i, 0);

  //Ignore this part since clk_Rst and PMU VC is not being used
  //build clk_rst VC     
  $sformat(msg, "Creating CLK_RST VC");
  ovm_report_info("NETWORK BUILDER", msg, iosfsbm_cm::VERBOSE_PROGRESS);
  assert( $cast(clk_rst_vc_i, 
                create_component("clk_rst_vc", "clk_rst_vc")) )
    else ovm_report_fatal("CASTING", "Type mismatch");

      
  //build sbr_pmu VC, pass pmu_cfg     
  $sformat(msg, "Creating PMU VC");
  ovm_report_info("NETWORK BUILDER", msg, iosfsbm_cm::VERBOSE_PROGRESS);
  assert( $cast(iosf_pmu_vc_i, 
                create_component("iosf_pmu_vc", "iosf_pmu_vc")) )
else ovm_report_fatal("CASTING", "Type mismatch");
      
endfunction :build

/**
 * Standard OVM Component connect function.
 */
function void env::connect();
  // locals  
  string msg;
  
  ovm_analysis_port #(iosfsbm_cm::xaction) vc_2_rtr_ap;
  ovm_analysis_port #(iosfsbm_cm::xaction) rtr_2_vc_ap; 
  ovm_analysis_port #(iosfsbm_cm::ism_cmd_e)  vc_2_sb_ism_ap;
      
        
  // Print stage
  ovm_report_info("NETWORK BUILDER", "Connection of components");

  // Start Connecting the scoreboard
      for (int nid=0;nid<8;nid++)
        begin
           vc_2_rtr_ap = iosf_sbc_agent_vc_i[nid].tx_ap;
           rtr_2_vc_ap = iosf_sbc_agent_vc_i[nid].rx_ap;                 
            
           vc_2_sb_ism_ap  = iosf_sbc_agent_vc_i[nid].ism_cmd_ap;
               
                 
           // Connect RTR scoreboards (corresponding to RTL RTRs)
           // ===================================================
           
           rtr_2_vc_ap.connect(rtr_sb_i.analysis_export_egress[nid]);
              
           vc_2_rtr_ap.connect(rtr_sb_i.analysis_export_ingress[nid]);

           vc_2_sb_ism_ap.connect(rtr_sb_i.input_ism_analysis_export[nid]);
        end
 
endfunction :connect

/**
 * Standard OVM run task.
 */
task env::run();
  // locals
  string msg;

  // Print initial counter status
  iosfsbm_cm::xaction_counters::print();

  // Print every counter status periodically
  iosfsbm_cm::xaction_counters::print_periodic();  
endtask :run

/**
 * Standard OVM end_of_elaboration function.
 */
function void env::end_of_elaboration();
  // Mark the end of the network building phase
  ovm_report_info("NETWORK BUILDER", "Network building is done ...");

 
endfunction :end_of_elaboration

function void env::do_create_network();
      
  iosfsbm_cm::pid_t agt_my_ports[$], agt_other_ports[$], agt_mcast_ports[$], pids[$]; 
  iosfsbm_cm::opcode_t agt_supp_opcodes[$]; 
  string msg,intf_name;
  iosfsbm_cm::nid_t nids[$];
  int pload_width, pc_crd_buffer, np_crd_buffer;
    

      ovm_report_info("NETWORK BUILDER", "Construction of Config Objects");

      //ignore this since you are not reusing clk_rst and pmu vc
      //Create clk_Rst and pmu CFGS
      create_clk_rst_cfg();
      create_pmu_cfgs();
      
  //Configure Agent config descriptor for Agtvc0
  agt_my_ports = '{'d0, 'd01, 'd02, 'd03};        
  agt_other_ports = '{'d4, 'd05, 'd06, 'd07, 'd08, 'd9, 'd10, 'd11, 'd12, 'd13};
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES;
  intf_name = "sbr_ep0_vintf";     
  pload_width = 8;
  pc_crd_buffer = 1;
  np_crd_buffer = 1;      
  create_agtvc_cfg (0, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);
      
 
      
  //Configure Agent config descriptor Agtvc1
  agt_my_ports = '{'d04, 'd05, 'd6, 'd7};        
  agt_other_ports = '{'d00, 'd01, 'd02, 'd03, 'd8, 'd9, 'd10, 'd11, 'd12, 'd13};       
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES;
  intf_name = "sbr_ep1_vintf";
  pload_width = 8;
  pc_crd_buffer = 2;
  np_crd_buffer = 2;      
  create_agtvc_cfg (1, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);
    
      
  //Configure Agent config descriptor Agtvc2
  agt_my_ports = '{'d08};        
  agt_other_ports = '{'d01, 'd02, 'd03, 'd04, 'd04, 'd05, 'd6, 'd7, 'd9, 'd10, 'd11, 'd12, 'd13};       
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES; 
  intf_name = "sbr_ep2_vintf";
  pload_width = 16;
  pc_crd_buffer = 8;
  np_crd_buffer = 5;      
  create_agtvc_cfg (2, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);

  //Configure Agent config descriptor Agtvc3
  agt_my_ports = '{'d09};        
  agt_other_ports = '{'d0, 'd01, 'd02, 'd03, 'd04, 'd05, 'd6, 'd7, 'd8, 'd10, 'd11, 'd12, 'd13};       
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES; 
  intf_name = "sbr_ep3_vintf";
  pload_width = 16;
  pc_crd_buffer = 2;
  np_crd_buffer = 9;      
  create_agtvc_cfg (3, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);

  //Configure Agent config descriptor Agtvc4
  agt_my_ports = '{'d10};        
  agt_other_ports = '{'d00, 'd01, 'd02, 'd03, 'd04, 'd05, 'd6, 'd7, 'd9, 'd8, 'd11, 'd12, 'd13};       
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES; 
  intf_name = "sbr_ep4_vintf";
  pload_width = 8;
  pc_crd_buffer = 2;
  np_crd_buffer = 1;      
  create_agtvc_cfg (4, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);

  //Configure Agent config descriptor Agtvc5
  agt_my_ports = '{'d011};        
  agt_other_ports = '{'d00, 'd01, 'd02, 'd03, 'd04, 'd05, 'd6, 'd7, 'd9, 'd10, 'd8, 'd12, 'd13};       
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES; 
  intf_name = "sbr_ep5_vintf";
  pload_width = 8;
  pc_crd_buffer = 4;
  np_crd_buffer = 2;      
  create_agtvc_cfg (5, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);

  //Configure Agent config descriptor Agtvc6
  agt_my_ports = '{'d12};        
  agt_other_ports = '{'d00, 'd01, 'd02, 'd03, 'd04, 'd05, 'd6, 'd7, 'd9, 'd10, 'd11, 'd8, 'd13};       
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES; 
  intf_name = "sbr_ep6_vintf";
  pload_width = 16;
  pc_crd_buffer = 2;
  np_crd_buffer = 8;      
  create_agtvc_cfg (6, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);

  //Configure Agent config descriptor Agtvc7
  agt_my_ports = '{'d13};        
  agt_other_ports = '{'d00, 'd01, 'd02, 'd03, 'd04, 'd05, 'd6, 'd7, 'd9, 'd10, 'd11, 'd12, 'd8};       
  agt_mcast_ports = '{};     
  agt_supp_opcodes = iosfsbm_cm::DEFAULT_OPCODES; 
  intf_name = "sbr_ep7_vintf";
  pload_width = 16;
  pc_crd_buffer = 2;
  np_crd_buffer = 3;      
  create_agtvc_cfg (7, agt_my_ports, 
                    agt_other_ports, agt_mcast_ports, 
                    agt_supp_opcodes, intf_name,
                    pload_width,
                    np_crd_buffer, pc_crd_buffer);

      //Create Router cfg for rtr_sb
      create_rtr_cfg();
      
      //Create common_cfg for the whole network
      create_common_cfg();
      
endfunction

function void env::create_agtvc_cfg (iosfsbm_cm::nid_t nid,
                                     iosfsbm_cm::pid_t agt_my_ports[$],
                                     iosfsbm_cm::pid_t agt_other_ports[$],
                                     iosfsbm_cm::pid_t agt_mcast_ports[$],
                                     iosfsbm_cm::opcode_t agt_supp_opcodes[$],
                                     string intf_name,
                                     int pload_width,
                                     int np_crd_buffer,
                                     int pc_crd_buffer);

      string comp_name;
     
      
      //Create Agent VC configs for each node
      $sformat(comp_name, "agtvc_cfg_%0d", nid);

      ovm_report_info("NETWORK BUILDER", $psprintf("configure agtvc_cfg_%0d", nid));
      
      assert( $cast(agtvc_cfg_i[nid],
                    create_object("iosfsbm_agent::agtvc_cfg", comp_name)) )
         else ovm_report_fatal("CASTING", "Type mismatch");
      
       assert (agtvc_cfg_i[nid].randomize with {
                                         num_tx_ext_headers == 1;
                                         payload_width == pload_width;  
                                         my_ports.size() == agt_my_ports.size();
                                         other_ports.size() == agt_other_ports.size();
                                         mcast_ports.size() == agt_mcast_ports.size();
                                         foreach (agt_my_ports[i])
                                         my_ports[i] == agt_my_ports[i];
                                         foreach (agt_other_ports[i])
                                         other_ports[i] == agt_other_ports[i];
                                         foreach (agt_supp_opcodes[i])
                                         supported_opcodes[i] == agt_supp_opcodes[i];
                                         }) else
    ovm_report_error("RND", "Randomization failed");

      //set crd_buffer
      agtvc_cfg_i[nid].pc_crd_buffer = pc_crd_buffer;
      agtvc_cfg_i[nid].np_crd_buffer = np_crd_buffer;
      
      //set intf name
      agtvc_cfg_i[nid].intf_name = intf_name;
      agtvc_cfg_i[nid].no_agents = 8; //Number of nids
      //Set spec version
      agtvc_cfg_i[nid].set_iosfspec_ver(iosfsbm_cm::IOSF_090);         

      
endfunction // env

function void env::create_common_cfg();

      iosfsbm_cm::nid_t nids[$];
      
    //create common_cfg     
    assert( $cast(common_cfg_i, create_object("iosfsbm_cm::common_cfg", "common_cfg")) )
      else ovm_report_fatal("CASTING", "Type mismatch for common_cfg");

     nids = '{'h0,'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7};
                  
  // Calculate all valid ports in the system
  foreach(agtvc_cfg_i[nid])
    common_cfg_i.add_pids(agtvc_cfg_i[nid].my_ports);

  // Construct opcode mapping in the common cfg
  foreach(agtvc_cfg_i[nid])
    foreach(agtvc_cfg_i[nid].my_ports[i])
      common_cfg_i.add_opcode_map(agtvc_cfg_i[nid].my_ports[i], 
                                  agtvc_cfg_i[nid].supported_opcodes);

   common_cfg_i.set_broadcast_entries(nids.size());

   //Pass common_cfg to all
  set_config_object("*", "common_cfg", common_cfg_i, 0);

    
endfunction

function void env::create_rtr_cfg();
      string msg;
      iosfsbm_cm::nid_t nids[$];
      iosfsbm_cm::pid_t pids[$];

  //create rtr_cfg
    assert( $cast(rtr_cfg_i, create_object("iosfsbm_rtr::rtr_cfg", "rtr_cfg")) )
      else ovm_report_fatal("CASTING", "Type mismatch for rtr_cfg");

  //Configure rtr_cfg   
  nids = '{'h0,'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7};
  rtr_cfg_i.nids = nids;
      
  rtr_cfg_i.iosfsb_spec_rev = iosfsbm_cm::IOSF_090;
      
  //Build routing table
  foreach (agtvc_cfg_i[nid])
      begin
         pids = agtvc_cfg_i[nid].my_ports;
         foreach(pids[i])
         rtr_cfg_i.add_rtr_mapping(pids[i], nid);         
      end

   //debug messages  
  /*  $sformat(msg, "routing table for rtr");
    ovm_report_info("DBG", msg);
    foreach(rtr_cfg_i.rtr_table[pid] )
    begin
      nids = rtr_cfg_i.rtr_table[pid].data;
      foreach(nids[i])
      begin
        $sformat(msg, "routing nid = %h, pid = %d", nids[i], pid);
        ovm_report_info("DBG", msg);
      end
    end*/
endfunction
      
function void env::create_clk_rst_cfg();

    assert( $cast(clk_rst_cfg_i, create_object("clk_rst_cfg", "clk_rst_cfg")) )
      else ovm_report_fatal("CASTING", "Type mismatch for clk_rst_cfg");
    //configure clk_rst_cfg
     //configure clk_rst_cfg config member, add clocks for fabrics and agents
      clk_rst_cfg_i.add_clock(
                              .clock_number(0),
                              .clock_name("Clk_500"), 
                              .domain_name("clock_500"), 
                              .period(2));

      // Add reset 
      clk_rst_cfg_i.add_reset(
                              .clock_number(0),
                              .clock_name("Clk_500"), 
                              .count(10)//reset count
                              );
      set_config_object("*", "clk_rst_cfg", clk_rst_cfg_i, 0);
endfunction
 
function void env::create_pmu_cfgs();

    assert( $cast(iosf_pmu_base_cfg_i, create_object("iosf_pmu_base_cfg", "iosf_pmu_base_cfg")) )
      else ovm_report_fatal("CASTING", "Type mismatch for pmu_base_cfg");

    assert( $cast(iosf_pmu_cfg_i, create_object("iosf_pmu_cfg", "iosf_pmu_cfg")) )
      else ovm_report_fatal("CASTING", "Type mismatch for iosf_pmu_cfg");

ovm_report_info("NETWORK BUILDER", "configure pmu_cfgs");
   
      
     //configure iosf_pmu_base_cfg for entire network      
      iosf_pmu_base_cfg_i.randomize();
 
      iosf_pmu_base_cfg_i.num_of_fbrcs = 1;
      iosf_pmu_base_cfg_i.cg_type = iosf_pmu::CG_OFF; //clock gating is enabled      
      iosf_pmu_base_cfg_i.fbrc_names.push_back("sbr");
      
      //configure iosf_pmu_cfg for each fabric
      iosf_pmu_cfg_i.clk_numbers["sbr"] = 0;
      iosf_pmu_cfg_i.fbrc_name = "sbr";
      iosf_pmu_cfg_i.fbrc_idx = 0;
      //configure iosf_pmu_cfg for each agent
      //agent is connected to node 0 of the fabric
      iosf_pmu_cfg_i.agt_names.push_back("agent0");
      iosf_pmu_cfg_i.agt_names.push_back("agent1");
      iosf_pmu_cfg_i.agt_names.push_back("agent2");
      iosf_pmu_cfg_i.agt_names.push_back("agent3");
      iosf_pmu_cfg_i.agt_names.push_back("agent4");
      iosf_pmu_cfg_i.agt_names.push_back("agent5");
      iosf_pmu_cfg_i.agt_names.push_back("agent6");
      iosf_pmu_cfg_i.agt_names.push_back("agent7");
      iosf_pmu_cfg_i.agt_nids.push_back(0);
      iosf_pmu_cfg_i.agt_nids.push_back(1);
      iosf_pmu_cfg_i.agt_nids.push_back(2);
      iosf_pmu_cfg_i.agt_nids.push_back(3);
      iosf_pmu_cfg_i.agt_nids.push_back(4);
      iosf_pmu_cfg_i.agt_nids.push_back(5);
      iosf_pmu_cfg_i.agt_nids.push_back(6);
      iosf_pmu_cfg_i.agt_nids.push_back(7);
      iosf_pmu_cfg_i.clk_numbers["agent0"] = 0;
      iosf_pmu_cfg_i.clk_numbers["agent1"] = 0;
      iosf_pmu_cfg_i.clk_numbers["agent2"] = 0;
      iosf_pmu_cfg_i.clk_numbers["agent3"] = 0;
      iosf_pmu_cfg_i.clk_numbers["agent4"] = 0;
      iosf_pmu_cfg_i.clk_numbers["agent5"] = 0;
      iosf_pmu_cfg_i.clk_numbers["agent6"] = 0;
      iosf_pmu_cfg_i.clk_numbers["agent7"] = 0;
      set_config_object("*", "iosf_pmu_base_cfg", iosf_pmu_base_cfg_i, 0);
      set_config_object("*", $psprintf("iosf_pmu_cfg_%s", iosf_pmu_cfg_i.fbrc_name),
                        iosf_pmu_cfg_i,0);
     
endfunction


     
`endif //INC_IOSF_SBC_ENV

