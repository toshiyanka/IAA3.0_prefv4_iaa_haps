//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// Out f Band Package
//------------------------------------------------------------------

package ccu_ob_pkg;
  // Import/include resources common to all package members

  localparam NUM_SLICES = 4;

  `include "ovm_macros.svh"
  import ovm_pkg::*;

  `include "ccu_vc_params.svh"
  `include "ccu_ob_base.svh"
  `include "ccu_ob_cfg.svh" 
  `include "ccu_ob_xaction.svh"
  `include "ccu_ob_seqr.svh"
  `include "ccu_ob_seq.svh" 
  `include "ccu_ob_driver.svh"
  `include "ccu_ob_monitor.svh"    
  `include "ccu_ob_agt.svh"  

endpackage: ccu_ob_pkg
