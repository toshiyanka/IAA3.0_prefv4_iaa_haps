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
//    PURPOSE     : Program File for the OVM ENV 
//    DESCRIPTION : This file includes all the tests and is instantiated
//                  in the Taptop 
//----------------------------------------------------------------------
program TapNWTest();

    import ovm_pkg::*;
    import TapPkg::*;
    import JtagBfmPkg::*;

    `include "ovm_macros.svh"

    // This extends ovm_test class and instatiates ovm_env
    `include "TapBaseTest.sv"
    `include "TapTests.sv"
    `include "MyTapTests.sv"

    initial begin
        ovm_report_info("Tap NW Test","TEST Starts !!!!");   
        run_test();
    end

endprogram
