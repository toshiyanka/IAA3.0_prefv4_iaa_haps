//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
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
//  2020WW22_PICr33
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapInputMonitorInt.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : Input Monitor for the DUT
//    DESCRIPTION : Monitors the pin that drive the DUT and sends 
//                  the relevent information to the Scoreboard
//                  The Monitor has the FSM State Machine to replicate
//                  the behaviour of RTL
//----------------------------------------------------------------------

class TapInputMonitorInt extends uvm_monitor;

    // Packet to the ScoreBoard
    TapInMonIntSbrPkt Packet;

    // Local Variable Declaration
    int i;

    // Analysis Port for the Packet to transfer from Monitor to Scoreboard
    uvm_analysis_port #(TapInMonIntSbrPkt) InputMonitorIntPort;

    // Register component with Factory
    `uvm_component_utils(TapInputMonitorInt)
   
    // Constructor
    function new (string name = "TapInputMonitorInt", uvm_component parent = null);
        super.new(name,parent);
        Packet = new();
        InputMonitorIntPort= new("InputMonitorIntPort",this);
    endfunction : new

    // Virtual Interface
    //virtual Control_IF ControlIF;

    // Interface to Monitor the Input pin Interface
    //function void assign_vi(
    //                        virtual interface  Control_IF ControlIF
    //                        );
    //    this.ControlIF = ControlIF;
    //endfunction: assign_vi

    //********************************************
    // pin Interface for connection to the DUT
    //********************************************
    protected virtual Control_IF ControlIF;

    function void connect_phase(uvm_phase phase); 

        uvm_object temp;
        TapVifContainer  i_TapVifContainer;
        
        super.connect_phase (phase);

        // Assigning virtual interface
        // Get the TAPNW Control_IF interface & assign it to the virtual interface
        // Pass the same Control_IF to as many instances of the InputIntMonitors (PriIPMonInt, SecIPMonInt, TerIPMonInt)
        assert(uvm_config_object::get(this, "","V_TAPNW_PINIF", temp));
        $cast(i_TapVifContainer, temp);
        ControlIF = i_TapVifContainer.get_tapnw_ctl_vif();

        // Code removed from TapEnv is following.
        //assert(uvm_config_object::get(this, "","V_TAPNW_PINIF", temp));
        //$cast(i_TapVifContainer, temp);
        //Control_if   = i_TapVifContainer.get_tapnw_ctl_vif();
        //PriIPMonInt.assign_vi(Control_if);
        //SecIPMonInt.assign_vi(Control_if);

    endfunction : connect_phase



    virtual task run_phase (uvm_phase phase);
        //************************************************************
        // Update the Transaction packet to Scoreboard at each clock
        //************************************************************
        forever begin
            //#1ns;
            @(posedge ControlIF.tapnw_clk);
            Packet.sec_sel    = ControlIF.sec_select;
            Packet.enable_tdo = ControlIF.enable_tdo;
            Packet.enable_tap = ControlIF.enable_tap;
            Packet.vercode    = ControlIF.vercode;
            for(i=0; i<NO_OF_TAP; i++) begin
                Packet.slvidcode[i]  = ControlIF.slvidcode[i];
            end
            InputMonitorIntPort.write(Packet); 
        end
    
    endtask

endclass : TapInputMonitorInt
