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
//    FILENAME    : TapEnv.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAPNW
//
//
//    PURPOSE     : The OVM ENV file for the sTAP
//    DESCRIPTION : Instantiation  and connection of the MasterAgent;
//                  ScoreBoard; Coverage and the output monitor. Also the
//                  configurable parameter like quit count are set here.
//-----------------------------------------------------------------------------

// Saola run phase is halted to FULSH_PHASE so that ovm_tests run phase
// will be complete prior to Saola run phase

class Tap_flush_seq extends ovm_sequence;
    `include "ovm_macros.svh"

  `ovm_object_utils(Tap_flush_seq)

  function new(string name = "Tap_flush_seq" );
    super.new(name);
  endfunction : new

  virtual task body();
    `sla_info((get_type_name()),("Waiting forever as Saola is dummy"));
    if (`USE_SAOLA_IN_JTAGBFM_TESTS == 0) begin
       wait (1'b0);
    end
  endtask : body
endclass : Tap_flush_seq

//-----------------------------------------------------------------------------

class TapEnv extends sla_tb_env;

    // Components of the environment
    JtagBfmCfg           jtagBfmCfg;
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS
    JtagBfmMasterAgent  #(`SOC_PRI_JTAG_IF_PARAMS_INST) PriMasterAgent;
    JtagBfmMasterAgent  #(`SOC_SEC_JTAG_IF_PARAMS_INST)  SecMasterAgent;
    JtagBfmMasterAgent  #(`SOC_TR0_JTAG_IF_PARAMS_INST) Ter0MasterAgent;
    JtagBfmMasterAgent  #(`SOC_TR1_JTAG_IF_PARAMS_INST) Ter1MasterAgent;

`else
    JtagBfmMasterAgent   PriMasterAgent;
    JtagBfmMasterAgent   SecMasterAgent;
    JtagBfmMasterAgent   Ter0MasterAgent;
    JtagBfmMasterAgent   Ter1MasterAgent;
`endif
    TapScoreBoard        PriScoreBoard;
    TapScoreBoard        SecScoreBoard;

    TapCoverage          PriCoverage;
    TapCoverage          SecCoverage;

    ovm_report_handler   ReportComponent;

    // Control properties
    protected int has_scoreboard      = 1;
    protected int has_cov_collector   = 1;

    //new Constructor
    function new(string name = "Env", ovm_component parent = null);
        super.new(name, parent);
        ReportComponent = new;
    endfunction :new

    // Register component with Factory
    `ovm_component_utils_begin(TapEnv)
      `ovm_field_object (jtagBfmCfg, OVM_ALL_ON|OVM_NOPRINT)
      `ovm_field_int(has_scoreboard,    OVM_FLAGS_ON)
      `ovm_field_int(has_cov_collector, OVM_FLAGS_ON)
    `ovm_component_utils_end

     // Virtual Interfaces
     virtual JtagBfmIntf Primary_if;

     //--------------------------------
     // Build all the components of Env
     //--------------------------------
     virtual function void build();
         super.build();

         jtagBfmCfg       = JtagBfmCfg::type_id::create("jtagBfmCfg");

         set_config_int("PriScoreBoard","primary_scrbrd",1);
         set_config_int("SecScoreBoard","secondary_scrbrd",1);

         // To Disable Sequencer and Driver set "is_active" to OVM_PASSIVE
         //set_config_int("PriMasterAgent", "is_active", OVM_ACTIVE);
         //set_config_int("SecMasterAgent", "is_active", OVM_ACTIVE);
         //set_config_int("Ter1MasterAgent", "is_active", OVM_ACTIVE);

         // To register the configuration descriptor
         set_config_object("*", "JtagBfmCfg", jtagBfmCfg, 0);

         // To Enable Clock Gating
         set_config_int("PriMasterAgent", "enable_clk_gating", jtagBfmCfg.enable_clk_gating);
         set_config_int("SecMasterAgent", "enable_clk_gating", jtagBfmCfg.enable_clk_gating);
         set_config_int("Ter0MasterAgent", "enable_clk_gating", jtagBfmCfg.enable_clk_gating);
         set_config_int("Ter1MasterAgent", "enable_clk_gating", jtagBfmCfg.enable_clk_gating);

         // To Chosoe at what value Clocks is at when Gated
         set_config_int("PriMasterAgent", "park_clk_at", jtagBfmCfg.park_clk_at);
         set_config_int("SecMasterAgent", "park_clk_at", jtagBfmCfg.park_clk_at);
         set_config_int("Ter0MasterAgent", "park_clk_at", jtagBfmCfg.park_clk_at);
         set_config_int("Ter1MasterAgent", "park_clk_at", jtagBfmCfg.park_clk_at);

         set_config_int("PriMasterAgent.JtagTracker", "primary_tracker", 1);
         set_config_int("SecMasterAgent.JtagTracker", "secondary_tracker", 1);
         set_config_int("Ter0MasterAgent.JtagTracker", "tertiary_tracker", 2'b01);
         set_config_int("Ter1MasterAgent.JtagTracker", "tertiary_tracker", 2'b10);

         set_config_int("*MasterAgent.JtagTracker", "jtag_bfm_tracker_en",        1);
         set_config_int("*MasterAgent.JtagTracker", "jtag_bfm_runtime_tracker_en",1);
         set_config_string("*MasterAgent.JtagTracker", "tracker_name",  "SOC_TAPNW");

         set_config_string("PriMasterAgent.JtagTracker", "tracker_name", "SOC_TAPNW_PRI");
         set_config_string("SecMasterAgent.JtagTracker", "tracker_name", "SOC_TAPNW_SEC");
         set_config_string("Ter0MasterAgent.JtagTracker", "tracker_name", "SOC_TAPNW_TER0");
         set_config_string("Ter1MasterAgent.JtagTracker", "tracker_name", "SOC_TAPNW_TER1");
`ifdef CHASSIS_JTAGBFM_USE_PARAMETERIZED_CLASS
     PriMasterAgent      = JtagBfmMasterAgent#(`SOC_PRI_JTAG_IF_PARAMS_INST)::type_id::create("PriMasterAgent",this);
     SecMasterAgent      = JtagBfmMasterAgent#(`SOC_PRI_JTAG_IF_PARAMS_INST)::type_id::create("SecMasterAgent",this);
     Ter0MasterAgent     = JtagBfmMasterAgent#(`SOC_PRI_JTAG_IF_PARAMS_INST)::type_id::create("Ter0MasterAgent",this);
     Ter1MasterAgent     = JtagBfmMasterAgent#(`SOC_PRI_JTAG_IF_PARAMS_INST)::type_id::create("Ter1MasterAgent",this);

    `else
     PriMasterAgent      = JtagBfmMasterAgent::type_id::create("PriMasterAgent",this);
         SecMasterAgent      = JtagBfmMasterAgent::type_id::create("SecMasterAgent",this);
         Ter0MasterAgent      = JtagBfmMasterAgent::type_id::create("Ter0MasterAgent",this);
         Ter1MasterAgent      = JtagBfmMasterAgent::type_id::create("Ter1MasterAgent",this);
`endif

         if(has_scoreboard) begin
             PriScoreBoard    = TapScoreBoard::type_id::create("PriScoreBoard",this);
             SecScoreBoard    = TapScoreBoard::type_id::create("SecScoreBoard",this);
         end

         if(has_cov_collector) begin
             PriCoverage      = TapCoverage::type_id::create("PriCoverage",this);
             SecCoverage      = TapCoverage::type_id::create("SecCoverage",this);
         end

         //--IPMonInt            = TapInputMonitorInt::type_id::create("IPMonInt",this);

         // Set the Verbosity Level for Report Messages here
         set_report_verbosity_level_hier(jtagBfmCfg.set_verbosity);

         // Set the Max Error count after which the simulation stops
         ReportComponent.set_max_quit_count(jtagBfmCfg.quit_count);

         // Saola Compliance
         if (_level == SLA_TOP)
         begin
            _default_phase_delay = 0;
            _default_phase_timeout = 10_000_000_000;
            _phase_delay_list["POWER_GOOD_PHASE"] = 0;
            _phase_delay_list["HARD_RESET_PHASE"] = 0;
            _phase_delay_list["WARM_RESET_PHASE"] = 0;
            _phase_delay_list["TRAINING_PHASE"] = 0;
            _phase_delay_list["CONFIG_PHASE"] = 0;
            _phase_delay_list["DATA_PHASE"] = 0;
            _phase_delay_list["FLUSH_PHASE"] = 0;
            _phase_timeout_list["POWER_GOOD_PHASE"] = 0;
         end

     endfunction : build

    //--------------------------------
    // Print the topology
    //--------------------------------
    function void end_of_elaboration();
       super.end_of_elaboration();
       ovm_top.enable_print_topology = 0;
       print_config_settings();
       set_global_timeout( 0 );
       set_global_stop_timeout( 0 );
       set_max_run_clocks( 0 );
    endfunction

    //--------------------------------
    // Connect the Input Monitor and Output Monitor Analysis Port to ScoreBoard and Coverage Component
    //--------------------------------
    virtual function void connect();

        // Assign Virtual Pin interface to Input and Output Monitor by doing a get of the interface
        ovm_object temp;

        // TAP Interface Container instatiation
        TapVifContainer i_TapVifContainer;
        sla_vif_container #(virtual JtagBfmIntf) vif_container;

        super.connect ();

        // Get the JtagBfm PinIf and assign it to Primary_if for running the Saola clock required for the TB
        // Connect the system core clock signal to the sla_tb_env and RAL env. Hence no need for secondary_if here.
        assert(get_config_object("V_JTAGBFM_PIN_IF", temp));
        $cast(vif_container, temp);
        Primary_if = vif_container.get_v_if();

        if(has_scoreboard) begin
            PriMasterAgent.InputMonitor.InputMonitorPort.connect(PriScoreBoard.InputMonExport);
            SecMasterAgent.InputMonitor.InputMonitorPort.connect(SecScoreBoard.InputMonExport);

            PriMasterAgent.OutputMonitor.OutputMonitorPort.connect(PriScoreBoard.OutputMonExport);
            SecMasterAgent.OutputMonitor.OutputMonitorPort.connect(SecScoreBoard.OutputMonExport);
        end

        if(has_cov_collector) begin
            PriMasterAgent.InputMonitor.InputMonitorPort.connect(PriCoverage.InputMonExport);
            SecMasterAgent.InputMonitor.InputMonitorPort.connect(SecCoverage.InputMonExport);

            PriMasterAgent.OutputMonitor.OutputMonitorPort.connect(PriCoverage.OutputMonExport);
            SecMasterAgent.OutputMonitor.OutputMonitorPort.connect(SecCoverage.OutputMonExport);
        end

        // In the build phase of Saola, a new virtual sequencer gets created for any Env (TapEnv is newed in TapBaseTest)
        // By using set_test_phase_type we attach the Tap_flush_seq to the virtual sequencer created by Saola
        // Hence get_name = Env

        if (_level == SLA_TOP) begin
           void'(this.add_sequencer("SLA_SEQUENCER", "jtag_id1", PriMasterAgent.Sequencer));
           void'(this.add_sequencer("SLA_SEQUENCER", "jtag_id2", SecMasterAgent.Sequencer));
           void'(this.add_sequencer("SLA_SEQUENCER", "jtag_id3", Ter0MasterAgent.Sequencer));
           void'(this.add_sequencer("SLA_SEQUENCER", "jtag_id4", Ter1MasterAgent.Sequencer));
           this.set_test_phase_type(get_name(), "FLUSH_PHASE", "Tap_flush_seq");
        end

    endfunction : connect

    //-------------
    // Task Run
    //-------------
    task run;
        super.run();// Saola run phase to be called to kick off sla run phase; comptible with Saola version v20110210
        $display("--------------------------------------------------------------");
        $display("The Hierarchy of the components in TAP ENV is displayed Below ");
        $display("--------------------------------------------------------------");
        depth_first(this);
        $display("-----------------------------------------------------");
    endtask : run

    //--------------------------------------------------------------------
    // visit
    //--------------------------------------------------------------------
    virtual function void visit(ovm_component node,
                                 int unsigned level = 0);
       int unsigned i;
       for(i = 0; i < level; i++) begin
          $write("|  ");
       end

       if(node.get_num_children() > 0)
          $display("+ %s", node.get_full_name());
       else
          $display(node.get_full_name());
     endfunction

    //--------------------------------------------------------------------
    // depth_first
    //
    // Classic depth-first traversal algorithm.
    //--------------------------------------------------------------------
    function void depth_first(ovm_component node,
                              int unsigned level = 0);

      string name;
      if(node == null)
        return;

      visit(node, level);
      if(node.get_first_child(name))
          do begin
              depth_first(node.get_child(name), level+1);
          end while(node.get_next_child(name));

     endfunction

   //------------------
   // Saola Compliance
   //------------------
   virtual task set_clk_rst ();
      fork
         // Connect the system core clock signal to the sla_tb_env and RAL env.
         // Core clock is needed to drive the test flow.
         forever
         begin
            @ (Primary_if.jtagbfm_clk);
            #0;

            if (Primary_if.jtagbfm_clk === 1'b1)
            begin
               -> sys_clk_r;
               //uncomment it when ral_env is defined.
              // -> ral.ref_clk;
            end

            if (Primary_if.jtagbfm_clk === 1'b0)
               -> sys_clk_f;
         end

         //Connect the system reset signal to the sla_tb_env.
         forever
         begin
            @ (Primary_if.powergood_rst_b);
            #0;

            if (Primary_if.powergood_rst_b === 1'b1)
               -> sys_rst_r;
            if (Primary_if.powergood_rst_b === 1'b0)
               -> sys_rst_f;
         end
      join_none;
   endtask : set_clk_rst

endclass : TapEnv
