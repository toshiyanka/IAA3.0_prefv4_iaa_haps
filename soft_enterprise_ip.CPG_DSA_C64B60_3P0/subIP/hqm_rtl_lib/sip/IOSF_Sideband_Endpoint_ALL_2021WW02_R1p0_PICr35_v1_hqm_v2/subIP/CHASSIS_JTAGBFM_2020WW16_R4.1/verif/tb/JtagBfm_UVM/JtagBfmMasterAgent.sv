//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
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
//
//  Collateral Description:
//  dteg-jtag_bfm
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  CHASSIS_JTAGBFM_2020WW16_R4.1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : JtagBfmMasterAgent.sv
//    DESIGNER    : Chelli, Vijaya
//    PROJECT     : JtagBfm
//    
//    
//    PURPOSE     : Master Agent for the UVM ENV
//    DESCRIPTION : This component initalizes and connects the DRIVER
//                  Sequencer and the Input Monitor components of the 
//                  ENV
//----------------------------------------------------------------------

`ifndef INC_JtagBfmMasterAgent
 `define INC_JtagBfmMasterAgent 

`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
class JtagBfmMasterAgent #(`JTAG_IF_PARAMS_DECL) extends uvm_agent;
`else    
class JtagBfmMasterAgent extends uvm_agent;
`endif

    // Components of the Master Agent
    JtagBfmSequencer         Sequencer;
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    JtagBfmDriver        #(`JTAG_IF_PARAMS_INST) Driver;
    JtagBfmInputMonitor  #(`JTAG_IF_PARAMS_INST) InputMonitor;
    JtagBfmOutputMonitor #(`JTAG_IF_PARAMS_INST) OutputMonitor;
    JtagBfmTracker       #(`JTAG_IF_PARAMS_INST) JtagTracker;
