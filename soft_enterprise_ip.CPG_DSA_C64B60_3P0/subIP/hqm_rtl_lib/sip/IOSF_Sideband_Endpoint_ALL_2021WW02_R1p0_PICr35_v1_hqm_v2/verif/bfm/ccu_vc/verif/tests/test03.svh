//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2012 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : rravindr 
// Date Created : 2012-01-10 
//-----------------------------------------------------------------
// Description:
// test03 class definition as part of test03_pkg
//------------------------------------------------------------------

`ifndef INC_test03
`define INC_test03 

/**
 * TODO: Add class description
 */
class test03 extends ccu_vc_test_base;
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
   `ovm_component_utils (ccu_vc_test_pkg::test03)
endclass :test03

/**
 * test03 Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type test03 
 */
function test03::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/******************************************************************************
 * test03 class OVM build phase
 ******************************************************************************/
function void test03::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
   
   // Configure children
   // ------------------
   i_ccu_vc_cfg.randomize_clk_sources();
   i_ccu_vc_cfg.set_ref_clk_src(0);
   i_ccu_vc_cfg.add_slice(0, "PSF0", 0, ccu_types::CLK_GATED, ccu_types::DIV_4, 1);
   i_ccu_vc_cfg.add_slice(1, "PSF0_PORT0", 10, ccu_types::CLK_GATED, ccu_types::DIV_2, 1);
   i_ccu_vc_cfg.add_slice(2, "PSF0_PORT1", 5, ccu_types::CLK_GATED, ccu_types::DIV_8, 1);
   i_ccu_vc_cfg.add_slice(3, "PSF0_PORT2", 3, ccu_types::CLK_GATED, ccu_types::DIV_16, 1);
   i_ccu_vc_cfg.add_slice(4, "PSF0_PORT3", 4, ccu_types::CLK_GATED, ccu_types::DIV_4, 0);
   i_ccu_vc_cfg.add_slice(5, "PSF0_PORT4", 5, ccu_types::CLK_GATED, ccu_types::DIV_2);
   i_ccu_vc_cfg.add_slice(6, "PSF0_PORT5", 6, ccu_types::CLK_GATED, ccu_types::DIV_2);
endfunction :build

/******************************************************************************
 * test03 class OVM run phase
 ******************************************************************************/
task test03::run();
  ccu_seq seq = ccu_seq::type_id::create("ccu_seq");
  ccu_xaction xaction = ccu_xaction::type_id::create("ccu_xaction");
  xaction.set_cfg(i_ccu_vc_cfg);

  `ovm_info ("Test03", "Test USYNC functionality", OVM_INFO)
  #100000;
  repeat (40) 
  begin
    #10000;
    assert (xaction.randomize() with {cmd inside {/*ccu_types::DIVIDE_RATIO,*/ ccu_types::EN_USYNC,
	ccu_types::DIS_USYNC, ccu_types::CLK_GATED, ccu_types::CLKACK_DLY, ccu_types::HALF_DIVIDE_RATIO};});
    seq.xaction = xaction;
    seq.start(i_ccu_vc_env.i_ccu_vc_1.ccu_sqr_i);
  end
  //i_ccu_vc_cfg.print();
  ovm_top.stop_request();

endtask

`endif //INC_test03

