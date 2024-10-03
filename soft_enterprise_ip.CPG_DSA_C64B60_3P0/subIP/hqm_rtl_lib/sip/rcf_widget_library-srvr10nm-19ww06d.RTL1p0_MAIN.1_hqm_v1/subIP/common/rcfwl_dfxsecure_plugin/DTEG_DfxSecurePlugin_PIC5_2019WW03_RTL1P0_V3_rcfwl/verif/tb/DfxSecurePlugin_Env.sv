//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
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
//  dteg-dfxsecure_plugin
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_DfxSecurePlugin_PIC5_2019WW03_RTL1P0_V3
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_Agent.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : The OVM ENV class for the DfxSecurePlugin
//    DESCRIPTION : Instantiates  and connects the  Agent, DfxSecurePlugin
//                  ENV, ScoreBoard and the Coverage model.
//                  Also the configurable parameters are set here.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Env
`define INC_DfxSecurePlugin_Env

//-----------------------
// OVM Environment Class
//-----------------------
class DfxSecurePlugin_Env #(`DSP_TB_PARAMS_DECL) extends ovm_env;

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
   `ovm_component_param_utils_begin (DfxSecurePlugin_Env#(`DSP_TB_PARAMS_INST))
      `ovm_field_int (has_scoreboard, OVM_FLAGS_ON)
      `ovm_field_int (has_cov_collector, OVM_FLAGS_ON)
   `ovm_component_utils_end

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_Env",
                        ovm_component parent = null);
   extern function void build ();
   extern function void connect ();
   extern function void end_of_elaboration(); 
   extern virtual  task run(); 

endclass : DfxSecurePlugin_Env


/***************************************************************
 * Standard OVM new function creates a new object 
 *  @param name    : ovm name
 *  @param parent  : ovm parent component
 ***************************************************************/
function DfxSecurePlugin_Env::new (string name = "DfxSecurePlugin_Env",
                       ovm_component parent = null);
   super.new (name, parent);
endfunction : new


/***************************************************************
 * Standard OVM build function
 ***************************************************************/
function void DfxSecurePlugin_Env::build ();
   string inst_str;

   super.build ();

   // Instance of Scan Data Agent always exists
   i_DfxSecurePlugin_Agent = DfxSecurePlugin_Agent#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_Agent", this);

   if(has_scoreboard) begin
      i_DfxSecurePlugin_Scoreboard = DfxSecurePlugin_Scoreboard#(`DSP_TB_PARAMS_INST)::type_id::create("i_DfxSecurePlugin_Scoreboard",this);
   end
   if(has_cov_collector) begin
      i_DfxSecurePlugin_Coverage = DfxSecurePlugin_Coverage#()::type_id::create("i_DfxSecurePlugin_Coverage",this);
   end

endfunction : build


/***************************************************************
 * Standard OVM connect function
 ***************************************************************/
function void DfxSecurePlugin_Env::connect ();

   // Temp Object
   ovm_object temp;

   DfxSecurePlugin_VifContainer  #(`DSP_TB_PARAMS_INST) vif_container;

   super.connect();

   // Assigning virtual interface
   assert(get_config_object("V_DFXSECPLUGIN_VIF", temp));
   $cast(vif_container, temp);
   pins = vif_container.get_v_if();

   get_config_int("has_scoreboard", has_scoreboard);
   if(has_scoreboard) begin
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_InpMon.InputMonitorPort.connect(i_DfxSecurePlugin_Scoreboard.InputMonExport);
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_OutMon.OutputMonitorPort.connect(i_DfxSecurePlugin_Scoreboard.OutputMonExport);
   end
   get_config_int("has_cov_collector", has_cov_collector);
   if(has_cov_collector) begin
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_InpMon.InputMonitorPort.connect(i_DfxSecurePlugin_Coverage.InputMonExport);
       i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_OutMon.OutputMonitorPort.connect(i_DfxSecurePlugin_Coverage.OutputMonExport);
   end

endfunction : connect


/***************************************************************
 * Standard OVM run task 
 ***************************************************************/
function void DfxSecurePlugin_Env::end_of_elaboration ();
   string msg;
   integer verb_level = OVM_LOW;

   super.end_of_elaboration ();
   print_config_settings ();

    if ($value$plusargs ("verbosity=%d", verb_level)) begin
       $swrite (msg, "plusarg: DfxSecurePlugin verbosity = %0d", verb_level);
       `ovm_info (get_type_name(), msg, 5);
       set_report_verbosity_level_hier(verb_level);
    end else begin
       //set_report_verbosity_level_hier(OVM_LOW);
       //set_report_verbosity_level_hier(OVM_MEDIUM);
       set_report_verbosity_level_hier(OVM_HIGH);
    end   

   ovm_top.print_topology ();
endfunction : end_of_elaboration


/***************************************************************
 * Standard OVM run task 
 ***************************************************************/
task DfxSecurePlugin_Env::run ();
   super.run();
   `ovm_info (get_type_name(), "Run phase starts...", OVM_LOW);
endtask : run


`endif //INC_DfxSecurePlugin_Env
