//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 2012-01-10 
//-----------------------------------------------------------------
// Description:
// test01 class definition as part of test01_pkg
//------------------------------------------------------------------

`ifndef INC_test01
`define INC_test01 

/**
 * TODO: Add class description
 */
class test01 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test01)
endclass :test01

/**
 * test01 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test01 
 */
function test01::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test01 class OVM build phase
 ******************************************************************************/
function void test01::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
   
   // Configure children
   // ------------------
   i_ccu_vc_cfg.add_clk_source(0, "PSF0_CLK", 8ns);

   //i_ccu_vc_cfg.randomize_clk_sources();
   i_ccu_vc_cfg.add_slice(.slice_num(0), .slice_name("PSF0"), .clk_src(0), .clk_status(ccu_types::CLK_UNGATED),.divide_ratio(ccu_types::DIV_1), .usync_enabled(1));
   //i_ccu_vc_cfg.add_slice(1, "PSF0_PORT0", 0, ccu_types::CLK_UNGATED, ccu_types::DIV_2, 1);
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF0_PORT0"), .clk_src(0),.clk_status(ccu_types::CLK_GATED),.usync_enabled(1));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF0_PORT1"), .divide_ratio(ccu_types::DIV_8), .usync_enabled(1));
   //i_ccu_vc_cfg.add_slice(3, "PSF0_PORT2", 3, ccu_types::CLK_UNGATED, ccu_types::DIV_16, 1);
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF0_PORT2"), .divide_ratio(ccu_types::DIV_4), .usync_enabled(1));
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF0_PORT4"), .usync_enabled(1));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF0_PORT5"), .clk_status(ccu_types::CLK_UNGATED),.divide_ratio(ccu_types::DIV_2));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF0_PORT6"), .clk_status(ccu_types::CLK_UNGATED),.divide_ratio(ccu_types::DIV_1));

endfunction :build

task test01::run();
  `ovm_info ("Test01", "Test has 4 slices and RTL fluctuates clkreq", OVM_INFO)
  #100000;
  ovm_top.stop_request();

endtask

`endif //INC_test01

