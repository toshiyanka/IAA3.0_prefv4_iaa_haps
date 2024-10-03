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
//  Desc    : Test island for use with hip_pg_agent
//
//------------------------------------------------------------------------------

module hip_pg_ti #( int NUM_DOMAINS = 1, 
		    string IP_ENV_TO_AGT_PATH = "",
       		    string NAME = "" )
                  ( interface hip_pg_if );

  import ovm_pkg::*;
  import hip_pg_pkg::*;

  //DBV 
  //ovm_container hip_pg_ifc;
  ovm_container #(virtual hip_pg_if) hip_pg_ifc; 

  // Take interface referenced by TI instantiation, put it in a container, and
  // pass the container to the list of containers (static) for all hip_pg_vc
  // instantiations.  Their build:: function will then check its configs and
  // look for the relevant interface for each config (based on NAME field)

  initial begin
    hip_pg_ifc = new();
    set_config_object("*", "interface",hip_pg_ifc,0);
    hip_pg_ifc.name = NAME;
    hip_pg_ifc.val = hip_pg_if;
    hip_pg_vc::set_ifc(hip_pg_ifc);
  end

//------------------------------------------------------------------
// No checker has been written yet, but this is where it would go
//------------------------------------------------------------------
//
//  string checker_name = {IP_ENV_TO_AGT_PATH," hip_pg_ti checker"};
//
//  `include "hip_pg_checker.svh" 

endmodule: hip_pg_ti

