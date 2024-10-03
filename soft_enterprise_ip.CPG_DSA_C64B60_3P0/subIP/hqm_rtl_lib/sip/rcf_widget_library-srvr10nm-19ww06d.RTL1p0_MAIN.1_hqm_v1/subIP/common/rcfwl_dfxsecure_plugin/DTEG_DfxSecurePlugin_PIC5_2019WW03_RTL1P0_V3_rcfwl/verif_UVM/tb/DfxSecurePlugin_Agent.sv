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
//    PURPOSE     : Agent for the DfxSecurePlugin ENV
//    DESCRIPTION : This component initalizes and connects the Driver,
//                  Sequencer and the Monitor components of the ENV.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Agent
`define INC_DfxSecurePlugin_Agent

//-------------
// Agent Class
//-------------
class DfxSecurePlugin_Agent #(`DSP_TB_PARAMS_DECL) extends uvm_agent;

   //--------------------------------------------
   // The virtual interface to drive DUT signals
   //--------------------------------------------
   //protected virtual DfxSecurePlugin_pin_if pins;

   //-------------------------------------------
   // ACTIVE / PASSIVE Mode Of Operation Switch
   //-------------------------------------------
   protected uvm_active_passive_enum is_active = UVM_ACTIVE;

   //----------------------------------
   // Components of the ScanData Agent
   //----------------------------------
   DfxSecurePlugin_Seqr          i_DfxSecurePlugin_Seqr;
   DfxSecurePlugin_Driver        #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_Driver;
   DfxSecurePlugin_InpMonitor    #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_InpMon;
   DfxSecurePlugin_OutMonitor    #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_OutMon;
   

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `uvm_component_param_utils_begin (DfxSecurePlugin_Agent#(`DSP_TB_PARAMS_INST))
      `uvm_field_enum (uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_component_utils_end

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_Agent",
                        uvm_component parent = null);
   extern function void build_phase (uvm_phase phase);
   extern function void end_of_elaboration_phase (uvm_phase phase);
   extern function void connect_phase (uvm_phase phase);

   extern task run_phase  (uvm_phase phase);
endclass : DfxSecurePlugin_Agent

/***************************************************************
 * Standard UVM new function creates a new object 
 *  @param name    : uvm name
 *  @param parent  : uvm parent component
 ***************************************************************/
function DfxSecurePlugin_Agent::new (string name = "DfxSecurePlugin_Agent",
                                 uvm_component parent = null);
   super.new (name, parent);
endfunction : new
 
/***************************************************************
 * Standard UVM build function
 ***************************************************************/
function void DfxSecurePlugin_Agent::build_phase (uvm_phase phase);
   super.build_phase (phase);

   // Monitor Instance always present
   i_DfxSecurePlugin_InpMon = DfxSecurePlugin_InpMonitor#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_InpMon", this);
   i_DfxSecurePlugin_OutMon = DfxSecurePlugin_OutMonitor#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_OutMon", this);

   if (is_active == UVM_ACTIVE)
   begin
      // Sequencer Instances present only when agent is active
      i_DfxSecurePlugin_Seqr   = DfxSecurePlugin_Seqr::type_id::create ("i_DfxSecurePlugin_Seqr", this);
      i_DfxSecurePlugin_Driver = DfxSecurePlugin_Driver#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_Driver", this);
   end
endfunction : build_phase
 
/***************************************************************
 * Standard UVM end_of_elaboration function
 ***************************************************************/
function void DfxSecurePlugin_Agent::end_of_elaboration_phase (uvm_phase phase);
   string msg;
   integer verb_level = UVM_LOW;

   super.end_of_elaboration_phase (phase);

    if ($value$plusargs ("verbosity=%d", verb_level)) begin
       $swrite (msg, "plusarg: DSP verbosity = %0d", verb_level);
       `uvm_info ("get_type_name", msg, 5);
       set_report_verbosity_level_hier(verb_level);
    end else begin
       //set_report_verbosity_level_hier(UVM_NONE);      // 0
       set_report_verbosity_level_hier(UVM_LOW);       // 100
       //set_report_verbosity_level_hier(UVM_MEDIUM);    // 200
       //set_report_verbosity_level_hier(UVM_HIGH);      // 300
       //set_report_verbosity_level_hier(UVM_FULL);      // 400
       //set_report_verbosity_level_hier(UVM_DEBUG);     // 500
    end   

endfunction : end_of_elaboration_phase
 
/***************************************************************
 * Standard UVM connect function
 ***************************************************************/
function void DfxSecurePlugin_Agent::connect_phase (uvm_phase phase);

   if (is_active == UVM_ACTIVE)
   begin
      i_DfxSecurePlugin_Driver.seq_item_port.connect (i_DfxSecurePlugin_Seqr.seq_item_export);
   end
endfunction : connect_phase

/***************************************************************
 * Run Task
 ***************************************************************/
task DfxSecurePlugin_Agent::run_phase  (uvm_phase phase);

   string msg;

   int dfx_secure_feat = TB_DFX_NUM_OF_FEATURES_TO_SECURE;

   $swrite (msg, "DEBUG_DSP: When ip-dfxsecure_plugin is instantiated in another IP, the value of parameter TB_DFX_NUM_OF_FEATURES_TO_SECURE passed from top is %0d: ", dfx_secure_feat); 
   `uvm_info (get_type_name(), msg, UVM_HIGH);

endtask
 
`endif // INC_DfxSecurePlugin_Agent
