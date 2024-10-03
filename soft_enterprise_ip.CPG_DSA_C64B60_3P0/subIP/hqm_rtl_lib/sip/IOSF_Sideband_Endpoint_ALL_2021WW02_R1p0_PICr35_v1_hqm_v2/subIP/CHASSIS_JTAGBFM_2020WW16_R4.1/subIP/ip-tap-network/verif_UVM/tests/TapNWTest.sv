//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : TapNWTest.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : TAP NW
//    
//    
//    PURPOSE     : Program File for the UVM ENV 
//    DESCRIPTION : This file includes all the tests and is instantiated
//                  in the Taptop 
//----------------------------------------------------------------------
program TapNWTest();

    import uvm_pkg::*;
    import TapPkg::*;
    import JtagBfmPkg::*;

    `include "uvm_macros.svh"

    // This extends uvm_test class and instatiates uvm_env
    `include "TapBaseTest.sv"
    `include "TapTests.sv"
    `include "MyTapTests.sv"

      string testname;

  initial begin

        uvm_report_info("Tap NW Test","TEST Starts !!!!");   
        
 if ($value$plusargs("UVM_TESTNAME=%s", testname  ))
    uvm_pkg::run_test(testname);
end
endprogram
