//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
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
//  %header_collateral%
//
//  Source organization:
//  %header_organization%
//
//  Support Information:
//  %header_support%
//
//  Revision:
//  %header_tag%
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_Agent.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : The UVM ENV class for the DfxSecurePlugin
//    DESCRIPTION : Instantiates  and connects the  Agent, DfxSecurePlugin
//                  ENV, ScoreBoard and the Coverage model.
//                  Also the configurable parameters are set here.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Env
`define INC_DfxSecurePlugin_Env

//-----------------------
// UVM Environment Class
//-----------------------
class DfxSecurePlugin_Env #(`DSP_TB_PARAMS_DECL) extends uvm_env;

   //--------------------------
   // ENV components instances
   //--------------------------
   DfxSecurePlugin_Agent       #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_Agent;
   DfxSecurePlugin_Scoreboard  #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_Scoreboard;
   DfxSecurePlugin_Coverage    #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_Coverage;
   
   //------------------------
   // DUT Interface instance
   //------------------------
   protected virtual DfxSecurePlugin_pin_if #(`DSP_TB_PARAMS_INST) pins;

   //--------------------
   // Control Properties
   //--------------------
   protected int has_scoreboard    = 1;      // Enable Scoreboard
   protected int has_cov_collector = 1;      // Enable Coverage

   //---------------------------------
   // Register component with Factory
   //---------------------------------
   `uvm_component_param_utils_begin (DfxSecurePlugin_Env#(`DSP_TB_PARAMS_INST))
      `uvm_field_int (has_scoreboard, UVM_FLAGS_ON)
      `uvm_field_int (has_cov_collector, UVM_FLAGS_ON)
   `uvm_component_utils_end

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_Env",
                        uvm_component parent = null);
   extern function void build_phase (uvm_phase phase);
   extern function void connect_phase (uvm_phase phase);
   extern function void end_of_elaboration_phase(uvm_phase phase); 
   extern virtual  task run_phase (uvm_phase phase); 

endclass : DfxSecurePlugin_Env


/***************************************************************
 * Standard UVM new function creates a new object 
 *  @param name    : uvm name
 *  @param parent  : uvm parent component
 ***************************************************************/
function DfxSecurePlugin_Env::new (string name = "DfxSecurePlugin_Env",
                       uvm_component parent = null);
   super.new (name, parent);
endfunction : new


/***************************************************************
 * Standard UVM build function
 ***************************************************************/
function void DfxSecurePlugin_Env::build_phase (uvm_phase phase);
   string inst_str;

   super.build_phase (phase);

   // Instance of Scan Data Agent always exists
   i_DfxSecurePlugin_Agent = DfxSecurePlugin_Agent#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_Agent", this);

   if(has_scoreboard) begin
      i_DfxSecurePlugin_Scoreboard = DfxSecurePlugin_Scoreboard#(`DSP_TB_PARAMS_INST)::type_id::create("i_DfxSecurePlugin_Scoreboard",this);
   end
   if(has_cov_collector) begin
      i_DfxSecurePlugin_Coverage = DfxSecurePlugin_Coverage#()::type_id::create("i_DfxSecurePlugin_Coverage",this);
   end

endfunction : build_phase


/***************************************************************
 * Standard UVM connect function
 ***************************************************************/
function void DfxSecurePlugin_Env::connect_phase (uvm_phase phase);  

   // Temp Object
   uvm_object temp;

   DfxSecurePlugin_VifContainer  #(`DSP_TB_PARAMS_INST) vif_container;

   super.connect_phase(phase);

   // Assigning virtual interface
   assert(uvm_config_object::get(this, "","V_DFXSECPLUGIN_VIF", temp));
   $cast(vif_container, temp);
   pins = vif_container.get_v_if();

   uvm_config_int::get(this, "","has_scoreboard", has_scoreboard);
   if(has_scoreboard) begin
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_InpMon.InputMonitorPort.connect(i_DfxSecurePlugin_Scoreboard.InputMonExport);
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_OutMon.OutputMonitorPort.connect(i_DfxSecurePlugin_Scoreboard.OutputMonExport);
   end
   uvm_config_int::get(this, "","has_cov_collector", has_cov_collector);
   if(has_cov_collector) begin
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_InpMon.InputMonitorPort.connect(i_DfxSecurePlugin_Coverage.InputMonExport);
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_OutMon.OutputMonitorPort.connect(i_DfxSecurePlugin_Coverage.OutputMonExport);
   end

endfunction : connect_phase


/***************************************************************
 * Standard UVM run task 
 ***************************************************************/
function void DfxSecurePlugin_Env::end_of_elaboration_phase (uvm_phase phase);
   string msg;
   integer verb_level = UVM_LOW;

   super.end_of_elaboration_phase (phase);
   print_config_settings ();

    if ($value$plusargs ("verbosity=%d", verb_level)) begin
       $swrite (msg, "plusarg: DfxSecurePlugin verbosity = %0d", verb_level);
       `uvm_info (get_type_name(), msg, 5);
       set_report_verbosity_level_hier(verb_level);
    end else begin
       //set_report_verbosity_level_hier(UVM_LOW);
       //set_report_verbosity_level_hier(UVM_MEDIUM);
       set_report_verbosity_level_hier(UVM_HIGH);
    end   

   uvm_top.print_topology ();
endfunction : end_of_elaboration_phase


/***************************************************************
 * Standard UVM run task 
 ***************************************************************/
task DfxSecurePlugin_Env::run_phase  (uvm_phase phase);
   super.run_phase(phase);
   `uvm_info (get_type_name(), "Run phase starts...", UVM_LOW);
endtask


`endif //INC_DfxSecurePlugin_Env
