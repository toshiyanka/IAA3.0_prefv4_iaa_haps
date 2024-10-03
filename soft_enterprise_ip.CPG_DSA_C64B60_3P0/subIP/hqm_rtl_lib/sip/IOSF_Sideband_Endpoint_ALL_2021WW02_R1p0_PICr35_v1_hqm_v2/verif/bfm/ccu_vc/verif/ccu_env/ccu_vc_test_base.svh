//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_vc_test_base class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_vc_test_base
`define INC_ccu_vc_test_base 

/**
 * ccu_vc Base Test
 */
class ccu_vc_test_base extends ovm_test;
   //------------------------------------------
   // Data Members 
   //------------------------------------------

   // Top level config
   protected ccu_vc_cfg i_ccu_vc_cfg;
   protected ccu_vc_cfg i_ccu_vc_cfg2;
   // Top level environment
   ccu_vc_env i_ccu_vc_env;
 
   //------------------------------------------
   // Methods 
   //------------------------------------------
  
   // Standard OVM Methods 
   extern function new (string name = "", ovm_component parent = null);
   extern function void build ();
   extern function void end_of_elaboration ();
   extern task          run   ();
   
   // APIs 
   extern protected virtual function void do_create_env   ();
   extern protected virtual function void do_create_cfg   ();
   extern protected virtual function void do_populate_cfg ();
   extern protected virtual function void do_configure_env();

   // OVM Macros 
   `ovm_component_utils (ccu_vc_env_pkg::ccu_vc_test_base)
endclass :ccu_vc_test_base

/**
 * ccu_vc_test_base Class constructor
 * @param   name  OVM name
 * @return        A new object of type ccu_vc_test_base 
 */
function ccu_vc_test_base::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/**
 * ccu_vc_test_base class OVM build phase
 */
function void ccu_vc_test_base::build ();
   // Super builder
   // -------------
   super.build ();
  
   // Divide build logic into a series of virtual functions to allow test
   // write to override certain parts as needed (template method pattern)
   do_create_env   ();
   do_create_cfg   ();
   do_populate_cfg ();
   do_configure_env();
   
   // Configure children
   // ------------------
endfunction :build

/**
 * Creates the top level environment, can be overridden by derivative tests
 * to customize behavior
 */
function void ccu_vc_test_base::do_create_env();
   i_ccu_vc_env = ccu_vc_env::type_id::create ("ovm_ccu_vc_env" ,this);
endfunction : do_create_env

/**
 * Creates the top level configuration descriptor, can be overridden by 
 * derivative tests to customize behavior
 */
function void ccu_vc_test_base::do_create_cfg();
   i_ccu_vc_cfg = ccu_vc_cfg::type_id::create ("i_ccu_vc_cfg");
   i_ccu_vc_cfg2 = ccu_vc_cfg::type_id::create ("i_ccu_vc_cfg2");
endfunction : do_create_cfg

/**
 * Populates the top level configuration descriptor with desired configuration
 * should be overridden by derivative tests if a configuration other than the
 * default configuration is required
 */
function void ccu_vc_test_base::do_populate_cfg();
   if ( ! i_ccu_vc_cfg.randomize() )
      `ovm_error (get_type_name (), "Randomization failed for ccu_vc cfg")
   if ( ! i_ccu_vc_cfg2.randomize() )
      `ovm_error (get_type_name (), "Randomization failed for ccu_vc cfg2")

endfunction : do_populate_cfg

/**
 * Configures the top level environment with the top level configuration 
 * descriptor, can be overridden by derivative tests to customize behavior
 */
function void ccu_vc_test_base::do_configure_env();
   // Print Configuration
   `ovm_info (get_type_name(), $psprintf( "Passing Configuration:\n%s", i_ccu_vc_cfg.sprint() ), OVM_HIGH)

   // Pass configuration down
   set_config_object ("*ovm_ccu_vc_env.ccu_vc_1*", "CCU_VC_CFG", i_ccu_vc_cfg, 0);
   set_config_object ("*ovm_ccu_vc_env.ccu_vc_2*", "CCU_VC_CFG", i_ccu_vc_cfg2, 0);
endfunction : do_configure_env

/**
 * ccu_vc_test_base class OVM end_of_elaboration phase
 */
function void ccu_vc_test_base::end_of_elaboration ();
   // super
   super.end_of_elaboration();

   // Adjust timeout
   set_global_timeout(ccu_types::default_timeout); 
endfunction : end_of_elaboration

/**
 * ccu_vc_test_base class OVM run phase
 */
task ccu_vc_test_base::run();

   // Start banner
   `ovm_info (get_type_name(), "Ending Test", OVM_LOW);
   // Warn that no test is defined yet
   `ovm_warning(get_type_name(), "No test defined yet");

   // Wait some time
   repeat(10_000) //10_000 clocks = 100_000 ns = 100us
      @(sla_tb_env::sys_clk_r);

   `ovm_info (get_type_name(), "Ending Test", OVM_LOW);

   // Global Stop Request
   global_stop_request();
endtask : run


`endif //INC_ccu_vc_test_base

