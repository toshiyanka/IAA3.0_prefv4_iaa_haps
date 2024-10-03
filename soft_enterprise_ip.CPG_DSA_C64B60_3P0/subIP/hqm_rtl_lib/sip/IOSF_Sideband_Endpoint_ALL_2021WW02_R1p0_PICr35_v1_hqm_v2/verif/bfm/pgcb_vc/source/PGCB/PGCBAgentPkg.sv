/*
================================================================================
  Copyright (c) 2011 Intel Corporation, all rights reserved.

  THIS PROGRAM IS AN UNPUBLISHED WORK FULLY PROTECTED BY COPYRIGHT LAWS AND IS 
  CONSIDERED A TRADE SECRET BELONGING TO THE INTEL CORPORATION.
================================================================================

  Author          : 
  Email           : 
  Phone           : 
  Date            : 

================================================================================
  Description     : One line description of this class
  
Write your wordy description here.
================================================================================
*/
package PGCBAgentPkg;

	`include "ovm_macros.svh"
	`include "sla_macros.svh"
	import ovm_pkg::*;
	import sla_pkg::*;
	import PowerGatingParamsPkg::*;
	import PowerGatingCommonPkg::*;
	`ifdef VCS_EXPORT_SUPPORT
          export PowerGatingCommonPkg::*;
        `endif

	`include "PGCBAgentInclude.svh"

endpackage: PGCBAgentPkg
