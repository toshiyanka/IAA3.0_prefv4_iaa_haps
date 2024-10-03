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
//    FILENAME    : TapEnv.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//    
//    
//    PURPOSE     : The UVM ENV file for the sTAP 
//    DESCRIPTION : Instantiation  and connection of the MasterAgent;
//                  ScoreBoard; Coverage and the output monitor. Also the
//                  configurable parameter like quit count are set here.
//-----------------------------------------------------------------------------
class TapEnv extends uvm_env;

    // Components of the environment
    JtagBfmMasterAgent   PriMasterAgent;
    JtagBfmMasterAgent   SecMasterAgent;

    TapScoreBoard        PriScoreBoard;
    TapScoreBoard        SecScoreBoard;
   
    TapInputMonitorInt   PriIPMonInt;
    TapInputMonitorInt   SecIPMonInt;
   
    TapCoverage          PriCoverage; 
    TapCoverage          SecCoverage; 

    uvm_report_handler   ReportComponent;

    // Control properties
    protected int has_scoreboard      = 1;
    protected int has_cov_collector   = 1;

    //new Constructor
    function new(string name = "Env", uvm_component parent = null);
        super.new(name, parent);
        ReportComponent = new;
    endfunction :new

    // Register component with Factory
    `uvm_component_utils_begin(TapEnv)
      `uvm_field_int(has_scoreboard,    UVM_FLAGS_ON)
      `uvm_field_int(has_cov_collector, UVM_FLAGS_ON)
    `uvm_component_utils_end

     //--------------------------------
     // Build all the components of Env
     //--------------------------------
     virtual function void build_phase(uvm_phase phase); 
         super.build_phase(phase);

         uvm_config_int::set(this, "PriScoreBoard","primary_scrbrd",1);
         uvm_config_int::set(this, "SecScoreBoard","secondary_scrbrd",1);

         // To Disable Sequencer and Driver set "is_active" to UVM_PASSIVE
         uvm_config_int::set(this, "PriMasterAgent", "is_active", UVM_ACTIVE);
         uvm_config_int::set(this, "SecMasterAgent", "is_active", UVM_ACTIVE);

         PriMasterAgent      = JtagBfmMasterAgent::type_id::create("PriMasterAgent",this);
         SecMasterAgent      = JtagBfmMasterAgent::type_id::create("SecMasterAgent",this);

         if(has_scoreboard) begin
             PriScoreBoard    = TapScoreBoard::type_id::create("PriScoreBoard",this);
             SecScoreBoard    = TapScoreBoard::type_id::create("SecScoreBoard",this);
         end

         if(has_cov_collector) begin
             PriCoverage      = TapCoverage::type_id::create("PriCoverage",this);
             SecCoverage      = TapCoverage::type_id::create("SecCoverage",this);
         end

         PriIPMonInt        = TapInputMonitorInt::type_id::create("PriIPMonInt",this);
         SecIPMonInt        = TapInputMonitorInt::type_id::create("SecIPMonInt",this);
        
    endfunction : build_phase

    //--------------------------------
    // Print the topology
    //--------------------------------
    function void end_of_elaboration_phase(uvm_phase phase);
       super.end_of_elaboration_phase(phase);
       uvm_top.enable_print_topology = 0;       
       print_config_settings();
       set_global_timeout( 0 );
       set_global_stop_timeout( 0 );
    endfunction

    //--------------------------------
    // Connect the Input Monitor and Output Monitor Analysis Port to ScoreBoard and Coverage Component
    //--------------------------------
    virtual function void connect_phase(uvm_phase phase);

        super.connect_phase (phase);

        if(has_scoreboard) begin
            PriMasterAgent.InputMonitor.InputMonitorPort.connect(PriScoreBoard.InputMonExport);
            SecMasterAgent.InputMonitor.InputMonitorPort.connect(SecScoreBoard.InputMonExport);

            PriIPMonInt.InputMonitorIntPort.connect(PriScoreBoard.InputMonIntExport);
            SecIPMonInt.InputMonitorIntPort.connect(SecScoreBoard.InputMonIntExport);

            PriMasterAgent.OutputMonitor.OutputMonitorPort.connect(PriScoreBoard.OutputMonExport);
            SecMasterAgent.OutputMonitor.OutputMonitorPort.connect(SecScoreBoard.OutputMonExport);
        end

        if(has_cov_collector) begin
            PriMasterAgent.InputMonitor.InputMonitorPort.connect(PriCoverage.InputMonExport);
            SecMasterAgent.InputMonitor.InputMonitorPort.connect(SecCoverage.InputMonExport);
            
            PriIPMonInt.InputMonitorIntPort.connect(PriCoverage.InputMonIntExport);
            SecIPMonInt.InputMonitorIntPort.connect(SecCoverage.InputMonIntExport);

            PriMasterAgent.OutputMonitor.OutputMonitorPort.connect(PriCoverage.OutputMonExport);
            SecMasterAgent.OutputMonitor.OutputMonitorPort.connect(SecCoverage.OutputMonExport);
        end

    endfunction : connect_phase

endclass : TapEnv
