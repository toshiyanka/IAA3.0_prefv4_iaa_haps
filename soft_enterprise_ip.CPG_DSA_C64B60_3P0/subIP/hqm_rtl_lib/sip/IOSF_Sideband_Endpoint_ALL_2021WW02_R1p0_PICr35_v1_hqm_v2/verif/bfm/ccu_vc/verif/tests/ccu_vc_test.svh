//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-01-10 
//-----------------------------------------------------------------
// Description:
// ccu_vc_test class definition as part of ccu_vc_test_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_vc_test
`define INC_ccu_vc_test 

/**
 * TODO: Add class description
 */
class ccu_vc_test extends ccu_vc_test_base;
   //------------------------------------------
   // Data Members 
   //------------------------------------------

   //------------------------------------------
   // Constraints 
   //------------------------------------------
   
   //------------------------------------------
   // Methods 
   //------------------------------------------
   
   // Standard OVM Methods 
   extern function       new   (string name = "", ovm_component parent = null);
   extern function void  build ();
   extern task run();
   
   // APIs 
   
   // OVM Macros 
   `ovm_component_utils (ccu_vc_test_pkg::ccu_vc_test)
endclass :ccu_vc_test

/**
 * ccu_vc_test Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type ccu_vc_test 
 */
function ccu_vc_test::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * ccu_vc_test class OVM build phase
 ******************************************************************************/
function void ccu_vc_test::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
   
   // Configure children
   // ------------------
   i_ccu_vc_cfg.add_slice(0, "PSF0", 0, ccu_types::CLK_UNGATED, ccu_types::DIV_4, 1);
   i_ccu_vc_cfg.add_slice(1, "PSF0_PORT0", 10, ccu_types::CLK_UNGATED, ccu_types::DIV_2, 1);
   i_ccu_vc_cfg.add_slice(2, "PSF0_PORT1", 5, ccu_types::CLK_UNGATED, ccu_types::DIV_8, 1);
   i_ccu_vc_cfg.add_slice(3, "PSF0_PORT2", 3, ccu_types::CLK_UNGATED, ccu_types::DIV_16, 1);
endfunction :build

task ccu_vc_test::run();
  `ovm_info ("Empty Test", "This is an empty test that doesn't do anything", OVM_INFO)
  ovm_top.stop_request();

endtask

`endif //INC_ccu_vc_test

