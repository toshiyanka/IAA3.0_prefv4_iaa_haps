//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_vc_test_mod module definition
//------------------------------------------------------------------

/**
 * Container for OVM Test
 */
module ccu_vc_test_mod;
   //------------------------------------------
   // Imports/Includes 
   //------------------------------------------

   // OVM
   import ovm_pkg::*;
   `include "ovm_macros.svh"

   // Base Package
   import ccu_vc_pkg::*;

   // Tests
   import ccu_vc_test_pkg::*;

   //------------------------------------------
   // OVM Test 
   //------------------------------------------
   initial begin : OVM_TEST_INIT

      // Generic OVM Settings
      // Comment/Uncomment as needed
      // ---------------------------

      // Compare
      ovm_default_comparer.show_max = 10;

      // Construction
      ovm_top.enable_print_topology = 1;
      factory.print();

      // End behavior
      ovm_top.finish_on_completion = 0;

      // Config debug
      // ovm_component::print_config_matches = 1;

      // Execute test 
      // ------------
      run_test();
      
      // Exit simulation
      // ---------------
      $finish(2);
   end : OVM_TEST_INIT
endmodule: ccu_vc_test_mod

