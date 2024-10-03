//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr
// Date Created : 2012-01-10 
//-----------------------------------------------------------------
// Description:
// test17 class definition as part of test17_pkg
// This test is meant to catch the case where clock is defined as 
// a default off but clkreq is asserted during reset 
// OR
// clock is defined as default on but clkreq is deasserted during 
// reset
//------------------------------------------------------------------

`ifndef INC_test17
`define INC_test17 

/**
 * TODO: Add class description
 */
class test17 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test17)
endclass :test17

/**
 * test17 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test17 
 */
function test17::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test17 class OVM build phase
 ******************************************************************************/
function void test17::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
   
   // Configure children
   // ------------------
   i_ccu_vc_cfg.add_clk_source(0, "PSF0_CLK", 10);
   i_ccu_vc_cfg.add_clk_source(5, "PSF1_CLK", 12.5);
   i_ccu_vc_cfg.add_clk_source(3, "PSF3_CLK", 15.3);	

   //i_ccu_vc_cfg.randomize_clk_sources();

   i_ccu_vc_cfg.set_ref_clk_src(0);
   i_ccu_vc_cfg.add_slice(.slice_num(0), .slice_name("PSF0"));
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF0_PORT0"), .clk_status(ccu_types::CLK_UNGATED),/*.in_phase_with_slice_num(3),*/ .enable_random_phase(0), .def_status("DEF_ON"));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF0_PORT1"), .clk_src(5), .half_divide_ratio(1), .def_status("DEF_OFF")); 
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF0_PORT2"), .clk_status(ccu_types::CLK_UNGATED),.clk_src(0), .enable_random_phase(0));  
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF0_PORT4"), .dcg_blk_num(0), .req0_to_ack0(18), .clkack_delay(10), .in_phase_with_slice_num(3), .enable_random_phase(0));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF0_PORT5"), .clk_status(ccu_types::CLK_GATED),.dcg_blk_num(0), .in_phase_with_slice_num(3), .enable_random_phase(0));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF0_PORT6"), .clk_status(ccu_types::CLK_GATED),.dcg_blk_num(0), .in_phase_with_slice_num(3), .enable_random_phase(0));


   //i_ccu_vc_cfg.set_to_passive();
endfunction :build

/******************************************************************************
 * test17 class OVM run phase
 ******************************************************************************/
task test17::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);
  assert(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i != null);
  
  `ovm_info ("test17", "DEF_ON/OFF for slices 1 and 2", OVM_INFO)

    #10000;
	assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::CLK_SRC;clk_src==3;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
	#500000;

  ovm_top.stop_request();

endtask

`endif //INC_test17

