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
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
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
class DfxSecurePlugin_BaseTest #(`DSP_TB_PARAMS_DECL) extends ovm_test;

   //---------------------------------
   // Register Component with Factory
   //---------------------------------
   `ovm_component_param_utils (DfxSecurePlugin_BaseTest #(`DSP_TB_PARAMS_INST))

   //-----------------------
   // Instance of ENV Class
   //-----------------------
   DfxSecurePlugin_Env  #(`DSP_TB_PARAMS_INST) i_DfxSecurePlugin_Env;

   //-----------------
   // Class Functions
   //-----------------
   extern function new (string name = "DfxSecurePlugin_BaseTest",
                        ovm_component parent = null);
   extern function void build ();
   extern function void connect ();

   //-------------
   // Class Tasks
   //-------------
   extern virtual task run ();

endclass : DfxSecurePlugin_BaseTest

/***************************************************************
 * Standard OVM new function creates a new object 
 *  @param name    : ovm name
 *  @param parent  : ovm parent component
 ***************************************************************/
function DfxSecurePlugin_BaseTest::new (string name = "DfxSecurePlugin_BaseTest",
                            ovm_component parent = null);
   super.new (name, parent);
endfunction : new

/***************************************************************
 * Standard OVM build function
 ***************************************************************/
function void DfxSecurePlugin_BaseTest::build ();
   string msg;
   $swrite (msg, "Executing Build function");
   `ovm_info (get_type_name(), msg, OVM_LOW);

   // To disable random sequence from starting at the begin of run task
   set_config_int ("i_DfxSecurePlugin_Env.i_DfxSecurePlugin_Agent.i_DfxSecurePlugin_Seqr", "count", 0);
   set_config_int ("i_DfxSecurePlugin_Env.*", "is_active", OVM_ACTIVE);

   super.build ();

   // DfxSecurePlugin_ ENV instance
   i_DfxSecurePlugin_Env = DfxSecurePlugin_Env#(`DSP_TB_PARAMS_INST)::type_id::create ("i_DfxSecurePlugin_Env", this);

endfunction : build

/***************************************************************
 * Standard OVM connect function
 ***************************************************************/
function void DfxSecurePlugin_BaseTest::connect ();
   string msg;
   $swrite (msg, "Executing Connect function");
   `ovm_info (get_type_name(), msg, OVM_LOW);
   super.connect ();
endfunction : connect

/***************************************************************
 * Standard OVM Run Task
 ***************************************************************/
task DfxSecurePlugin_BaseTest::run ();
    global_stop_request ();
endtask : run

`endif // INC_DfxSecurePlugin_BaseTest
