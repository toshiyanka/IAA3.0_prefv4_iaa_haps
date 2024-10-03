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
//    PURPOSE     : Agent for the DfxSecurePlugin ENV
//    DESCRIPTION : This component initalizes and connects the Driver,
//                  Sequencer and the Monitor components of the ENV.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Agent
`define INC_DfxSecurePlugin_Agent

//-------------
// Agent Class
//-------------
class DfxSecurePlugin_Agent #(`DSP_TB_PARAMS_DECL) extends ovm_agent;

   //--------------------------------------------
   // The virtual interface to drive DUT signals
   //--------------------------------------------
   //protected virtual DfxSecurePlugin_pin_if pins;

   //-------------------------------------------
   // ACTIVE / PASSIVE Mode Of Operation Switch
   //-------------------------------------------
   protected ovm_active_passive_enum is_active = OVM_ACTIVE;

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
   `ovm_component_param_utils_begin (DfxSecurePlugin_Agent#(`DSP_TB_PARAMS_INST))
      `ovm_field_enum (ovm_active_passive_enum, is_active, OVM_ALL_ON)
   `ovm_component_utils_end

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_Agent",
                        ovm_component parent = null);
   extern function void build ();
   extern function void end_of_elaboration ();
   extern function void connect ();

   extern task run ();
endclass : DfxSecurePlugin_Agent

/***************************************************************
 * Standard OVM new function creates a new object 
 *  @param name    : ovm name
 *  @param parent  : ovm parent component
 ***************************************************************/
function DfxSecurePlugin_Agent::new (string name = "DfxSecurePlugin_Agent",
                                 ovm_component parent = null);
   super.new (name, parent);
endfunction : new
 
/***************************************************************
 * Standard OVM build function
 ***************************************************************/
function void DfxSecurePlugin_Agent::build ();
   super.build ();

   // Monitor Instance always present
   i_DfxSecurePlugin_InpMon = DfxSecurePlugin_InpMonitor#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_InpMon", this);
   i_DfxSecurePlugin_OutMon = DfxSecurePlugin_OutMonitor#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_OutMon", this);

   if (is_active == OVM_ACTIVE)
   begin
      // Sequencer Instances present only when agent is active
      i_DfxSecurePlugin_Seqr   = DfxSecurePlugin_Seqr::type_id::create ("i_DfxSecurePlugin_Seqr", this);
      i_DfxSecurePlugin_Driver = DfxSecurePlugin_Driver#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_Driver", this);
   end
endfunction : build
 
/***************************************************************
 * Standard OVM end_of_elaboration function
 ***************************************************************/
function void DfxSecurePlugin_Agent::end_of_elaboration ();
   string msg;
   integer verb_level = OVM_LOW;

   super.end_of_elaboration ();

    if ($value$plusargs ("verbosity=%d", verb_level)) begin
       $swrite (msg, "plusarg: DSP verbosity = %0d", verb_level);
       `ovm_info ("get_type_name", msg, 5);
       set_report_verbosity_level_hier(verb_level);
    end else begin
       //set_report_verbosity_level_hier(OVM_NONE);      // 0
       set_report_verbosity_level_hier(OVM_LOW);       // 100
       //set_report_verbosity_level_hier(OVM_MEDIUM);    // 200
       //set_report_verbosity_level_hier(OVM_HIGH);      // 300
       //set_report_verbosity_level_hier(OVM_FULL);      // 400
       //set_report_verbosity_level_hier(OVM_DEBUG);     // 500
    end   

endfunction : end_of_elaboration
 
/***************************************************************
 * Standard OVM connect function
 ***************************************************************/
function void DfxSecurePlugin_Agent::connect ();

   if (is_active == OVM_ACTIVE)
   begin
      i_DfxSecurePlugin_Driver.seq_item_port.connect (i_DfxSecurePlugin_Seqr.seq_item_export);
   end
endfunction : connect

/***************************************************************
 * Run Task
 ***************************************************************/
task DfxSecurePlugin_Agent::run ();

   string msg;

   int dfx_secure_feat = TB_DFX_NUM_OF_FEATURES_TO_SECURE;

   $swrite (msg, "DEBUG_DSP: When ip-dfxsecure_plugin is instantiated in another IP, the value of parameter TB_DFX_NUM_OF_FEATURES_TO_SECURE passed from top is %0d: ", dfx_secure_feat); 
   `ovm_info (get_type_name(), msg, OVM_HIGH);

endtask : run
 
`endif // INC_DfxSecurePlugin_Agent
