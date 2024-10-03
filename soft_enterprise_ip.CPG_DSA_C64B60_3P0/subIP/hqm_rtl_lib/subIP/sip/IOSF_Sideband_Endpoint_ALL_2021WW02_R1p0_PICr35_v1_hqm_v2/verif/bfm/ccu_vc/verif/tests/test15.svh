//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 2012-01-10 
//-----------------------------------------------------------------
// Description:
// test15 class definition as part of test15_pkg
// usync generated based on clock freq given by BXT soc 2013
// takes 30secs to run
//------------------------------------------------------------------

`ifndef INC_test15
`define INC_test15 

/**
 * TODO: Add class description
 */
class test15 extends ccu_vc_test_base;
   //------------------------------------------
   // Data Members 
   //------------------------------------------
	time clk_period;
	string str;
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
   `ovm_component_utils (ccu_vc_test_pkg::test15)
endclass :test15

/**
 * test15 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test15 
 */
function test15::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test15 class OVM build phase
 ******************************************************************************/
function void test15::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
   
   // Configure children
   // ------------------
   i_ccu_vc_cfg.add_clk_source(0, "PSF0_CLK", 625ps);
   i_ccu_vc_cfg.add_clk_source(5, "PSF1_CLK", 2.66ps);
   i_ccu_vc_cfg.add_clk_source(3, "PSF3_CLK", 153ps);	

   //i_ccu_vc_cfg.randomize_clk_sources();
   i_ccu_vc_cfg.set_ref_clk_src(0);
   i_ccu_vc_cfg.set_global_usync_counter(16'h5F); //61 //17
   //enable gusync counter from start 
   i_ccu_vc_cfg.ctrl_gusync_cnt(1);
   i_ccu_vc_cfg.add_slice(.slice_num(0), .slice_name("PSF0"), .clk_status(ccu_types::CLK_UNGATED), .usync_enabled(0), .enable_random_phase(0));
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF0_PORT0"), .usync_enabled(1), .clk_status(ccu_types::CLK_UNGATED), .divide_ratio(ccu_types::DIV_4), .enable_random_phase(0));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF0_PORT1"), .half_divide_ratio(0), .usync_enabled(1),.divide_ratio(ccu_types::DIV_4), .clk_status(ccu_types::CLK_UNGATED), .enable_random_phase(0));  //8
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF0_PORT2"), .clk_src(3), .half_divide_ratio(0),.divide_ratio(ccu_types::DIV_3), .enable_random_phase(0));  //16
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF0_PORT4"), .clk_status(ccu_types::CLK_UNGATED),
	   					  .usync_enabled(1),.divide_ratio(ccu_types::DIV_3), .enable_random_phase(0), .randomize_clkack_delay(1), .clkack_delay(20));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF0_PORT5"), .clk_status(ccu_types::CLK_UNGATED),.usync_enabled(1), .divide_ratio(ccu_types::DIV_8), .enable_random_phase(0));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF0_PORT6"), .clk_status(ccu_types::CLK_UNGATED),.usync_enabled(1), .divide_ratio(ccu_types::DIV_8), .enable_random_phase(0));
   //i_ccu_vc_cfg.set_ref_clk_src(0);

endfunction :build

/******************************************************************************
 * test15 class OVM run phase
 ******************************************************************************/
task test15::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);

  `ovm_info ("test15", "Test randomly gates/ungates and divides clks", OVM_INFO)

	#1000ps;
  clk_period = i_ccu_vc_cfg.get_clk_period(4);
  $timeformat(-12, 0, "ps", 5);
  $sformat(str, "CLK SLICE 4 clk period = %0t",clk_period);
  `ovm_info("test15",str,OVM_INFO)
  
  //repeat (40)
  repeat (4) 
  begin
    #30000ns;
    assert (xaction.randomize() with {slice_num==5;cmd==ccu_types::CLKACK_DLY;clkack_delay==12;});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
  end
  ovm_top.stop_request();

endtask

`endif //INC_test15

