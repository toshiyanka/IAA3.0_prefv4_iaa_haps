//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 7/4/2013 
//-----------------------------------------------------------------
// Description:
// test14 class definition as part of test14_pkg
// Global reset DCN specific test
// Slices 5,6 are DEF_ON rest are DEF_OFF (default)
// Slice 2 global reset is tied off to 1, 
// Slice 6 and 4 global reset reassert later in the test, 
// Keep changing the freq change delay all the time and then issue
// the DIV ratio switching command on slices 1 and 2 randomly
//------------------------------------------------------------------

`ifndef INC_test14
`define INC_test14 

/**
 * TODO: Add class description
 */
class test14 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test14)
endclass :test14

/**
 * test14 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test14 
 */
function test14::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test14 class OVM build phase
 ******************************************************************************/
function void test14::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
    factory.set_type_override_by_type(ccu_vc_rand_delays::get_type(), ccu_vc_test_rand_dly:: get_type());

   // Configure children
   // ------------------
   i_ccu_vc_cfg.add_clk_source(0, "PSF0_CLK", 10);
   i_ccu_vc_cfg.add_clk_source(5, "PSF1_CLK", 12.5);
   i_ccu_vc_cfg.add_clk_source(3, "PSF3_CLK", 15.3);	

   //i_ccu_vc_cfg.randomize_clk_sources();
   i_ccu_vc_cfg.set_ref_clk_src(0);
   i_ccu_vc_cfg.add_slice(.slice_num(0), .slice_name("PSF0"), .clk_status(ccu_types::CLK_GATED), .req1_to_clk1(25ps),
	   					  .req0_to_ack0(6), .clkack_delay(8), .enable_random_phase(1),.randomize_clk1_to_ack1(1),
						  .clk1_to_ack1(4));
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF0_PORT0"), .usync_enabled(1), .clk_src(5),
	   					  .clk1_to_ack1(4), .req0_to_ack0(3), .clkack_delay(10));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF0_PORT1"), .clk_src(5), .half_divide_ratio(0), .req1_to_clk1(20ps), 
	   				      .req0_to_ack0(4), .randomize_req1_to_clk1(1));  //8
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF0_PORT2"), .clk_src(3), .half_divide_ratio(1),
	   					  .enable_random_phase(1));  //16
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF0_PORT4"), .enable_random_phase(1), .randomize_req0_to_ack0(1),
   						  .req0_to_ack0(6));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF0_PORT5"), .clk_status(ccu_types::CLK_UNGATED),
   						  .req1_to_clk1(40ps),.clk1_to_ack1(2), .req0_to_ack0(4), .clkack_delay(9),
						  .enable_random_phase(1), .def_status(ccu_types::DEF_ON));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF0_PORT6"), .enable_random_phase(1), .usync_enabled(1),
	   					  .def_status(ccu_types::DEF_ON));
 
endfunction :build

/******************************************************************************
 * test14 class OVM run phase
 ******************************************************************************/
task test14::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);

  `ovm_info ("test14", "Handshake delay randomized along with the random phase", OVM_INFO)

  repeat (40)
  //repeat (10) 
  begin
    #1000;
    assert (xaction.randomize() with {slice_num inside {1,2};cmd==ccu_types::FREQ_CHANGE_DLY;freq_change_delay inside {[30:35]};});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
    #1000;
	assert (xaction.randomize() with {slice_num inside {1,2};cmd==ccu_types::DIVIDE_RATIO;div_ratio inside {ccu_types::DIV_2,ccu_types::DIV_1};});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
 
  end
  ovm_top.stop_request();

endtask

`endif //INC_test14

