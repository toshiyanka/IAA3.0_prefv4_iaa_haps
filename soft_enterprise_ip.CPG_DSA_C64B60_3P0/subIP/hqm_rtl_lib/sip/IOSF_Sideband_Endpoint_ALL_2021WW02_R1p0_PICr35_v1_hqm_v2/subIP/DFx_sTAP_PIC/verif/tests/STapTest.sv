//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : STapTest.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//
//    PURPOSE     : Program File for the OVM ENV
//    DESCRIPTION : This file includes all the tests and is instantiated
//                  in the Taptop
//----------------------------------------------------------------------
`include "STAPTestPkg.sv"
program STapTest();

    import uvm_pkg::*;
    import ovm_pkg::*;
    import xvm_pkg::*;
   `include "ovm_macros.svh"
   `include "xvm_macros.svh"
    import sla_pkg::*;
    import STAPTestPkg::*;

    //Add Your Tests File Here
    initial begin
      string testname;

      ovm_report_info("STap Test","TEST Starts !!!!");
      if ($value$plusargs("UVM_TESTNAME=%s", testname  )) begin
	xvm_pkg::run_test("", testname,   xvm::EOP_UVM);
      end else if ($value$plusargs("OVM_TESTNAME=%s", testname  )) begin
	xvm_pkg::run_test( testname,"",xvm::EOP_OVM);
      end

        //run_test();
    end

endprogram
