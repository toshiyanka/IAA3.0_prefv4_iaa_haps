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
package ccu_vc_pkg;
   //------------------------------------------
   // Needed Packages 
   //------------------------------------------

   // OVM
   import ovm_pkg::*;
   `include "ovm_macros.svh"

   // Saola
   import sla_pkg::*;
   `include "sla_macros.svh"

   // CCU_CRG PKG
   import ccu_crg_pkg::*;

   // OOB PKG
   import ccu_ob_pkg::*;

  //------------------------------------------
   // Classes definitions 
   //------------------------------------------

   // Types
   `include "ccu_vc_params.svh"
   `include "ccu_types.svh"

   // VC Cfg
   `include "clksrc_cfg.svh"
   `include "slice_cfg.svh"
   `include "ccu_vc_cfg.svh"

   //randomization class
   `include "ccu_vc_rand_delays.svh"

   // VC files 
   `include "ccu_xaction.svh"
   `include "ccu_driver.svh"
   `include "ccu_seqr.svh"
   `include "ccu_seq.svh"
   `include "dcg_controller.svh"
   `include "ccu_vc.svh"

endpackage :ccu_vc_pkg

