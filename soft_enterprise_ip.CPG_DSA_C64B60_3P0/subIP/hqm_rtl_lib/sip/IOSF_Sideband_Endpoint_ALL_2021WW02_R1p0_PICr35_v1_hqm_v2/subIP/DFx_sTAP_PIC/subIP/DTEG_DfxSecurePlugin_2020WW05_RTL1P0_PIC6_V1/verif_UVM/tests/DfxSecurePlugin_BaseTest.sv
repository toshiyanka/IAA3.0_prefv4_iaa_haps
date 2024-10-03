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

//------------------------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_BaseTest.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : This is the base test for DfxSecurePlugin IP
//    DESCRIPTION : The Base test instantiates the ENV class and includes
//                  the common tasks for other tests.
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_BaseTest
`define INC_DfxSecurePlugin_BaseTest

//-----------------
// Base Test Class
//-----------------
class DfxSecurePlugin_BaseTest #(`DSP_TB_PARAMS_DECL) extends uvm_test;

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `uvm_component_param_utils (DfxSecurePlugin_BaseTest #(`DSP_TB_PARAMS_INST))

   //-----------------------
   // Instance of ENV Class
   //-----------------------
   DfxSecurePlugin_Env  #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_Env;

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_BaseTest",
                        uvm_component parent = null);
   extern function void build_phase (uvm_phase phase);
   extern function void connect_phase (uvm_phase phase);

   //-------------
   // Class Tasks
   //-------------
   extern virtual task run_phase  (uvm_phase phase);

endclass : DfxSecurePlugin_BaseTest

/***************************************************************
 * Standard UVM new function creates a new object 
 *  @param name    : uvm name
 *  @param parent  : uvm parent component
 ***************************************************************/
function DfxSecurePlugin_BaseTest::new (string name = "DfxSecurePlugin_BaseTest",
                            uvm_component parent = null);
   super.new (name, parent);
endfunction : new

/***************************************************************
 * Standard UVM build function
 ***************************************************************/
function void DfxSecurePlugin_BaseTest::build_phase (uvm_phase phase); 
   string msg;
   $swrite (msg, "Executing Build function");
   `uvm_info (get_type_name(), msg, UVM_LOW);

   // To disable random sequence from starting at the begin of run task
   uvm_config_int::set(this, "i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr", "count", 0);
   uvm_config_int::set(this, "i_DfxSecurePlugin_Env.*", "is_active", UVM_ACTIVE);

   super.build_phase (phase);

   // DfxSecurePlugin_ ENV instance
   i_DfxSecurePlugin_Env = DfxSecurePlugin_Env#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_Env", this);

endfunction : build_phase

/***************************************************************
 * Standard UVM connect function
 ***************************************************************/
function void DfxSecurePlugin_BaseTest::connect_phase (uvm_phase phase);
   string msg;
   $swrite (msg, "Executing Connect function");
   `uvm_info (get_type_name(), msg, UVM_LOW);
   super.connect_phase (phase);
endfunction : connect_phase

/***************************************************************
 * Standard UVM Run Task
 ***************************************************************/
task DfxSecurePlugin_BaseTest::run_phase  (uvm_phase phase);
       phase.raise_objection(this);
       phase.drop_objection(this);
   // uvm_pkg::global_stop_request ();
endtask

`endif // INC_DfxSecurePlugin_BaseTest