`else    
    JtagBfmDriver            Driver;
    JtagBfmInputMonitor      InputMonitor;
    JtagBfmOutputMonitor     OutputMonitor;
    JtagBfmTracker           JtagTracker;
`endif
   
    // Agent level analysis Port for the Packet to transfer 
    // from Monitor to Scoreboards as required.
    uvm_analysis_port #(JtagBfmOutMonSbrPkt) JtagBfmOutputMonitorPort;
    uvm_analysis_port #(JtagBfmInMonSbrPkt) JtagBfmInputMonitorPort;

    // All Component of the Agent Enabled By Default
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;
    protected bit enable_clk_gating;
    protected bit park_clk_at;
    protected bit sample_tdo_on_negedge; //Non IEEE compliance mode, used only for TAP's not on the boundary of SoC.
    protected bit config_trstb_value_en;
    protected bit config_trstb_value;
    protected bit override_tdo_data;
    protected bit override_tdi_data;
    protected bit unsplit_ir_dr_data;
    string msg;
  
    // Handle to Event pool 
    uvm_event_pool eventPool;
   
    // Register component with Factory
    // for simple components with field macros
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
    `uvm_component_param_utils_begin(JtagBfmMasterAgent #(CLOCK_PERIOD,PWRGOOD_SRC,CLK_SRC,BFM_MON_CLK_DIS))
`else    
    `uvm_component_utils_begin(JtagBfmMasterAgent)
`endif
       `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
       `uvm_field_int(enable_clk_gating, UVM_ALL_ON)
       `uvm_field_int(park_clk_at, UVM_ALL_ON)
       `uvm_field_int(sample_tdo_on_negedge, UVM_ALL_ON)
       `uvm_field_int(config_trstb_value_en, UVM_ALL_ON)
       `uvm_field_int(config_trstb_value, UVM_ALL_ON)
       `uvm_field_int(override_tdi_data, UVM_ALL_ON)
       `uvm_field_int(unsplit_ir_dr_data, UVM_ALL_ON)
       `uvm_field_int(override_tdo_data, UVM_ALL_ON)
    `uvm_component_utils_end

    //********************************************
    // new - constructor
    //********************************************
    function new(string name = "JtagBfmMasterAgent",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //********************************************
    // Build
    //********************************************
    virtual function void build_phase(uvm_phase phase);  
        super.build_phase(phase);
        eventPool= new("JtagBfm_EventPool");
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
        InputMonitor    = JtagBfmInputMonitor #(`JTAG_IF_PARAMS_INST)::type_id::create("InputMonitor",this);
        OutputMonitor   = JtagBfmOutputMonitor #(`JTAG_IF_PARAMS_INST)::type_id::create("OutputMonitor",this);
        JtagTracker     = JtagBfmTracker #(`JTAG_IF_PARAMS_INST)::type_id::create("JtagTracker",this);
`else    
        InputMonitor    = JtagBfmInputMonitor::type_id::create("InputMonitor",this);
        OutputMonitor   = JtagBfmOutputMonitor::type_id::create("OutputMonitor",this);
        JtagTracker     = JtagBfmTracker::type_id::create("JtagTracker",this);
`endif
        // checking for the agent configuration
        if(!(uvm_config_int::get(this, "","is_active",is_active))) begin
         `uvm_info(get_full_name(), "JtagBfmAgent: is_active not explicitley set: using the default value ", UVM_LOW)
        end
        `ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
            $swrite (msg, "Value of BFM_MON_CLK_DIS = ",BFM_MON_CLK_DIS);
        `endif
        `uvm_info (get_full_name(), msg, UVM_NONE);
        `uvm_info(get_full_name(), "JtagBfmAgent: active agent exists at this hierarchy!", UVM_LOW);
        if(is_active== UVM_ACTIVE) begin
          uvm_config_int::set(this, "Driver", "enable_clk_gating", enable_clk_gating);
          uvm_config_int::set(this, "Driver", "config_trstb_value_en", config_trstb_value_en);
          uvm_config_int::set(this, "Driver", "config_trstb_value", config_trstb_value);
          uvm_config_int::set(this, "OutputMonitor", "override_tdo_data", override_tdo_data);
          uvm_config_int::set(this, "InputMonitor", "override_tdi_data", override_tdi_data);
          uvm_config_int::set(this, "InputMonitor", "unsplit_ir_dr_data", unsplit_ir_dr_data);
          uvm_config_int::set(this, "Driver", "park_clk_at", park_clk_at);
          //https://hsdes.intel.com/home/default.html#article?id=1503984885
          //Added to capture tdo at negedge along with posedge of clock
          uvm_config_int::set(this, "Driver", "sample_tdo_on_negedge",sample_tdo_on_negedge);
          Sequencer   = JtagBfmSequencer::type_id::create("Sequencer",this);
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS    
          Driver      = JtagBfmDriver #(`JTAG_IF_PARAMS_INST)::type_id::create("Driver",this);
`else    
          Driver      = JtagBfmDriver::type_id::create("Driver",this);
`endif
        end            
        uvm_config_int::set(this, "JtagTracker", "unsplit_ir_dr_data", unsplit_ir_dr_data);
        uvm_config_int::set(this, "JtagTracker", "sample_tdo_on_negedge",sample_tdo_on_negedge);
        InputMonitor.eventPool = eventPool;
        OutputMonitor.eventPool = eventPool;

        //Agent level analysys ports
        JtagBfmInputMonitorPort  = new("JtagBfmInputMonitorPort",this);
        JtagBfmOutputMonitorPort = new("JtagBfmOutputMonitorPort",this);

        JtagTracker.jtag_tracker_agent_name = get_name();
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase (phase);
    //********************************************
    // Connect the Driver to the Sequencer
    //********************************************
        if(is_active == UVM_ACTIVE) begin
           Driver.seq_item_port.connect(Sequencer.seq_item_export);
        end
    //*******************************************************************************
    // Connecting the monitor analysys ports to agent analysys ports for flexibility
    // User need not go into the monitor level to connect to the analysys port.
    // Instead can directly connect to the agent level JtagBfmInputMonitorPort and
    // JtagBfmOutputMonitorPort
    //*******************************************************************************
        InputMonitor.InputMonitorPort.connect(JtagBfmInputMonitorPort);
        OutputMonitor.OutputMonitorPort.connect(JtagBfmOutputMonitorPort);

    endfunction : connect_phase
   
endclass : JtagBfmMasterAgent
`endif // INC_JtagBfmMasterAgent
