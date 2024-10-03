//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2011 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : bosman3 
// Date Created : 2012-06-03 
//-----------------------------------------------------------------
// Description:
// ccu_vc_pkg package definition
//------------------------------------------------------------------

/**
 * ccu_vc Collateral Top Level Package
 */
package ccu_vc_env_pkg;
   //------------------------------------------
   // Needed Packages 
   //------------------------------------------

   // OVM
   import ovm_pkg::*;
   `include "ovm_macros.svh"

   // Saola
   import sla_pkg::*;
   `include "sla_macros.svh"

   import ccu_vc_pkg::*;

   `include "sla_macros.svh"
   // Note: Put all other imports here, 
   // don't import directly in class files
   
   //------------------------------------------
   // Classes definitions 
   //------------------------------------------

   // Environment
   `include "ccu_vc_env.svh"

   // Base Test
   `include "ccu_vc_test_base.svh"
endpackage :ccu_vc_env_pkg

