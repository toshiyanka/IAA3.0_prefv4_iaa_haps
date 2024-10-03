// =====================================================================================================
// FileName          : dfx_test_program.sv
// Primary Contact   : Pankaj Sharma (pankaj.sharma@intel.com)
// Secondary Contact : Name (name@intel.com)
// Creation Date     :Mon Dec  8 21:47:20 CST 2014
// =====================================================================================================

// =====================================================================================================
// Description:
// -----------
// DFX TAP tests program level file
//
// For use in standalone DFx testbench only!
// =====================================================================================================

// =====================================================================================================
// Copyright 2020 Intel Corporation.
// This information is the confidential and proprietary property of Intel
// Corporation and the possession or use of this file requires a written license
// from Intel Corporation.
// =====================================================================================================

`ifndef DFX_TEST_PROGRAM_SV
`define DFX_TEST_PROGRAM_SV

`ifndef TEST_BASE
`define TEST_BASE dfx_base_test
`endif

program test();

  import ovm_pkg::*;
  `include "ovm_macros.svh"

  // Uncomment the following lines if VCS complains at runtime about not finding the test sequence.
  // import dfx_tap_test_pkg::*;

  `include "dfx_base_test.sv"
  `include "dfx_test.sv"

//  initial
//    run_test();
    
  initial begin
    string testname;

    //uvm_report_info("STap Test","TEST Starts !!!!");
    if ($value$plusargs("UVM_TESTNAME=%s", testname  )) begin
	  xvm_pkg::run_test("", testname,   xvm::EOP_UVM);
    end else if ($value$plusargs("OVM_TESTNAME=%s", testname  )) begin
	  xvm_pkg::run_test( testname,"",xvm::EOP_OVM);
    end
  end

endprogram : test

`endif // `ifndef DFX_TEST_PROGRAM_SV
