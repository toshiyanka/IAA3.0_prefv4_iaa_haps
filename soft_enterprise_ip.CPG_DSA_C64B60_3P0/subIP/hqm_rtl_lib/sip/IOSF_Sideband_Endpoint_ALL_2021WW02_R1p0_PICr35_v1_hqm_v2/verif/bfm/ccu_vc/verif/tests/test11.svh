//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 4/10/2013 
//-----------------------------------------------------------------
// Description:
// test11 class definition as part of test11_pkg
// Lets the ccu bfm randomize the phase relation between all slices
// all clocks will look out of phase since enable_random_phase = 1
//------------------------------------------------------------------

`ifndef INC_test11
`define INC_test11 

/**
 * TODO: Add class description
 */
class test11 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test11)
endclass :test11

/**
 * test11 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test11 
 */
function test11::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test11 class OVM build phase
 ******************************************************************************/
function void test11::build ();
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
   i_ccu_vc_cfg.add_slice(.slice_num(0), .slice_name("PSF0"), .clk_status(ccu_types::CLK_UNGATED), .req1_to_clk1(25ps),
	   					  .req0_to_ack0(6), .def_status(ccu_types::DEF_ON), .clkack_delay(8), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF0_PORT0"), .usync_enabled(1), .dcg_blk_num(2), .clk_src(5),
	   					  .clk1_to_ack1(4), .req0_to_ack0(3), .clkack_delay(10));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF0_PORT1"), .clk_src(5), .half_divide_ratio(0), .dcg_blk_num(2),
	   					  .req1_to_clk1(150ps), .req0_to_ack0(4));  //8
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF0_PORT2"), .clk_src(3), .half_divide_ratio(1),
	   					  .enable_random_phase(1));  //16
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF0_PORT4"), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF0_PORT5"), .clk_status(ccu_types::CLK_UNGATED),
   						  .req1_to_clk1(40ps),.clk1_to_ack1(2), .req0_to_ack0(4), .clkack_delay(9),
						  .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF0_PORT6"), .enable_random_phase(1), .usync_enabled(1));
 
endfunction :build

/******************************************************************************
 * test11 class OVM run phase
 ******************************************************************************/
task test11::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);

  `ovm_info ("test11", "Handshake delay randomized along with the random phase", OVM_INFO)

  repeat (40)
  //repeat (10) 
  begin
    #10ns;
    assert (xaction.randomize() with {slice_num inside {1,2};cmd==ccu_types::REQ0_TO_ACK0;req0_to_ack0 inside {[12:15]};});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
  end
  ovm_top.stop_request();

endtask

`endif //INC_test11

