//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 5/5/2013 
//-----------------------------------------------------------------
// Description:
// test13 class definition as part of test13_pkg
// Enable random phase checking test, all slices should be coming
// out of phase random phase relation every test
// Keep changing the freq change delay all the time and then issue
// the DIV ratio switching command 
//------------------------------------------------------------------

`ifndef INC_test13
`define INC_test13 

/**
 * TODO: Add class description
 */
class test13 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test13)
endclass :test13

/**
 * test13 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test13 
 */
function test13::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test13 class OVM build phase
 ******************************************************************************/
function void test13::build ();
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
   i_ccu_vc_cfg.add_clk_source(1, "PSF1_CLK", 10);
   i_ccu_vc_cfg.add_clk_source(2, "PSF2_CLK", 10);
   i_ccu_vc_cfg.add_clk_source(3, "PSF3_CLK", 10);
   i_ccu_vc_cfg.add_clk_source(4, "PSF4_CLK", 10);
   i_ccu_vc_cfg.add_clk_source(5, "PSF5_CLK", 10);
   i_ccu_vc_cfg.add_clk_source(6, "PSF6_CLK", 10);

   i_ccu_vc_cfg.set_ref_clk_src(0);
   i_ccu_vc_cfg.add_slice(.slice_num(0), .slice_name("PSF0"), .clk_src(0), .clk_status(ccu_types::CLK_GATED), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(1), .slice_name("PSF1"), .clk_src(1), .clk_status(ccu_types::CLK_GATED), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(2), .slice_name("PSF2"), .clk_src(2), .clk_status(ccu_types::CLK_GATED), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(3), .slice_name("PSF3"), .clk_src(3), .clk_status(ccu_types::CLK_GATED), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(4), .slice_name("PSF4"), .clk_src(4), .clk_status(ccu_types::CLK_GATED), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(5), .slice_name("PSF5"), .clk_src(5), .clk_status(ccu_types::CLK_GATED), .enable_random_phase(1));
   i_ccu_vc_cfg.add_slice(.slice_num(6), .slice_name("PSF6"), .clk_src(6), .clk_status(ccu_types::CLK_GATED), .enable_random_phase(1));
 
endfunction :build

/******************************************************************************
 * test13 class OVM run phase
 ******************************************************************************/
task test13::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);

  `ovm_info ("test13", "Handshake delay randomized along with the random phase", OVM_INFO)

  repeat (40)
  //repeat (10) 
  begin
    #1000;
    //assert (xaction.randomize() with {slice_num inside {1,2};cmd==ccu_types::FREQ_CHANGE_DLY;freq_change_delay inside {[30:35]};});
    //seq.xaction = xaction;
    //seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
    //#1000;
	//assert (xaction.randomize() with {slice_num inside {1,2};cmd==ccu_types::DIVIDE_RATIO;div_ratio inside {ccu_types::DIV_2,ccu_types::DIV_1};});
    //seq.xaction = xaction;
    //seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
 
  end
  ovm_top.stop_request();

endtask

`endif //INC_test13

