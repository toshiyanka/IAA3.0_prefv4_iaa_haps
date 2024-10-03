//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : sshah3
// Date Created : 12-08-2011 
//-----------------------------------------------------------------
// Description:
// Out f Band Package
//------------------------------------------------------------------

package psmi_oob_pkg;
  // Import/include resources common to all package members
  `include "ovm_macros.svh"    
  import ovm_pkg::*;  
  // Saola
  //`include "sla_macros.svh"   
  import sla_pkg::*;  

  `include "psmi_oob_base.svh"
  `include "psmi_oob_cfg.svh" 
  `include "psmi_oob_xaction.svh"
  `include "psmi_oob_seqr.svh"
  `include "psmi_oob_seq.svh" 
  `include "psmi_oob_driver.svh"
  `include "psmi_oob_monitor.svh"    
  `include "psmi_oob_agt.svh"  

endpackage: psmi_oob_pkg
