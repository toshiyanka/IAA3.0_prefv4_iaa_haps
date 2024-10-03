//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : melmalak 
// Date Created : 2010-08-12 
//-----------------------------------------------------------------
// Description:
// sip_vintf_pkg package definition
//------------------------------------------------------------------

/**
 * Virtual interface manager, using sip_ prefixes to be promoted
 * to saola
 */
package sip_vintf_pkg;
   //------------------------------------------
   // Needed Packages 
   //------------------------------------------
   import ovm_pkg::*;
   `include "ovm_macros.svh"
   
   //------------------------------------------
   // Classes definitions 
   //------------------------------------------
   `include "sip_vintf_container_base.svh"
   `include "sip_vintf_container.svh"
   `include "sip_vintf_manager.svh"
   `include "sip_vintf_proxy.svh"
endpackage :sip_vintf_pkg

