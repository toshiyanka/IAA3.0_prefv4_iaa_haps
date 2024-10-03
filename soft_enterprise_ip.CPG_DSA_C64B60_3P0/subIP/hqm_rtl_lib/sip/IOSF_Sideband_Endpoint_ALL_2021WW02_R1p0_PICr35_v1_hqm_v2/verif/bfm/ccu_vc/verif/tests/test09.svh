//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 2/12/2013 
//-----------------------------------------------------------------
// Description:
// test09 class definition as part of test09_pkg
// Negative Test holds clkack , clk ungate on slices 0 and 1
//------------------------------------------------------------------

`ifndef INC_test09
`define INC_test09 

/**
 * TODO: Add class description
 */
class test09 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test09)
endclass :test09

/**
 * test09 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test09 
 */
function test09::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test09 class OVM build phase
 ******************************************************************************/
function void test09::build ();
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
	   					  .req0_to_ack0(6), .clkack_delay(8));
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF0_PORT0"), .usync_enabled(1), .dcg_blk_num(2), .clk_src(5),
	   					  .clk1_to_ack1(4), .req0_to_ack0(3), .clkack_delay(10));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF0_PORT1"), .clk_src(5), .half_divide_ratio(0), .dcg_blk_num(2),
	   					  .req1_to_clk1(1ns), .req0_to_ack0(4));  //8
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF0_PORT2"), .clk_src(3), .half_divide_ratio(1));  //16
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF0_PORT4"));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF0_PORT5"), .clk_status(ccu_types::CLK_UNGATED),
   						  .req1_to_clk1(40ps),.clk1_to_ack1(2), .req0_to_ack0(4), .clkack_delay(9));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF0_PORT6"), .usync_enabled(1));
 
endfunction :build

/******************************************************************************
 * test09 class OVM run phase
 ******************************************************************************/
task test09::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);

  `ovm_info ("test09", "Handshake delay test issues different runtime delay parameters on slice 1 and 2", OVM_INFO)

  repeat (40)
  //repeat (10) 
  begin
    #1000;
    assert (xaction.randomize() with {slice_num inside {1,2};cmd inside {ccu_types::CLKACK_DLY,ccu_types::REQ1_TO_CLK1,ccu_types::REQ0_TO_ACK0, ccu_types::CLK1_TO_ACK1};});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
  end
  ovm_top.stop_request();

endtask

`endif //INC_test09

