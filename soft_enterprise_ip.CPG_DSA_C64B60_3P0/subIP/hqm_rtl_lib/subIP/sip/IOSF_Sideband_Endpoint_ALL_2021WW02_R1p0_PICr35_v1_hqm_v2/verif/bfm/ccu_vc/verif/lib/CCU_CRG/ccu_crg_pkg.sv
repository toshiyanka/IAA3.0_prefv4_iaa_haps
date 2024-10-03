//-----------------------------------------------------------------
// Intel Proprietary -- Copyright 2010 Intel -- All rights reserved 
//-----------------------------------------------------------------
// Author       : njfotari
// Date Created : 25-02-2011 
//-----------------------------------------------------------------
// Description:
// Clock Reset Generator Package
//------------------------------------------------------------------

package ccu_crg_pkg;

	`ifdef VCS 
		`ifndef IGNORE_CCU_CRG_TIMEPREC
	 		timeprecision 1fs;
		`endif
	`endif
  // Import/include resources common to all package members
  `include "ovm_macros.svh"
  import ovm_pkg::*;
  import sla_pkg::*;
//  import sip_vintf_pkg::*;

  `include "ccu_crg.svh"

  //`include "ccu_crg_intf.sv"
  `include "ccu_crg_param_cfg.svh"
  //`include "ccu_crg_intf_wrapper.svh"
  `include "ccu_clk_cfg.svh"
  `include "ccu_crg_domain_cfg.svh"
  `include "ccu_crg_rst_cfg.svh"
  `include "ccu_crg_cfg.svh"
  `include "ccu_crg_xaction.svh"
  `include "ccu_crg_seqr.svh"
  `include "ccu_crg_seq.svh"
  `include "ccu_clk_ctrl_seq.svh"
  `include "ccu_rst_ctrl_seq.svh"
  `include "ccu_crg_seq_lib.svh"
  `include "ccu_crg_driver.svh"
  `include "ccu_crg_monitor.svh"
  `include "ccu_crg_checker.svh"
  `include "ccu_crg_agt.svh"

endpackage : ccu_crg_pkg

