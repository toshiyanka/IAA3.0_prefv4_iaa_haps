//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_vc_env class definition as part of ccu_vc_pkg
//------------------------------------------------------------------

`ifndef INC_ccu_vc_env
`define INC_ccu_vc_env 

/**
 * Top level OVM environment for ccu_vc wrapper
 */
class ccu_vc_env extends ovm_env;
   //------------------------------------------
   // Data Members 
   //------------------------------------------

   // Reference to config descriptor
   ccu_vc i_ccu_vc_1;
   ccu_vc i_ccu_vc_2;
   
   //------------------------------------------
   // Methods 
   //------------------------------------------
   
   // Standard OVM Methods 
   extern function       new   (string name = "", ovm_component parent = null);
   extern function void  build ();
   
   // OVM Macros 
   `ovm_component_utils (ccu_vc_env_pkg::ccu_vc_env)
endclass :ccu_vc_env

/**
 * ccu_vc_env Class constructor
 * @param   name     OVM component hierarchal name
 * @param   parent   OVM parent component
 * @return           A new object of type ccu_vc_env 
 */
function ccu_vc_env::new (string name = "", ovm_component parent = null);
   // Super constructor
   super.new (name, parent);
endfunction :new

/**
 * ccu_vc_env class OVM build phase
 */
function void ccu_vc_env::build ();
   // Super builder
   // -------------
   super.build ();
   
   // Get configuration
   // -----------------
     
   // Construct children
   // ------------------
   i_ccu_vc_1 = ccu_vc::type_id::create("ccu_vc_1", this);
   i_ccu_vc_2 = ccu_vc::type_id::create("ccu_vc_2", this);
   // Configure children
   // ------------------
endfunction :build

`endif //INC_ccu_vc_env

