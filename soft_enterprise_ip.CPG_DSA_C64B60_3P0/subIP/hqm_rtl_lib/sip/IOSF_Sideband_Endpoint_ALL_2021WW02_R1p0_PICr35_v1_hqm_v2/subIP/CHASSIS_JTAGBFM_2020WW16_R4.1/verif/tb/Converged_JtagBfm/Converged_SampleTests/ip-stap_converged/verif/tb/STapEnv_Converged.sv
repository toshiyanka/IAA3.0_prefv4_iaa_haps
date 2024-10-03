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
//    FILENAME    : STapEnv.sv
//    DESIGNER    : Shivaprashant Bulusu
//    PROJECT     : sTAP
//
//    PURPOSE     : The OVM ENV file for the sTAP
//    DESCRIPTION : Instantiation  and connection of the MasterAgent;
//                  ScoreBoard; Coverage and the output monitor. Also the
//                  configurable parameter like quit count are set here.
//-----------------------------------------------------------------------------

// Saola run phase is halted to FULSH_PHASE so that ovm_tests run phase
//  will be complete prior to Saola run phase
class Tap_flush_seq extends ovm_sequence;
    `include "ovm_macros.svh"

  //`ovm_sequence_utils(Tap_flush_seq, STapPkg::TapSequencer)
  `ovm_object_utils(Tap_flush_seq)

  function new(string name = "Tap_flush_seq" );
    super.new(name);
  endfunction : new

  virtual task body();
     `ovm_info(get_type_name(),"Waiting forever as Saola is dummy",OVM_MEDIUM)
     wait (1'b0);
  endtask : body
endclass : Tap_flush_seq

class STapEnv #(`STAP_DSP_TB_PARAMS_DECL) extends sla_tb_env;
//class STapEnv extends ovm_env;

    //dfx_tap_agent    stap_JtagMasterAgent;
	dfx_tap_agent               tap_agent;
  dfx_env tap_env;

    DfxSecurePlugin_Agent #(`STAP_DSP_TB_PARAMS_INST) stap_DfxSecurePlugin_Agent;
    STapScoreBoard        #(`STAP_DSP_TB_PARAMS_INST) ScoreBoard;

    STapInputMonitor      InputMonitor;
    STapOutputMonitor     OutputMonitor;

    ovm_report_handler    ReportComponent;

    // Control properties
    protected int has_scoreboard = 1;
    protected int has_cov_collector = 1;
    protected ovm_active_passive_enum is_active = OVM_ACTIVE;


    // Constructor
    function new(string name = "Env", ovm_component parent = null);
        super.new(name, parent);
        ReportComponent = new;
    endfunction :new


    // Register component with Factory
    `ovm_component_param_utils_begin(STapEnv #(`STAP_DSP_TB_PARAMS_INST))
      `ovm_field_int(has_scoreboard,    OVM_FLAGS_ON)
      `ovm_field_int(has_cov_collector, OVM_FLAGS_ON)
    `ovm_component_utils_end

    // Virtual Interface
    protected virtual stap_pin_if pin_if;
    protected virtual dfx_jtag_if Primary_if;
    //protected virtual DfxSecurePlugin_pin_if pins;

    // build
    virtual function void build();
        super.build();

        //set_config_int("*gMasterAgent*", "TapNumPorts", 1); // this will be set multiple times, on
        set_config_int("*", "TapNumPorts", 1); // this will be set multiple times, on
       // set_config_int("*", "enable_dfx", 1);
        //stap_JtagMasterAgent       = dfx_tap_agent::type_id::create("stap_JtagMasterAgent",this);
        // tap_agent       = dfx_tap_agent::type_id::create("tap_agent",this);
      tap_env = dfx_env::type_id::create("tap_env", this);
        stap_DfxSecurePlugin_Agent = DfxSecurePlugin_Agent#(`STAP_DSP_TB_PARAMS_INST)::type_id::create("stap_DfxSecurePlugin_Agent",this);
        if(has_scoreboard)
            ScoreBoard = STapScoreBoard#(`STAP_DSP_TB_PARAMS_INST)::type_id::create("ScoreBoard",this);


        InputMonitor  = STapInputMonitor::type_id::create("InputMonitor",this);
        OutputMonitor = STapOutputMonitor::type_id::create("OutputMonitor",this);

    endfunction : build

    // Connect the Input Monitor and Output Monitor Analysis Port to ScoreBoard and Coverage Component
    virtual function void connect();

        // Temp Object
        ovm_object temp;

        STapVifContainer  vif_container;

        super.connect ();

      tap_agent = tap_env.tap_env.tap_agent;

        // Get the JtagBfm PinIf and assign it to pin_if for running the Saola clock required for the TB
        // Connect the system core clock signal to the sla_tb_env and RAL env. Hence no need for secondary_if here.
        assert(get_config_object("V_STAP_PINIF", temp));
        $cast(vif_container, temp);
        pin_if = vif_container.get_v_if();

        if(has_scoreboard) begin
            InputMonitor.InputMonitorPort.connect(ScoreBoard.InputMonExport);
			for (dfx_tap_port_e tp_i = tp_i.first(); tp_i != tap_agent.TapNumPorts; tp_i = tp_i.next()) begin
              tap_agent.jtag_ipmon_port_array[tp_i].connect(ScoreBoard.JtagInputMonExport);
              tap_agent.jtag_opmon_port_array[tp_i].connect(ScoreBoard.JtagOutputMonExport);
            end

            stap_DfxSecurePlugin_Agent.i_DfxSecurePlugin_OutMon.OutputMonitorPort.connect(ScoreBoard.DspOutputMonExport);
            OutputMonitor.OutputMonitorPort.connect(ScoreBoard.OutputMonExport);
        end

        // In the build phase of Saola, a new virtual sequencer gets created for any Env (STapEnv is newed in STapBaseTest)
        // By using set_test_phase_type we attach the Tap_flush_seq to the virtual sequencer created by Saola
        // Hence get_name = Env

        if (_level == SLA_TOP) begin
           this.set_test_phase_type(get_name(), "FLUSH_PHASE", "Tap_flush_seq");
        end

    endfunction : connect

    function void end_of_elaboration();
       super.end_of_elaboration();
       ovm_top.enable_print_topology = 0;
//       print_config_settings();
    endfunction

    //--------------------------------------------------------------------
    // Task Run
    //--------------------------------------------------------------------
    task run;
        super.run();// Saola run phase to be called to kick off sla run phase; comptible with Saola version v20110929

        $display("--------------------------------------------------------------");
        $display("The Hierarchy of the components in TAP ENV is displayed Below ");
        $display("--------------------------------------------------------------");
        $display("-----------------------------------------------------");
    endtask : run

   virtual task set_clk_rst ();
      fork
         // Connect the system core clock signal to the sla_tb_env and RAL env.
         // Core clock is needed to drive the test flow.
         forever
         begin
            @ (pin_if.tck);
            #0;

            if (pin_if.tck === 1'b1)
            begin
               -> sys_clk_r;
               //uncomment it when ral_env is defined.
              // -> ral.ref_clk;
            end

            if (pin_if.tck === 1'b0)
               -> sys_clk_f;
         end

         //Connect the system reset signal to the sla_tb_env.
         forever
         begin
            @ (pin_if.trst_b);
            #0;

            if (pin_if.trst_b === 1'b1)
               -> sys_rst_r;
            if (pin_if.trst_b === 1'b0)
               -> sys_rst_f;
         end
      join_none;
   endtask : set_clk_rst

endclass : STapEnv
