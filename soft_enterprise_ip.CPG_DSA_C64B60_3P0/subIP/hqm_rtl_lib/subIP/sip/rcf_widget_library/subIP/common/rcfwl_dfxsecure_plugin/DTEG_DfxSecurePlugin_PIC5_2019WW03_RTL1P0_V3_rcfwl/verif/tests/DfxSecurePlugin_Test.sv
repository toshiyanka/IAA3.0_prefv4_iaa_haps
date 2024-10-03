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

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_Test.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Program File for the OVM ENV
//    DESCRIPTION : This file includes all the tests and issues the 
//                  run_test call and is instantiated in the DfxSecurePlugin_TbTop
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Test
`define INC_DfxSecurePlugin_Test

`include "DfxSecurePlugin_TbDefines.svh"
`include "DfxSecurePlugin_Test_Pkg.sv"

//------------------------
// DfxSecurePlugin_Test Program Block
//------------------------
program DfxSecurePlugin_Test ();
   //----------------------------------------
   // Importing OVM Package and DfxSecurePlugin_ Package
   //----------------------------------------
    `ifdef DTEG_UVM_EN
    import uvm_pkg::*;
    `endif
    import ovm_pkg::*;
    `ifdef DTEG_XVM_EN
    import xvm_pkg::*;
    `endif
    `include "ovm_macros.svh"
    `ifdef DTEG_XVM_EN
    `include "xvm_macros.svh"
    `endif
   //import DfxSecurePlugin_Pkg::*;
   import DfxSecurePlugin_Test_Pkg::*;

   //--------------------------
   // Including the Test Files
   //--------------------------
//   `include "DfxSecurePlugin_BaseTest.sv"
//   `include "DfxSecurePlugin_TestLib.sv"
//   `include "dummy_simfigen_test.svh"
//
   //------------------
   // Calling run_test
   // Depending on the test name provided, this causes the task run in the test class to execute.
   //------------------
  initial begin
    string testname;

    `ovm_info ("DfxSecurePlugin_Test", "From Program Block. Test Starts ...", OVM_MEDIUM);
    `ifdef DTEG_XVM_EN
    if ($value$plusargs("UVM_TESTNAME=%s", testname  )) begin
	  xvm_pkg::run_test("", testname,   xvm::EOP_UVM);
    end else if ($value$plusargs("OVM_TESTNAME=%s", testname  )) begin
	  xvm_pkg::run_test( testname,"",xvm::EOP_OVM);
    end
    `else
    run_test();
    `endif
  end
//     initial begin
//     `ovm_info ("DfxSecurePlugin_Test", "From Program Block. Test Starts ...", OVM_MEDIUM);
//      run_test ();
//   end

endprogram : DfxSecurePlugin_Test

`endif // INC_DfxSecurePlugin_Test
