//------------------------------------------------------------------------------
//  Copyright (c)
//  2010 Intel Corporation, all rights reserved.
//
//  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY
//  PROTECTED BY COPYRIGHT LAWS AND IS CONSIDERED A
//  TRADE SECRET BELONGING TO THE INTEL CORPORATION.
//------------------------------------------------------------------------------
//
//  Author  : Bill Bradley
//  Email   : william.l.bradley@intel.com
//  Date    : November 4, 2013
//  Desc    : Package with all related files and common struct definitions for
//            the SoC Chassis HIP Power Management spec.
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// package: hip_pg_pkg
// Package with all related files
//------------------------------------------------------------------------------
package hip_pg_pkg;

  import ovm_pkg::*;

  class ovm_container #(type T=int) extends ovm_object;
    string name;
    T val;
  endclass
 
  `include "ovm_macros.svh"
  //Bill B. confrimed this file is not needed
  //`include "macros_tb.svh"
  
  `include "hip_pg.svh"

  typedef class hip_pg_agent;
   
  `include "hip_pg_config.sv"
  `include "hip_pg_xaction.sv"
  `include "hip_pg_xaction_mon.sv"
  `include "hip_pg_sequencer.sv"
  `include "hip_pg_driver.sv"
  `include "hip_pg_monitor.sv"
  `include "hip_pg_agent.sv"
  `include "hip_pg_vc_config.sv"
  `include "hip_pg_vc.sv"

endpackage : hip_pg_pkg

// Test Island can't be in the package

`include "hip_pg_ti.sv"
