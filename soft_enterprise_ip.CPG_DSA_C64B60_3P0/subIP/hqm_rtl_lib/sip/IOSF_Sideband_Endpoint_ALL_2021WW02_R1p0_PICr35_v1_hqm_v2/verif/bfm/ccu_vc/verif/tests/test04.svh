//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr
// Date Created : 2012-01-10 
//-----------------------------------------------------------------
// Description:
// test04 class definition as part of test04_pkg
// It is a self-checking test that makes sure all the ccu driver 
// operations work as expected
//------------------------------------------------------------------

`ifndef INC_test04
`define INC_test04 

/**
 * TODO: Add class description
 */
class test04 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test04)
endclass :test04

/**
 * test04 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test04 
 */
function test04::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test04 class OVM build phase
 ******************************************************************************/
function void test04::build ();
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
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF0_PORT0"), .dcg_blk_num(0));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF0_PORT1"), .clk_src(5), .half_divide_ratio(1));  //8
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF0_PORT2"), .clk_status(ccu_types::CLK_UNGATED),.clk_src(3), .half_divide_ratio(1));  //16
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF0_PORT4"), .dcg_blk_num(0), .req0_to_ack0(18), .clkack_delay(10));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF0_PORT5"), .clk_status(ccu_types::CLK_GATED),.dcg_blk_num(0), .set_zero_delay(1));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF0_PORT6"), .clk_status(ccu_types::CLK_GATED),.dcg_blk_num(0), .set_zero_delay(1));


   //i_ccu_vc_cfg.set_to_passive();
endfunction :build

/******************************************************************************
 * test04 class OVM run phase
 ******************************************************************************/
task test04::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);
  assert(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i != null);
  
  `ovm_info ("test04", "Self-Checking Focus Test checks each ccu driver Operation", OVM_INFO)

    #10000;
    assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::DIVIDE_RATIO;div_ratio==ccu_types::DIV_2;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);

	#20000;
	if(i_ccu_vc_cfg.slices[3].divide_ratio !== ccu_types::DIV_2)
		`ovm_error("TEST 04",$psprintf("Slice num 3 divide ratio is %0d instead of DIV_2",i_ccu_vc_cfg.slices[3].divide_ratio))
	
	assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::HALF_DIVIDE_RATIO;half_div_ratio==0;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);

	#20000;
	if(i_ccu_vc_cfg.slices[3].half_divide_ratio !== 0)
		`ovm_error("TEST 04",$psprintf("Slice num 3 half divide ratio is %0d instead of 0",i_ccu_vc_cfg.slices[3].half_divide_ratio))
	
	assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::CLK_SRC;clk_src==0;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);

	#20000;
	if(i_ccu_vc_cfg.slices[3].clk_src !== 0)
		`ovm_error("TEST 04",$psprintf("Slice num 3 clk src is %0d instead of 0",i_ccu_vc_cfg.slices[3].clk_src))
	//
	#20000;
	assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::CLK_SRC;clk_src==0;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);

	#20000;
	//
	assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::FREQ_CHANGE_DLY;freq_change_delay==5;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);


	#20000;
	if(i_ccu_vc_cfg.slices[3].freq_change_delay !== 5)
		`ovm_error("TEST 04",$psprintf("Slice num 3 freq change delay is %0d instead of 5",i_ccu_vc_cfg.slices[3].freq_change_delay))
	
	assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::GATE;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);

	#51000;
	if(i_ccu_vc_cfg.slices[3].clk_status !== ccu_types::GATE)
		`ovm_error("TEST 04",$psprintf("Slice num 3 clk_status is UNGATE instead of GATE"))
	assert (xaction.randomize() with {slice_num==3;cmd==ccu_types::UNGATE;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);

	#10000;
	if(i_ccu_vc_cfg.slices[3].clk_status !== ccu_types::UNGATE)
		`ovm_error("TEST 04",$psprintf("Slice num 3 clk_status is GATE instead of UNGATE"))

  ovm_top.stop_request();

endtask

`endif //INC_test04

